local M = {}

-- generate the run command based on the language provided
local function get_command(language)
    if language == "python" then
        command = "!python3 "
    elseif language == "go" then
        command = "!go run "
    elseif language == "javascript" then
        command = "!node "
    elseif language == "bash" then
        command = "!bash "
    elseif language == "lua" then
        command = "!lua " 
    else 
        command = "echo 'Language not supported'"
    end
    return command
end

local function write_temp_file(file_name, code)
  local filehandle = assert(io.open(file_name, "w"))
  for _, line in ipairs(code) do
    filehandle:write(line .. "\n")
  end
  filehandle:close()
end
-- run the temp file to execute the code
local function run_tmp_file(command, file_name)
  run_command = command .. file_name
  --vim.api.nvim_command(run_command)
  vim.cmd(run_command)
end

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


function MarkRunner()
  local lines = get_selected_text()
  lang = string.sub(lines[1], 4)
  local lang_extension = {python="py",go="go", cpp="cpp", javascript="js", lua="lua", bash="sh", c="c",}
  local code = {unpack(lines, 2)}
  local file_name = os.tmpname()
  local command = get_command(lang)
  if lang_extension[lang] then
    local file_name = file_name .. "." .. lang_extension[lang]
      write_temp_file(file_name, code)
      run_tmp_file(command, file_name)
      os.remove(file_name)
  else
      vim.cmd(command)
  end

end
MarkRunner()
--[[
```golang
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
