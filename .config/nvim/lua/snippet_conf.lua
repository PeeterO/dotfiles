function Split(s, delimiter)
    return (s..delimiter):gmatch("(.-)"..delimiter)

end

function args_split(args)
	local t=""
	for arg in string.gmatch(args, '([^,]+)') do
		--arg_iter = Split(arg, ' ')
		arg_iter = arg:gmatch("[%a%d_-]+")
		arg_type = arg_iter()
		arg_name = arg_iter()
		if arg_type ~= nil and arg_name ~= nil then
			t = t .. arg_name .. " (" .. arg_type .. ")  -  TODO" .. string.char(10) .. "* "
		end
	end
	return t
end

function create_list_of_strings(input)
  local str = ''
  local function wrap_quotes(x) return "'" .. x .. "'" end
  for item, _ in input:gmatch('([%s%w%.%_]+),') do
    local str_end = (' '):rep(vim.bo.shiftwidth) .. wrap_quotes(item)
    if str == '' then
      str = str .. str_end
    else
      str = str .. ',\n' .. str_end
    end
  end
  return str

end


local snippets = require'snippets'
local U = require'snippets.utils'
snippets.snippets = {
  _global = {
		-- If you aren't inside of a comment, make the line a comment.
		copyright = U.force_comment [[Copyright (C) Peeter Org ${=os.date("%Y")}]];

		MIT = [[
/*
 * Copyright (c) ${=os.date("%Y")} Peeter Org 
 * 
 * Permission is hereby granted, free of charge, 
 * to any person obtaining a copy of this software and 
 * associated documentation files (the "Software"), to 
 * deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, 
 * merge, publish, distribute, sublicense, and/or sell 
 * copies of the Software, and to permit persons to whom 
 * the Software is furnished to do so, 
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice 
 * shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
]];

	date = [[${=os.date("%d.%m.%Y")}]];

	slist = [[
	local $1 = {
	${2|create_list_of_strings(S.v)}
}
]];

guard = [[ 
#ifndef ${2|string.upper(S.v)}_H_
#define ${2|string.upper(S.v)}_H_

$0

#endif
]]

};

c = {

main = [[#include <stdio.h>



int main(void)
{
	printf("Hello World!");
	
	return 0;
}
]];

		["for"] = U.match_indentation [[for( int ${1:i} = 0; $1 < $2; $1++ )
{
	$0
}]];

func = [[

/*
* $2
*
* Author: Peeter Org; Created: ${=os.date("%d.%m.%Y")}
*
* Description:
* TODO
*
* Param:
* ${3|args_split(S.v)}
* Return:
* $1 - TODO
*/


$1 $2($3)
{
	$0
}

]]

  };

h = {


}

}
