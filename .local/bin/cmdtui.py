#!/usr/bin/env python3
"""
cmdtui — config-driven command launcher TUI.

Looks for a `.cmdtui.json` file starting in the current directory and
walking upward (like git/.clangd discovery), so it works from any
subdirectory of a project. Groups of commands are bound to keys; pick a
group, pick a command, watch it stream into the output pane live.

Run:
    python3 cmdtui.py            # discovers .cmdtui.json from cwd upward
    python3 cmdtui.py path/to/config.json

Requires: textual  (pip install textual --break-system-packages)
"""

from __future__ import annotations

import asyncio
import json
import os
import signal
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.containers import Horizontal, Vertical
from textual.screen import Screen, ModalScreen
from textual.widgets import Header, Footer, ListView, ListItem, Label, Static, Input, TextArea

CONFIG_NAME = ".cmdtui.json"


# ---------------------------------------------------------------- data model

@dataclass
class Command:
    key: str
    label: str
    cmd: str
    cwd: Optional[str] = None


@dataclass
class Group:
    name: str
    key: str = ""
    commands: list[Command] = field(default_factory=list)


def find_config(start: Path) -> Optional[Path]:
    """Walk upward from `start` looking for CONFIG_NAME, like git does for .git."""
    d = start.resolve()
    while True:
        candidate = d / CONFIG_NAME
        if candidate.exists():
            return candidate
        if d.parent == d:
            return None
        d = d.parent


def load_config(path: Path) -> list[Group]:
    data = json.loads(path.read_text())
    groups = []
    for g in data.get("groups", []):
        cmds = [Command(**c) for c in g.get("commands", [])]
        groups.append(Group(name=g.get("name", "Group"), key=g.get("key", ""), commands=cmds))
    return groups


def save_config(path: Path, groups: list[Group]) -> None:
    data = {"groups": [
        {"name": g.name, "key": g.key, "commands": [asdict(c) for c in g.commands]}
        for g in groups
    ]}
    path.write_text(json.dumps(data, indent=2) + "\n")


# --------------------------------------------------------------------- forms

class FormModal(ModalScreen[Optional[dict]]):
    """Generic small form: a title, a set of labeled Input fields, Enter to submit, Esc to cancel."""

    DEFAULT_CSS = """
    FormModal {
        align: center middle;
    }
    #form-box {
        width: 60;
        border: round $accent;
        background: $panel;
        padding: 1 2;
    }
    #form-box Label.field {
        color: $text-muted;
        margin-top: 1;
    }
    #form-title {
        text-style: bold;
        color: $accent;
    }
    #form-hint {
        color: $text-muted;
        margin-top: 1;
    }
    #form-error {
        color: $error;
        margin-top: 1;
        text-style: bold;
    }
    """

    def __init__(self, title: str, fields: list[tuple[str, str, str]], validate=None):
        # fields: list of (field_id, label, default_value)
        # validate: optional callable(dict) -> Optional[str] error message
        super().__init__()
        self.title_text = title
        self.fields = fields
        self.validate = validate

    def compose(self) -> ComposeResult:
        with Vertical(id="form-box"):
            yield Label(self.title_text, id="form-title")
            for field_id, label, default in self.fields:
                yield Label(label, classes="field")
                yield Input(value=default, id=f"in-{field_id}")
            yield Label("", id="form-error")
            yield Label("enter: save   esc: cancel", id="form-hint")

    def on_input_submitted(self, event: Input.Submitted) -> None:
        self._submit()

    def key_escape(self) -> None:
        self.dismiss(None)

    def _submit(self) -> None:
        result = {}
        for field_id, _label, _default in self.fields:
            result[field_id] = self.query_one(f"#in-{field_id}", Input).value.strip()
        if self.validate is not None:
            error = self.validate(result)
            if error:
                self.query_one("#form-error", Label).update(error)
                return
        self.dismiss(result)


