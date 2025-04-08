set_style()
require "permission"
import "system_incident"
load_all_paths()
load_common_components()

import "com.michael.NoScrollListView"

setCommonView("layout.layout_main","project_info","back_with_more_mode")

system_ripple({back_button,more_button},"circular_theme")

import "com.luastudio.azure.AzureLibrary"
studio_ext_dir = AzureLibrary.studioExtDir

--Glide.with(activity).load(load_icon_path("check")).into(more_img)
setImage(more_img,load_icon_path("check"))

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
app_type_table = {
  gets("lua_common_project"),
  gets("luajava_mix_project")
}


newapp_type_table = {
  [gets("lua_common_project")] = "common_lua",
  [gets("luajava_mix_project")] = "lua_java"
}

project_type = {
  common_lua = gets("lua_common_project"),
  lua_java = gets("luajava_mix_project")
}
more_button.onClick=function()
  local function dump2(t)
    for k,v in ipairs(t) do
      t[k]=string.format("%q",v)
    end
    return table.concat(t,",\n ")
  end

  local cs=permission_list.getCheckedItemPositions()
  local rs={}
  for n=1,#permission_table do
    if cs.get(n-1) then
      table.insert(rs,permission_table[n])
    end
  end
  local permissionrs={}
  for n=1,#permission_table do
    if cs.get(n-1) then
      table.insert(permissionrs,permission_table[n])
    end
  end
  local buildsdk=sdk_keydata[sdk_data[sdk_list.getSelectedItemPosition()+1]]
  build_info["appsdk"]=buildsdk

  local build_content_template='build_info=%s\nuser_permission={\n\t%s\n}'
  local init_content_template='appname="%s"\ndebugmode=%s'

  local build_save_content=string.format(build_content_template,dump(build_info),dump2(rs))
  local init_save_content=string.format(init_content_template,build_info["appname"],debugmode_switch.isChecked())

  local build_information_file=mproject_path.."/build.lsinfo"
  local init_information_file=mproject_path.."/app/src/main/assets/init.lua"

  io.open(build_information_file,"w"):write(build_save_content):close()
  io.open(init_information_file,"w"):write(init_save_content):close()

  if build_info["template"]=="lua_java" then
    for k,v in ipairs(androidmanifest_table) do
      if k>point and lastpermission_point+1>k then
        table.remove(androidmanifest_table,point+1)
      end
    end

    for k,v in ipairs(permissionrs) do
      table.insert(androidmanifest_table,point+1,'	<uses-permission android:name="android.permission.'..v..'"/>')
    end

    for k,v in ipairs(androidmanifest_table) do
      if v=="" then
        table.remove(androidmanifest_table,k)
      end
    end
    if packageName_point~=0 then
      if androidmanifest_table[packageName_point]:find(">") then
        androidmanifest_table[packageName_point]='	package="'..build_info["packagename"]..'">'
       else
        androidmanifest_table[packageName_point]='	package="'..build_info["packagename"]..'"'
      end
    end

    if versionCode_point~=0 then
      if androidmanifest_table[versionCode_point]:find(">") then
        androidmanifest_table[versionCode_point]='	android:versionCode="'..build_info["appcode"]..'">'
       else
        androidmanifest_table[versionCode_point]='	android:versionCode="'..build_info["appcode"]..'"'
      end
    end

    if versionName_point~=0 then
      if androidmanifest_table[versionName_point]:find(">") then
        androidmanifest_table[versionName_point]='	android:versionName="'..build_info["appver"]..'">'
       else
        androidmanifest_table[versionName_point]='	android:versionName="'..build_info["appver"]..'"'
      end
    end
    --[[elseif androidmanifest_table[k]:find("package=") then
    packageName_point=k
  elseif androidmanifest_table[k]:find("android:versionName") then
    versionName_point=k
  elseif androidmanifest_table[k]:find("android:versionCode") then
    versionCode_point=k
]]

    changed_content=""

    for k,v in ipairs(androidmanifest_table) do
      if changed_content=="" then
        changed_content=v
       else
        changed_content=changed_content.."\n"..v
      end
    end

    local androidmanifest_file=mproject_path.."/src/AndroidManifest.xml"

    io.open(androidmanifest_file,"w"):write(changed_content):close()

  end

  system_print(gets("save_succeed"))
  activity.result({"project_info_changed"})
end

app_icon.onClick=function()
  local intent= Intent(Intent.ACTION_PICK)
  intent.setType("image/*")
  this.startActivityForResult(intent, 1)
  --回调
  function onActivityResult(requestCode,resultCode,intent)
    if intent then
      local cursor =this.getContentResolver ().query(intent.getData(), nil, nil, nil, nil)
      cursor.moveToFirst()
      import "android.provider.MediaStore"
      local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
      fileSrc = cursor.getString(idx)
      bit=nil
      --fileSrc回调路径路径
      import "android.graphics.BitmapFactory"
      bit =BitmapFactory.decodeFile(fileSrc)
      --iv.setImageBitmap(bit)
      LuaUtil.copyDir(fileSrc,mproject_path.."/app/src/main/assets/icon.png")
      if File(mproject_path.."/app/src/main/assets/icon.png").exists()==true then
        app_icon.setImageBitmap(loadbitmap(mproject_path.."/app/src/main/assets/icon.png"))
      end

    end
  end--nirenr
