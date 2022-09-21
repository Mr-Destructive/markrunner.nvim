local M = {}

-- get the selected text
-- fenced code block and type of language after the backticks
local function get_selected_text()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  table.remove(lines, #lines)
  return lines
end


function M.MarkRunner()
  local lines = get_selected_text()
  print(lines)
end

--[[
```go
package main
import "fmt"
func main(){
fmt.Print("hello")
}
```
```python
print("hello python")
for i in range(10):
    print(i + 10)
```
```lua
local s = "hello"
print(s .. " lua")
```
]]--

return M
