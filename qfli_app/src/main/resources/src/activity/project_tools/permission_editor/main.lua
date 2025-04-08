set_style()
require "permission"
activity.setTitle(gets("project_permission_editor"))

value=...
proj_path=value
--file_type,file_path=...
--file_type,file_path="init_xml","/storage/emulated/0/AppProjects/MyApp3/app/src/main/AndroidManifest.xml"

activity.setContentView(loadlayout("layout.layout_permission_editor"))
main_title_id.setText(gets("project_permission_editor"))
menu_button.setVisibility(8)
--more_img.setImageBitmap(loadbitmap(load_icon_path("check")))
setImage(more_img,load_icon_path("check"))
system_ripple({more_button},"圆主题")

if file_type=="init_lua" then
  init_content={}
  pcall(function()loadfile(file_path,"bt",init_content)()end)
  appname=init_content.appname or "LuaStudio+"
  appver=init_content.appver or "1.0"
  appcode=init_content.appcode or "1"
  appsdk=init_content.appsdk or "15"
  path_pattern=init_content.path_pattern or ""
  packagename=init_content.packagename or "com.luastudio.demo"
  developer=init_content.developer or ""
  description=init_content.description or ""
  debug_mode=init_content.debugmode==nil or init_content.debugmode
  app_key=init_content.app_key or ""
  app_channel=init_content.app_channel or ""
end

local template=[[
appname="%s"
appver="%s"
appcode="%s"
appsdk="%s"
path_pattern="%s"
packagename="%s"
theme="%s"
app_key="%s"
app_channel="%s"
developer="%s"
description="%s"
debugmode=%s
user_permission={
  %s
}
]]


permission_showtext={}
permission_table={}

for k,v in pairs(permission_info) do
  table.insert(permission_table,k)
end
table.sort(permission_table)
for k,v in ipairs(permission_table) do
  table.insert(permission_showtext,permission_info[v])
end
adp=ArrayListAdapter(activity,android.R.layout.simple_list_item_multiple_choice,String(permission_showtext))
permission_list.ChoiceMode=ListView.CHOICE_MODE_MULTIPLE;
permission_list.setAdapter(adp)

--读取列表
if file_type=="init_lua" then
  pcs={}
  for k,v in ipairs(init_content.user_permission or {}) do
    pcs[v]=true
  end
  for k,v in ipairs(permission_table) do
    if pcs[v] then
      permission_list.setItemChecked(k-1,true)
    end
  end
 elseif file_type=="init_xml" then
  pss2={}
  pa=0
  past=0
  point=0
  for c in io.lines(file_path) do
    table.insert(pss2,c)
    pa=pa+1
    if c:find(">") then
      if past>=2 then
       else
        past=past+1
        point=pa
      end
    end
  end
  IQES=0
  for k,v in ipairs(pss2) do
    if pss2[k]:find("uses%-permission") then
      IQES=k
      vvv=pss2[k]:match('<uses%-permission android:name="android.permission.(.-)"')
      if vvv==nil then
       else
        for kk,vv in ipairs(permission_table) do
          if vv==vvv then
            permission_list.setItemChecked(kk-1,true)
          end
        end
      end
    end
    --[[ if pcs[v] then
      permission_list.setItemChecked(k-1,true)
    end]]
  end
end

--[[pcs={}
for k,v in ipairs(app.user_permission or {}) do
  pcs[v]=true
end
for k,v in ipairs(ps) do
  if pcs[v] then
    permission_list.setItemChecked(k-1,true)
  end
end]]

local function dump(t)
  for k,v in ipairs(t) do
    t[k]=string.format("%q",v)
  end
  return table.concat(t,",\n ")
end

more_button.onClick=function()
  local cs=permission_list.getCheckedItemPositions()
  local rs={}
  for n=1,#permission_table do
    if cs.get(n-1) then
      table.insert(rs,permission_table[n])
    end
  end
  if file_type=="init_lua" then

    changed_content=string.format(template,appname,appver,appcode,appsdk,path_pattern,packagename,thm,app_key,app_channel,developer,description,debugmode,dump(rs))

   elseif file_type=="init_xml" then
    for k,v in ipairs(pss2) do
      if k>point and IQES+1>k then
        table.remove(pss2,point+1)
      end
    end

    for k,v in ipairs(rs) do
      table.insert(pss2,point+1,'	<uses-permission android:name="android.permission.'..v..'"/>')
    end

    for k,v in ipairs(pss2) do
      if v=="" then
        table.remove(pss2,v)
      end
    end

    changed_content=""

    for k,v in ipairs(pss2) do
      if changed_content=="" then
        changed_content=v
       else
        changed_content=changed_content.."\n"..v
      end
    end
  end
  io.open(file_path,"w"):write(changed_content):close()
  system_print(gets("save_succeed"))
  activity.result({"information_changed"})
end