class ConfirmModal(ModalScreen[bool]):
    DEFAULT_CSS = """
    ConfirmModal { align: center middle; }
    #confirm-box {
        width: 50;
        border: round $error;
        background: $panel;
        padding: 1 2;
    }
    """

    def __init__(self, message: str):
        super().__init__()
        self.message = message

    def compose(self) -> ComposeResult:
        with Vertical(id="confirm-box"):
            yield Label(self.message)
            yield Label("y: confirm   n/esc: cancel", classes="field")

    def key_y(self) -> None:
        self.dismiss(True)

    def key_n(self) -> None:
        self.dismiss(False)

    def key_escape(self) -> None:
        self.dismiss(False)


# ------------------------------------------------------------- welcome/error

class WelcomeScreen(Screen):
    """Shown when no config file was found anywhere above the cwd."""

    BINDINGS = [Binding("n", "create", "Create config here"), Binding("q", "quit", "Quit")]

    def __init__(self, target_path: Path):
        super().__init__()
        self.target_path = target_path

    def compose(self) -> ComposeResult:
        yield Header()
        yield Static(
            f"No [b]{CONFIG_NAME}[/b] found in this directory or any parent.\n\n"
            f"Press [b]n[/b] to create one at:\n  {self.target_path}\n\n"
            f"Press [b]q[/b] to quit.",
            id="welcome-msg",
        )
        yield Footer()

    def action_create(self) -> None:
        save_config(self.target_path, [])
        self.app.push_screen(MainScreen(self.target_path, []))

    def action_quit(self) -> None:
        self.app.exit()


class ConfigErrorScreen(Screen):
    BINDINGS = [Binding("q", "quit", "Quit")]

    def __init__(self, path: Path, error: str):
        super().__init__()
        self.path = path
        self.error = error

    def compose(self) -> ComposeResult:
        yield Header()
        yield Static(
            f"[b red]Could not parse {self.path}[/b red]\n\n{self.error}\n\n"
            f"Fix the file by hand and restart, or delete it to start fresh.\n\n"
            f"Press [b]q[/b] to quit.",
            id="error-msg",
        )
        yield Footer()

    def action_quit(self) -> None:
        self.app.exit()


# ------------------------------------------------------------------- main UI

