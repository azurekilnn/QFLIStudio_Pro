set_style()
import "system_incident"
load_common_components()
--2022-02-04
classes=require("android_libs")
activity_title=gets("import_analysis")
activity.setContentView(loadlayout("layout.layout_import_analysis"))
main_title_id.setText(activity_title)
activity.setTitle(activity_title)

more_button.setVisibility(8)
--返回按钮
menu_img.setVisibility(8)
back_button.setVisibility(0)
--按钮波纹效果
system_ripple({back_button,more_button},"circular_theme")

more_button.onClick=function()
  popup_show(more_lay)
end

item_click=function(p,v,i,s)
  popup_dimiss()
  local item_text=v.Tag.popadp_text.Text
  if item_text==gets("reverse_selection") then
    for n=0,#rs-1 do
      list.setItemChecked(n,not list.isItemChecked(n))
    end
   elseif item_text==gets("copy") then
    local buf={}
    local cs=list.getCheckedItemPositions()
    local buf={}
    for n=0,#rs-1 do
      if cs.get(n) then
        table.insert(buf,string.format("import \"%s\"",rs[n]))
      end
    end
    local str=table.concat(buf,"\n")
    local cd = ClipData.newPlainText("label", str)
    copy_text(str)
    system_print(gets("copy_tip"))
  end
end

load_system_popup(item_click)
add_popup_item(gets("reverse_selection"))
add_popup_item(gets("copy"))

function fiximport(path)
  import "com.myopicmobile.textwarrior.common.*"
  classes=require "android_libs"
  local searchpath=path:gsub("[^/]+%.lua","?.lua;")..path:gsub("[^/]+%.lua","?.aly;")
  local cache={}
  function checkclass(path,ret)
    if cache[path] then
      return
    end
    cache[path]=true
    local f=io.open(path)
    --print(path)
    local str=f:read("a")
    f:close()
    if not str then
      return
    end
    for s,e,t in str:gfind("(import \"[%w%.]+%*\")") do
      --local p=package.searchpath(t,searchpath)
      --print(t,p)
    end
    for s,e,t in str:gfind("import \"([%w%.]+)\"") do
      local p=package.searchpath(t,searchpath)
      if p then
        p5=io.open(p):read("*a")
        if string.byte(p5,1)==0x1b then
          system_print(gets("cannot_open_compiled_file_tip").."\t"..path)
         else
          checkclass(p,ret)
        end
      end
    end
    local lex=LuaLexer(str)
    local buf={}
    local last=nil
    while true do
      local t=lex.advance()
      if not t then
        break
      end
      if last~=LuaTokenTypes.DOT and t==LuaTokenTypes.NAME then
        local text=lex.yytext()
        buf[text]=true
      end
      last=t
    end
    table.sort(buf)
    for k,v in pairs(buf) do
      k="[%.$]"..k.."$"
      for a,b in ipairs(classes) do
        if string.find(b,k) then
          if cache[b]==nil then
            table.insert(ret,b)
            cache[b]=true
          end
        end
      end
    end
  end
  local ret={}
  checkclass(path,ret)
  return String(ret)
end

lua_dir,lua_path=...

print(lua_path)
list=ListView(activity)
list.ChoiceMode=ListView.CHOICE_MODE_MULTIPLE;
if lua_path then
  task(fiximport,lua_path,function(v)
    rs=v
    adp=ArrayListAdapter(activity,android.R.layout.simple_list_item_multiple_choice,v)
    list.setAdapter(adp)
    background_2.addView(list)
    background_1.setVisibility(0)
    background_3.setVisibility(8)
    more_button.setVisibility(0)
  end)
end