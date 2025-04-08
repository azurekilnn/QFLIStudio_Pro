set_style()
import {
    "editor.editor_operations_bar",
    "editor.editor_operations_funlib",
}
file_path=...
current_editor_name="SoraEditor"
setCommonView("layout","dex_viewer","back_mode")
current_editor_lib=editor_opeartions[current_editor_name]
editor_background.addView(loadlayout(custom_editor("editor",current_editor_name,nil)))
current_editor=editor
editor.getTextActionWindow().setEnabled(true)
--使弹出的输入法影响布局
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
system_ripple({fundo_button,finsert_code_button,fast_button_close,fformat_button,fpaste_button,fredo_button,fcode_operation_button},"square_black_theme")

function main_paste_text(text)
  current_editor_lib["insert_text"](current_editor,text)
end

current_editor_lib["register_selection_change_event"](editor)
if support_languages then
 else
  support_languages=current_editor_lib["get_support_languages"]()
end
function load_other_editor_components()
  import "layout.layout_editor.editor_assembly"
  local bottom_bar=editor_assembly["bottom_bar_layout"]
  bottom_root_layout.addView(loadlayout(bottom_bar))
end
function check_language(support_languages,file_name)
  for index,language in ipairs(support_languages) do
    if file_name:find("%"..language.."$") then
      return true,language
    end
  end
end
load_other_editor_components()
load_symbols_bar()
load_fast_operations_bar()

if (file_path and File(file_path).exists()) then
file_object=File(file_path)
local file_name=file_object["name"]
setWindowTitle(file_name)
local check_language_status,file_language=check_language(support_languages,file_name)
local file_language=((check_language_status and file_language) or "lua")
local scope_name=((file_language and support_languages[file_language]) or "source.lua")
current_editor_lib["set_attributes"](editor,scope_name)
import "EditorUtil"
if EditorUtil.checkEncryptFile(file_path) then
local content=io.open(file_path):read("*a")
editor.setText(content)
end
end