class MainScreen(Screen):
    BINDINGS = [
        Binding("tab", "toggle_panel", "Switch panel", show=False),
        Binding("j", "next_group", "Next group"),
        Binding("k", "prev_group", "Prev group"),
        Binding("a", "add_command", "Add command"),
        Binding("A", "add_group", "Add group"),
        Binding("e", "edit_command", "Edit"),
        Binding("d", "delete_item", "Delete"),
        Binding("x", "cancel_run", "Cancel run"),
        Binding("q", "quit", "Quit"),
    ]

    # Keys the app itself uses. Derived from BINDINGS so it can never drift
    # out of sync when a binding is remapped. Config-defined group/command
    # keys matching any of these are never honoured as hotkeys, and the
    # add/edit forms refuse to save a key from this set.
    RESERVED_KEYS = {b.key for b in BINDINGS if "," not in b.key}

    def __init__(self, config_path: Path, groups: list[Group]):
        super().__init__()
        self.config_path = config_path
        self.groups = groups
        self.group_idx = 0
        self.command_idx = 0
        self.focus_panel = "groups"  # or "commands"
        self.current_proc: Optional[asyncio.subprocess.Process] = None

    def compose(self) -> ComposeResult:
        yield Header(show_clock=False)
        with Horizontal():
            with Vertical(id="sidebar"):
                yield Label("Groups", id="sidebar-title")
                yield ListView(id="group-list")
            with Vertical(id="main-right"):
                yield Label("Commands", id="commands-title")
                yield ListView(id="command-list")
                yield TextArea(id="output", read_only=True, show_line_numbers=False, soft_wrap=True)
        yield Footer()

    def on_mount(self) -> None:
        self.title = f"cmdtui — {self.config_path}"
        self.refresh_groups()
        self.query_one("#group-list", ListView).focus()
        for warning in self.find_keymap_conflicts():
            self.append_output(f"! {warning}")

    def find_keymap_conflicts(self) -> list[str]:
        """Scan the loaded config for keys that collide with the app's own
        bindings or with each other. Called at startup to flag conflicts
        that predate this version's add/edit-time validation (e.g. a
        hand-edited config)."""
        warnings: list[str] = []
        seen_group_keys: dict[str, str] = {}
        for g in self.groups:
            if g.key:
                if g.key in self.RESERVED_KEYS:
                    warnings.append(f"group '{g.name}' key '{g.key}' is reserved by the app and will be ignored")
                elif g.key in seen_group_keys:
                    warnings.append(f"group '{g.name}' key '{g.key}' duplicates group '{seen_group_keys[g.key]}'")
                else:
                    seen_group_keys[g.key] = g.name
            seen_cmd_keys: dict[str, str] = {}
            for c in g.commands:
                if c.key in self.RESERVED_KEYS:
                    warnings.append(f"[{g.name}] command '{c.label}' key '{c.key}' is reserved by the app and will be ignored")
                elif c.key in seen_group_keys:
                    warnings.append(f"[{g.name}] command '{c.label}' key '{c.key}' is shadowed by a group jump key")
                elif c.key in seen_cmd_keys:
                    warnings.append(f"[{g.name}] command '{c.label}' key '{c.key}' duplicates command '{seen_cmd_keys[c.key]}'")
                else:
                    seen_cmd_keys[c.key] = c.label
        return warnings

    # ---- rendering -----------------------------------------------------

    def refresh_groups(self) -> None:
        lv = self.query_one("#group-list", ListView)
        lv.clear()
        for g in self.groups:
            prefix = f"{g.key}  " if g.key else "   "
            lv.append(ListItem(Label(f"{prefix}{g.name}")))
        if self.groups:
            self.group_idx = min(self.group_idx, len(self.groups) - 1)
            lv.index = self.group_idx
        self.refresh_commands()

    def refresh_commands(self) -> None:
        lv = self.query_one("#command-list", ListView)
        lv.clear()
        if not self.groups:
            self.query_one("#commands-title", Label).update("Commands  (press A to add a group)")
            return
        group = self.groups[self.group_idx]
        self.query_one("#commands-title", Label).update(f"Commands — {group.name}")
        for c in group.commands:
            lv.append(ListItem(Label(f"{c.key:<4} {c.label}")))
        if not group.commands:
            lv.append(ListItem(Label("(no commands — press a to add one)")))
        else:
            self.command_idx = min(self.command_idx, len(group.commands) - 1)
            lv.index = self.command_idx

    def current_group(self) -> Optional[Group]:
        if not self.groups:
            return None
        return self.groups[self.group_idx]

    # ---- panel / navigation --------------------------------------------

    def action_toggle_panel(self) -> None:
        if self.focus_panel == "groups":
            self.focus_panel = "commands"
            self.query_one("#command-list", ListView).focus()
        else:
            self.focus_panel = "groups"
            self.query_one("#group-list", ListView).focus()

    def action_prev_group(self) -> None:
        if not self.groups:
            return
        self.group_idx = (self.group_idx - 1) % len(self.groups)
        self.command_idx = 0
        self.query_one("#group-list", ListView).index = self.group_idx
        self.refresh_commands()

    def action_next_group(self) -> None:
        if not self.groups:
            return
        self.group_idx = (self.group_idx + 1) % len(self.groups)
        self.command_idx = 0
        self.query_one("#group-list", ListView).index = self.group_idx
        self.refresh_commands()

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        if event.list_view.id == "group-list":
            self.group_idx = event.list_view.index or 0
            self.refresh_commands()
        elif event.list_view.id == "command-list":
            self.command_idx = event.list_view.index or 0
            self.focus_panel = "commands"
            self.run_command_at(self.command_idx)

    def on_list_view_highlighted(self, event: ListView.Highlighted) -> None:
        if event.list_view.id == "group-list" and event.list_view.index is not None:
            self.group_idx = event.list_view.index
            self.command_idx = 0
            self.refresh_commands()
        elif event.list_view.id == "command-list" and event.list_view.index is not None:
            self.command_idx = event.list_view.index

    # ---- direct key shortcuts (jump to group / run command by its key) --

    def on_key(self, event) -> None:
        key = event.character
        if not key:
            return
        if key in self.RESERVED_KEYS:
            # Never treat an app hotkey as a group/command shortcut, even if
            # a (buggy or stale) config assigned it one — the app's own
            # bindings always win, and this lets the normal binding system
            # handle it instead.
            return
        # group jump keys always work
        for i, g in enumerate(self.groups):
            if g.key and g.key == key:
                self.group_idx = i
                self.query_one("#group-list", ListView).index = i
                self.refresh_commands()
                event.stop()
                return
        # command hotkeys work when not typing elsewhere
        group = self.current_group()
        if group:
            for i, c in enumerate(group.commands):
                if c.key == key:
                    self.command_idx = i
                    self.query_one("#command-list", ListView).index = i
                    self.focus_panel = "commands"
                    self.run_command_at(i)
                    event.stop()
                    return

    # ---- running commands ------------------------------------------------

    def run_command_at(self, idx: int) -> None:
        group = self.current_group()
        if not group or idx >= len(group.commands):
            return
        command = group.commands[idx]
        self.run_worker(self._run(command), exclusive=True)

    def append_output(self, text: str) -> None:
        output = self.query_one("#output", TextArea)
        output.insert(text + "\n", output.document.end)
        output.scroll_end(animate=False)

    async def _run(self, command: Command) -> None:
        output = self.query_one("#output", TextArea)
        if self.current_proc is not None:
            self.append_output("a command is already running — press x to cancel it first")
            return
        self.append_output(f"\n$ {command.cmd}")
        cwd = command.cwd or str(self.config_path.parent)
        try:
            proc = await asyncio.create_subprocess_shell(
                command.cmd,
                cwd=cwd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.STDOUT,
                start_new_session=True,  # own process group, so we can kill the whole tree
            )
        except Exception as exc:  # noqa: BLE001
            self.append_output(f"failed to start: {exc}")
            return
        self.current_proc = proc
        assert proc.stdout is not None
        while True:
            line = await proc.stdout.readline()
            if not line:
                break
            self.append_output(line.decode(errors="replace").rstrip("\n"))
        code = await proc.wait()
        self.append_output(f"-- exit {code} --")
        self.current_proc = None

    def action_cancel_run(self) -> None:
        if self.current_proc is not None:
            try:
                os.killpg(os.getpgid(self.current_proc.pid), signal.SIGTERM)
            except ProcessLookupError:
                pass  # already exited
            self.append_output("-- cancelled --")

    # ---- add / edit / delete --------------------------------------------

    def _validate_group_key(self, key: str) -> Optional[str]:
        if not key:
            return None  # empty is fine, just means "no jump shortcut"
        if key in self.RESERVED_KEYS:
            return f"'{key}' is reserved by the app (see footer) — pick another key"
        if any(g.key == key for g in self.groups):
            return f"'{key}' is already used by another group"
        return None

    def _validate_command_key(self, key: str, group: Group, editing: Optional[Command] = None) -> Optional[str]:
        if not key:
            return "key is required"
        if key in self.RESERVED_KEYS:
            return f"'{key}' is reserved by the app (see footer) — pick another key"
        if any(g.key == key for g in self.groups):
            return f"'{key}' is already a group jump key — it would never reach this command"
        if any(c.key == key and c is not editing for c in group.commands):
            return f"'{key}' is already used by another command in this group"
        return None

    def action_add_group(self) -> None:
        def validate(result: dict) -> Optional[str]:
            if not result.get("name"):
                return "name is required"
            return self._validate_group_key(result.get("key", ""))

        def done(result: Optional[dict]) -> None:
            if not result:
                return
            self.groups.append(Group(name=result["name"], key=result.get("key", "")))
            save_config(self.config_path, self.groups)
            self.group_idx = len(self.groups) - 1
            self.refresh_groups()

        self.app.push_screen(
            FormModal(
                "Add group",
                [("name", "Name", ""), ("key", "Jump key (optional)", "")],
                validate=validate,
            ),
            done,
        )

    def action_add_command(self) -> None:
        group = self.current_group()
        if not group:
            self.action_add_group()
            return

        def validate(result: dict) -> Optional[str]:
            if not result.get("cmd"):
                return "shell command is required"
            return self._validate_command_key(result.get("key", ""), group)

        def done(result: Optional[dict]) -> None:
            if not result:
                return
            group.commands.append(Command(
                key=result["key"],
                label=result.get("label") or result["cmd"],
                cmd=result["cmd"],
                cwd=result.get("cwd") or None,
            ))
            save_config(self.config_path, self.groups)
            self.refresh_commands()

        self.app.push_screen(
            FormModal(
                "Add command",
                [
                    ("key", "Key", ""),
                    ("label", "Label", ""),
                    ("cmd", "Shell command", ""),
                    ("cwd", "Working dir (optional)", ""),
                ],
                validate=validate,
            ),
            done,
        )

    def action_edit_command(self) -> None:
        if self.focus_panel != "commands":
            return
        group = self.current_group()
        if not group or not group.commands or self.command_idx >= len(group.commands):
            return
        cmd = group.commands[self.command_idx]

        def validate(result: dict) -> Optional[str]:
            if not result.get("cmd"):
                return "shell command is required"
            return self._validate_command_key(result.get("key", ""), group, editing=cmd)

        def done(result: Optional[dict]) -> None:
            if not result:
                return
            cmd.key = result["key"]
            cmd.label = result.get("label") or result["cmd"]
            cmd.cmd = result["cmd"]
            cmd.cwd = result.get("cwd") or None
            save_config(self.config_path, self.groups)
            self.refresh_commands()

        self.app.push_screen(
            FormModal(
                "Edit command",
                [
                    ("key", "Key", cmd.key),
                    ("label", "Label", cmd.label),
                    ("cmd", "Shell command", cmd.cmd),
                    ("cwd", "Working dir (optional)", cmd.cwd or ""),
                ],
                validate=validate,
            ),
            done,
        )

    def action_delete_item(self) -> None:
        if self.focus_panel == "groups":
            group = self.current_group()
            if not group:
                return
            msg = f"Delete group '{group.name}' and all its commands?"

            def done(ok: bool) -> None:
                if ok:
                    self.groups.remove(group)
                    save_config(self.config_path, self.groups)
                    self.group_idx = max(0, self.group_idx - 1)
                    self.refresh_groups()

            self.app.push_screen(ConfirmModal(msg), done)
        else:
            group = self.current_group()
            if not group or not group.commands or self.command_idx >= len(group.commands):
                return
            cmd = group.commands[self.command_idx]
            msg = f"Delete command '{cmd.label}'?"

            def done(ok: bool) -> None:
                if ok:
                    group.commands.remove(cmd)
                    save_config(self.config_path, self.groups)
                    self.refresh_commands()

            self.app.push_screen(ConfirmModal(msg), done)

    def action_quit(self) -> None:
        self.app.exit()