end

sdk_key={
  ["30"]="30 (Android 11.0)",
  ["29"]="29 (Android 10.0)",
  ["28"]="28 (Android 9.0)",
  ["27"]="27 (Android 8.1)",
  ["26"]="26 (Android 8.0)",
  ["25"]="25 (Android 7.1)",
  ["24"]="24 (Android 7.0)",
  ["23"]="23 (Android 6.0)",
  ["22"]="22 (Android 5.1)",
  ["21"]="21 (Android 5.0)",
  ["19"]="19 (Android 4.4)",
  ["18"]="18 (Android 4.3)",
  ["17"]="17 (Android 4.2)",
  ["16"]="16 (Android 4.1)",
  ["15"]="15 (Android 4.0.3)",
}

sdk_keydata={
  ["30 (Android 11.0)"]="30",
  ["29 (Android 10.0)"]="29",
  ["28 (Android 9.0)"]="28",
  ["27 (Android 8.1)"]="27",
  ["26 (Android 8.0)"]="26",
  ["25 (Android 7.1)"]="25",
  ["24 (Android 7.0)"]="24",
  ["23 (Android 6.0)"]="23",
  ["22 (Android 5.1)"]="22",
  ["21 (Android 5.0)"]="21",
  ["19 (Android 4.4)"]="19",
  ["18 (Android 4.3)"]="18",
  ["17 (Android 4.2)"]="17",
  ["16 (Android 4.1)"]="16",
  ["15 (Android 4.0.3)"]="15"
}

sdk_data={
  "30 (Android 11.0)",
  "29 (Android 10.0)",
  "28 (Android 9.0)",
  "27 (Android 8.1)",
  "26 (Android 8.0)",
  "25 (Android 7.1)",
  "24 (Android 7.0)",
  "23 (Android 6.0)",
  "22 (Android 5.1)",
  "21 (Android 5.0)",
  "19 (Android 4.4)",
  "18 (Android 4.3)",
  "17 (Android 4.2)",
  "16 (Android 4.1)",
  "15 (Android 4.0.3)",
}

--返回按钮
menu_img.setVisibility(8)
back_button.setVisibility(0)
main_title_id.setText(gets("project_info"))

view_radius(appname_edittext,dp2px(4),pc(gray_color))
view_radius(appver_edittext,dp2px(4),pc(gray_color))
view_radius(packagename_edittext,dp2px(4),pc(gray_color))
view_radius(appcode_edittext,dp2px(4),pc(gray_color))
view_radius(template_edittext,dp2px(4),pc(gray_color))
view_radius(developer_edittext,dp2px(4),pc(gray_color))
view_radius(sdk_list,dp2px(4),pc(gray_color))
view_radius(debugmode_switch,dp2px(4),pc(gray_color))

--edittext监听
appname_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
    build_info["appname"]=s
  end
}
appver_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
    build_info["appver"]=s
  end
}
packagename_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
    build_info["packagename"]=s
  end
}
appcode_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
    build_info["appcode"]=s
  end
}
--[[template_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
    build_info["appcode"]=s
  end
}
developer_edittext.addTextChangedListener{
  onTextChanged=function(c)
    local s=tostring(c)
  end
}]]

