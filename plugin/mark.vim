" Get the selected text
" fenced code block and type of language after the backticks
function! Get_Selected_Text()
  normal gv"xy
  let code = getreg("x")
  return code
endfunction

" Remove the first and the last line of the fenced code blocks
function! Remove_Fences(string)
  let string = substitute(a:string, '^.[a-z]*\n', '', '')
  return substitute(string, '\n```', '', '')
endfunction

" Get the language from the fenced code blocks
function! Get_Language(string)
  return substitute(a:string, '\n.*', '', '')
endfunction

" Generate the run command based on the language provided
function! Get_Command(language)
  echo (a:language)
  if a:language == "python" 
      let command = "!python3 "
  elseif a:language == "go"
      let command = "!go run "
  elseif a:language == "javascript"
      let command = "!node "
  elseif a:language == "bash"
      let command = "!bash "
  elseif a:language == "lua"
      let command = "!lua " 
  endif
  return command
endfunction

" Write code to a temporay file
function! Write_Temp_File(file_name, code)
  call writefile(split(a:code, '\n'), a:file_name)
endfunction

" run the temp file to execute the code
function! Run_Tmp_File(command, file_name)
  let run_command = a:command .. a:file_name
  execute run_command
endfunction


" Main function for 
" Extracting text from the visual selection
" Fetching the language from the fenced blocks
" Structing the Code for running
" Generating a Run command for the language
" Creating and storing text into a temp file
" Running the temp file from the generated command
function! MarkRunner()
  let lines = Get_Selected_Text()
  let language = Get_Language(lines[3:])
  let lines = lines[3:]
  let lines = Remove_Fences(lines)
  let file_name = tempname() . '.' . language
  call Write_Temp_File(file_name, lines)
  let command = Get_Command(language)
  call Run_Tmp_File(command, file_name)
endfunction
 
nnoremap <leader>md :call MarkRunner()<CR>

" 
"```go
"package main
"import "fmt"
"func main(){
"fmt.Print("hello")
"}
"```
"```python
"print("hello python")
"for i in range(10):
"    print(i + 10)
"```
"```lua
"local s = 'hello'
"print(s .. ' lua')
"```