# ------------------------------------------------------------------------ app

class CmdTuiApp(App):
    CSS = """
    Screen {
        background: transparent;
    }
    #sidebar {
        width: 28;
        border: round $primary;
        padding: 0 1;
        background: transparent;
    }
    #main-right {
        border: round $primary;
        padding: 0 1;
        background: transparent;
    }
    #sidebar-title, #commands-title {
        text-style: bold;
        color: $accent;
        padding: 0 1;
    }
    #group-list {
        height: 1fr;
        background: transparent;
    }
    #command-list {
        height: 30%;
        background: transparent;
    }
    #output {
        height: 1fr;
        border-top: solid $primary;
        background: transparent;
        padding: 0 1;
    }
    #welcome-msg, #error-msg {
        margin: 2 4;
    }
    """

    def __init__(self, config_arg: Optional[str]):
        super().__init__(ansi_color=True)
        self.config_arg = config_arg

    def on_mount(self) -> None:
        path = Path(self.config_arg) if self.config_arg else find_config(Path.cwd())
        if path is None:
            self.push_screen(WelcomeScreen(Path.cwd() / CONFIG_NAME))
            return
        if not path.exists():
            self.push_screen(WelcomeScreen(path))
            return
        try:
            groups = load_config(path)
        except Exception as exc:  # noqa: BLE001
            self.push_screen(ConfigErrorScreen(path, str(exc)))
            return
        self.push_screen(MainScreen(path, groups))


def main() -> None:
    import sys
    arg = sys.argv[1] if len(sys.argv) > 1 else None
    CmdTuiApp(arg).run()


if __name__ == "__main__":
    main()