function read_info(mproject_path)
  import "system.system_funlibs"
  if Glide then
    Glide.with(activity).load(load_project_icon(mproject_path)).into(app_icon)
   else
    app_icon.setImageBitmap(loadbitmap(load_project_icon(mproject_path)))
  end
  local project_information={}
  local build_information_file=mproject_path.."/build.lsinfo"
  local init_information_file=mproject_path.."/app/src/main/assets/init.lua"
  local androidmanifest_file=mproject_path.."/src/AndroidManifest.xml"

  local backupbuild_file_path=data_storage.."/updated_file/"..mproject_path:match(studio_ext_dir.."/(.+)").."/"..tostring(os.time()).."/build.lsinfo"
  local backupinit_file_path=data_storage.."/updated_file/"..mproject_path:match(studio_ext_dir.."/(.+)").."/"..tostring(os.time()).."/app/src/main/assets/init.lua"
  local backupandroidmanifest_file_path=data_storage.."/updated_file/"..mproject_path:match(studio_ext_dir.."/(.+)").."/"..tostring(os.time()).."/src/AndroidManifest.xml"
  LuaUtil.copyDir(build_information_file,backupbuild_file_path)
  LuaUtil.copyDir(init_information_file,backupinit_file_path)
  LuaUtil.copyDir(androidmanifest_file,backupandroidmanifest_file_path)

  local status_1=pcall(loadfile(build_information_file))
  local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  if status_1 and status_2 then
    if build_info and user_permission then
      project_information=build_info
      pcall(loadfile(init_information_file,"bt",project_information))

      napp_name=project_information["appname"] or "Hello World_"..os.time()
      napp_ver=project_information["appver"] or "1.0"
      napp_code=project_information["appcode"] or "1"
      napp_packagename=project_information["packagename"] or "com.luastudio.helloworld"
      napp_template=project_type[project_information["template"]] or gets("lua_common_project")
      napp_sdk=project_information["appsdk"] or "15"
      napp_permission=user_permission
      ndebugmode=project_information["debugmode"]==nil or project_information["debugmode"]

      debugmode_switch.setChecked(ndebugmode)

      for k,v in ipairs(theme_data) do
        if v==project_information["theme"] then
          theme_list.setSelection(k-1)
        end
      end
      for k,v in ipairs(sdk_data) do
        if v==sdk_key[napp_sdk] then
          sdk_list.setSelection(k-1)
        end
      end


      if project_information["template"]=="lua_java" then
        napp_permission={}

        local androidmanifest_file=mproject_path.."/src/AndroidManifest.xml"
        androidmanifest_content=(io.open(androidmanifest_file):read("*a"))

        local manifest_content=androidmanifest_content:match("<manifest(.-)>")
        local packageName=manifest_content:match('package="(.-)"')
        local versionName=manifest_content:match('android:versionName="(.-)"')
        local versionCode=manifest_content:match('android:versionCode="(.-)"')

        appname=androidmanifest_content:match('android:label="(.-)"')
        if appname:find("@") then
          local variable_name=appname:match("@string/(.+)")
          local stringxml=(mproject_path.."/app/src/main/res/values/strings.xml")
          local stringxml_content=io.open(stringxml):read("*a")
          appname=stringxml_content:match('<string name="'..variable_name..'">(.-)</string>')
        end
        napp_name=appname
        appname=nil

        napp_packagename=packageName
        packageName=nil

        androidmanifest_table={}
        pa=0
        past=0
        point=0
        for c in io.lines(androidmanifest_file) do
          table.insert(androidmanifest_table,c)
          pa=pa+1
          if c:find(">") then
            if past>=2 then
             else
              past=past+1
              point=pa
            end
          end
        end

        local packageName=manifest_content:match('package="(.-)"')
        local versionName=manifest_content:match('android:versionName="(.-)"')
        local versionCode=manifest_content:match('android:versionCode="(.-)"')

        packageName_point=0
        versionName_point=0
        versionCode_point=0
        lastpermission_point=0
        for k,v in ipairs(androidmanifest_table) do
          if androidmanifest_table[k]:find("uses%-permission") then
            lastpermission_point=k
            vvv=androidmanifest_table[k]:match('<uses%-permission android:name="android.permission.(.-)"')
            if vvv==nil then
             else
              for kk,vv in ipairs(permission_table) do
                if vv==vvv then
                  permission_list.setItemChecked(kk-1,true)
                end
              end
            end
           elseif androidmanifest_table[k]:find("package=") then
            packageName_point=k
           elseif androidmanifest_table[k]:find("android:versionName") then
            versionName_point=k
           elseif androidmanifest_table[k]:find("android:versionCode") then
            versionCode_point=k
          end
          --[[ if pcs[v] then
      permission_list.setItemChecked(k-1,true)
    end]]
        end
       else
        pcs={}
        for k,v in ipairs(napp_permission or {}) do
          pcs[v]=true
        end
        for k,v in ipairs(permission_table) do
          if pcs[v] then
            permission_list.setItemChecked(k-1,true)
          end
        end
      end

      appname_edittext.setText(napp_name)
      appver_edittext.setText(napp_ver)
      appcode_edittext.setText(napp_code)
      packagename_edittext.setText(napp_packagename)
      template_edittext.setText(napp_template)
    end
  end
end

local fs=luajava.astable(android.R.style.getFields())
theme_data={"Theme"}
for k,v in ipairs(fs) do
  local nm=v.Name
  if nm:find("^Theme_") then
    table.insert(theme_data,nm)
  end
end

local themelist_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(theme_data))
theme_list.setAdapter(themelist_adp)

local sdklist_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(sdk_data))
sdk_list.setAdapter(sdklist_adp)

permission_showtext={}
permission_table={}

for k,v in pairs(permission_info) do
  table.insert(permission_table,k)
end
table.sort(permission_table)
for k,v in ipairs(permission_table) do
  table.insert(permission_showtext,permission_info[v])
end
permission_adp=ArrayListAdapter(activity,android.R.layout.simple_list_item_multiple_choice,String(permission_showtext))
permission_list.ChoiceMode=ListView.CHOICE_MODE_MULTIPLE;
permission_list.setAdapter(permission_adp)
value=...

mproject_path=value
if mproject_path then
  read_info(mproject_path)
end