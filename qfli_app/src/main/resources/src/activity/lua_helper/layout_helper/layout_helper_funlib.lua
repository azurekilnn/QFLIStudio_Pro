require "system_no_theme"
import "console"
import "com.androlua.support.*"
import "loadlayout3"

activity.setTitle(gets("xml_translator_title"))
copy_board=activity.getSystemService(Context.CLIPBOARD_SERVICE)

function xml2table(xml)
  local xml,s=xml:gsub("</%w+>","}")
  if s==0 then
    return xml
  end
  xml=xml:gsub("<%?[^<>]+%?>","")
  xml=xml:gsub("xmlns:android=%b\"\"","")
  xml=xml:gsub("%w+:","")
  xml=xml:gsub("\"([^\"]+)\"",function(s)return (string.format("\"%s\"",s:match("([^/]+)$")))end)
  xml=xml:gsub("[\t ]+","")
  xml=xml:gsub("\n+","\n")
  xml=xml:gsub("^\n",""):gsub("\n$","")
  xml=xml:gsub("<","{"):gsub("/>","}"):gsub(">",""):gsub("\n",",\n")
  return (xml)
end

--dlg=Dialog(activity,mainTheme)
--dlg.setTitle("布局表预览")
function show(s)
  SkipPage("show_layout",{s})
  --dlg.setContentView(loadlayout3(loadstring("return "..s)(),{}))
  --dlg.show()
end

function click()
  local str=editor.getText().toString()
  if str:find("xmlns:android") then
    transformed_str=xml2table(str)
    transformed_str=console.format(transformed_str)
    editor.setText(str.."\n\n\n"..transformed_str)
   else
    system_print(gets("xml2table_error"))
  end
end

function click2()
  local str=editor.getText().toString()
  if not str=="" then
    show(str)
   else
    system_print(gets("preview_error"))
  end
end

function click3(s)
  local cd = ClipData.newPlainText("label", editor.getText().toString())
  copy_board.setPrimaryClip(cd)
  system_print(gets("copy_tip"))
end

function click4()
  local str=editor.getText().toString()
  layout.main=loadstring("return "..str)()
  activity.setContentView(loadlayout2(layout.main,{}))
  dlg2.hide()
end

--loadlayout(t)
--dlg2=Dialog(activity,mainTheme)
--dlg2.setTitle("编辑代码")
--dlg2.getWindow().setSoftInputMode(0x10)
--dlg2.setContentView(l)

function edit_layout(txt)
  SkipPage("layout_editor",{txt})
  --editor.Text=txt
  --editor.format()
  --dlg2.show()
end

function onResume2()
  local cd=copy_board.getPrimaryClip();
  local msg=cd.getItemAt(0).getText()--.toString();
  editor.setText(msg)
end