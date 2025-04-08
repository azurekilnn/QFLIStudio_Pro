local MyEditor=luajava.bindClass("com.luastudio.azure.MyEditor")
local operation_editor=MyEditor()
local EditorUtil={}

function EditorUtil.checkEncryptFile(path)
  local content=io.open(path):read("*a")
  operation_editor.setText(content)
  local editor_text=operation_editor.getText().toString()
  return (content==editor_text)
end

return EditorUtil