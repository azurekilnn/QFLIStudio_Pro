
--changed
function get_apk_icon(apk_path)
  package_manager = activity.getPackageManager()
  info = package_manager.getPackageArchiveInfo(apk_path,PackageManager.GET_ACTIVITIES);
  if info ~= nil then
    apk_info = info.applicationInfo;
    apk_appname = tostring(package_manager.getApplicationLabel(apk_info))
    apk_packagename = apk_info.packageName; --安装包名称
    apk_version=info.versionName; --版本信息
    icon = pm.getApplicationIcon(appInfo);--图标
  end
  return icon
end

function get_apk_info(archiveFilePath)
  package_manager = activity.getPackageManager()
  info = package_manager.getPackageArchiveInfo(archiveFilePath,PackageManager.GET_ACTIVITIES);
  if info ~= nil then
    apk_info = info.applicationInfo;
    apk_appname = tostring(package_manager.getApplicationLabel(apk_info))
    apk_packagename = apk_info.packageName; --安装包名称
    apk_version=info.versionName; --版本信息
    icon = package_manager.getApplicationIcon(apk_info);--图标
    return {app_name_id={text=apk_appname},apk_path_id={text=archiveFilePath},apk_packagename_id={text=apk_packagename},apk_version_id={text=apk_version},apk_icon_id=icon}
    --print(icon)
   else
    return false
  end
end

function create_newproject(appname,packagename)
  local napp_type_key=app_type_table[app_type_list.getSelectedItemPosition()+1]
  local napp_type=newapp_type_table[napp_type_key]
  local napp_name=appname
  local napp_packagename=packagename
  local napp_dir=project_path.."/"..napp_name
  local napp_assets_dir=napp_dir.."/app/src/main/assets"
  local build_content=string.format(build_lsinfo_template,napp_name,napp_type,napp_packagename)
  --local init_content=string.format(init_lua_template,napp_name,napp_packagename)
  local init_content=string.format(init_lua_template,napp_name)
  strings_template=[[<?xml version="1.0" encoding="utf-8"?>
    <resources>
        <string name="app_name">%s</string>
    </resources>]]
  mainjava_template=[[package %s;
  import android.app.*;
  import android.os.*;
  public class MainActivity extends Activity {
      @Override
      protected void onCreate(Bundle savedInstanceState){
          super.onCreate(savedInstanceState);      
      }
  }]]
  import "system.system_template"
  local strings_content=string.format(strings_template,napp_name)
  local main_content=string.format(main_content,setlayout_code)
  local mainjava_content=string.format(mainjava_template,napp_packagename)
  local manifest_content=template_manager.getAndroidManifestTemplate(napp_packagename)
  local mainjava_subpath=napp_packagename:gsub("%.","/")
  if File(napp_dir).isDirectory() then
    system_print(gets("create_project_error"))
   else
    File(napp_assets_dir).mkdirs()

    io.open(napp_dir.."/build.lsinfo","w"):write(build_content):close()
    io.open(napp_assets_dir.."/init.lua","w"):write(init_content):close()
    io.open(napp_assets_dir.."/main.lua","w"):write(main_content):close()
    io.open(napp_assets_dir.."/layout.aly","w"):write(aly_content):close()
    if napp_type=="common_lua" then
     elseif napp_type=="lua_java" then
      LuaUtil.unZip(activity.getLuaDir().."/Template_LuaJavaMix.zip",napp_dir)
      io.open(napp_dir.."/app/src/main/res/values/strings.xml","w"):write(strings_content):close()
      io.open(napp_dir.."/src/AndroidManifest.xml","w"):write(manifest_content):close()
      File(napp_dir.."/app/src/main/java/"..mainjava_subpath).mkdirs()

      io.open(napp_dir.."/app/src/main/java/"..mainjava_subpath.."/MainActivity.java","w"):write(mainjava_content):close()
    end
    create_project_dialog.dismiss()
    --load_project_list()
    add_project_item(projects_info_table,napp_dir)--(adapter,path,name)
    local project_icon=load_project_icon(napp_dir)
    local project_name=napp_name
    local project_packagename=napp_packagename
    local project_type=napp_type
    local project_path=napp_dir
    project_list_adp.add({app_icon_id=project_icon,app_name_id={text=project_name},app_packagename_id={text=project_packagename},app_type_id=project_type,project_path=project_path})

    task(50,function()
      project_list_id.setSelection(#project_data-1)
    end)
    ripple_setting(project_data,project_list_adp)
    system_print(gets("create_project_succeed"))
    empty_tips.setVisibility(8)
    project_list_background.setVisibility(0)
    progress_background.setVisibility(8)
  end
end



function check_project_info(path)
  local project_information={}
  local build_information_file=path.."/build.lsinfo"
  local init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file))
  --project_information=build_info
  local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  local status_3=pcall(loadfile(build_information_file,"bt",project_information))

  if status_1 and status_2 and status_3 then
    --status_3 必为 true
    if build_info then
      --正常工程
      --print("正常工程")
      build_info=nil
      return true
     else
      --旧版本build.lsinfo init.lua正常
      if project_information then
        --print("旧版本build.lsinfo init.lua正常")
        return false
       else
        return false
      end
    end

   elseif status_1 and not status_2 and status_3 then
    if build_info then
      --build.lsinfo正常，init.lua缺失
      --print("build.lsinfo正常，init.lua缺失")
      build_info=nil
      return true
     else
      if project_information then
        --print("旧版本build.lsinfo init.lua缺失")
        return false
       else
        return false
      end
    end
   else
    return false
  end
end

function read_project_name(path)
  local project_information={}
  build_information_file=path.."/build.lsinfo"
  init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(init_information_file,"bt",project_information))
  local status_2=pcall(loadfile(build_information_file))
  project_information=build_info
  if status_1 and status_2 then
    return project_information["appname"]
   elseif not status_1 and status_2 then
    return project_information["appname"]
   elseif status_1 and not status_2 then
    return project_information["appname"]
  end
end

function read_project_info2(path)
  local project_information={}
  build_information_file=path.."/build.lsinfo"
  init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(init_information_file,"bt",project_information))
  local status_2=pcall(loadfile(build_information_file))
  project_information=build_info
  if status_1 and status_2 then
    return project_information
   elseif not status_1 and status_2 then
    return project_information
   elseif status_1 and not status_2 then
    return project_information
  end
end



--Adapter




local _get_apk_list = [[require "import"
  import "java.io.*"
  local path,arr=...
  local name,t
  
  function _get(path)
      local f=File(path)
      local  l=f.listFiles()
      
      for i=0,#l-1 do
          t=l[i]
          name= t.getName()
          
          if  t.isFile() and string.find(string.lower(name),"%.apk$") then
              arr.add(t)
          end
            
          if t.isDirectory() then
              _get(t.toString())
          end
            
          end            
      end 
  _get(path)]]

function get_apk_list(path)
  get_apk_list_first=true
  arr=ArrayList()
  task( _get_apk_list,path,arr,get_apk_list_finish)
end

function get_apk_list_finish()
  apk_list_adp.clear()
  for i=0,arr.size()-1 do
    str=arr.get(i).toString()
    if get_apk_info(str) then
      apk_list_adp.add(get_apk_info(str))
    end
  end
  apk_num=#apk_paths_table
  if apk_num==0 then
    empty_tips_2.setVisibility(0)
    apk_list_background.setVisibility(0)
    progress_background_2.setVisibility(8)
    task(100,function()
      pull_2.setRefreshing(false);
    end)
   else
    empty_tips_2.setVisibility(8)
    apk_list_background.setVisibility(0)
    progress_background_2.setVisibility(8)
    apk_list_id.setAdapter(apk_list_adp)

    task(100,function()
      ripple_setting(apk_paths_table,apk_list_adp,"second")
      pull_2.setRefreshing(false);
    end)
  end
end


function query_helper_roster_list()
  local function adapter_ripple(data,adapter)
    for index,content in pairs(data) do
      if content.name_id then
        if content.itemParent==nil then
          content.itemParent={}
        end
        if content.item==nil then
          content.item={}
        end
        content.name_id.textColor=pc(text_color)
        content.itemParent.backgroundColor=pc(get_theme_color("background_color"))
        content.item.background=Ripple(nil,0x22000000)
      end
    end
    adapter.notifyDataSetChanged()
  end
  help_roster_pull.setRefreshing(true);
  task(100,function()
    help_roster_adp.clear()
    bmob_key:query("donation","",function(code,j)
      if code~=-1 and code>=200 and code<400 then
        local n=#j.results
        while n>0 do
          local qq_number=j.results[n].qq
          table.insert(help_roster_data,{icon_id={src="http://q1.qlogo.cn/g?b=qq&nk="..qq_number.."&s=640"},hide_text={text=qq_number},name_id={text=j.results[n].name},sub_name_id={text=j.results[n].updatedAt}})
          n=n-1
        end
        help_roster_listview.onItemClick=function(p,v,i,s)
          url="mqqwpa://im/chat?chat_type=wpa&uin="..v.Tag.hide_text.Text
          activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
        end
        adapter_ripple(help_roster_data,help_roster_adp)
        task(1000,function()
          help_roster_pull.setRefreshing(false);
        end)
       else
        system_print(gets("get_info_error"))
        task(1000,function()
          help_roster_pull.setRefreshing(false);
        end)
      end
    end)

  end)
  if query_helper_roster_list_first then
   else
    query_helper_roster_list_first=true
  end
end

function show_loading_proj_dialog()
  loading_proj_dialog2.show()
  task(500,function()
    loading_proj_dialog2.hide()
  end)
end

function hide_loading_proj_dialog()
  loading_proj_dialog2.hide()
end

function into_editor(his_proj_path,his_opend_dir_path,his_opend_file_path)
  if get_editor_setting("independent_editor") then
    activity.newLSActivityX("editor_activity",{his_proj_path,his_opend_dir_path,his_opend_file_path},true)
    table.insert(editor_windows,his_proj_path)
    editor_windows[his_proj_path]=true
   else
    --call("show_loading_proj_dialog")
    activity.newLSActivity("editor_activity",{his_proj_path,his_opend_dir_path,his_opend_file_path})
  end
end

function read_and_into_editor()
  local opend_project_file_path = activity.getLuaDir() .. "/memory_file/opend_project.table"--工程信息，历史打开文件，历史打开文件夹
  pcall(dofile,opend_project_file_path)
  if opend_project_info then
    local his_opend_dir_path=opend_project_info["history_project_opened_dir_path"] or nil
    local his_opend_file_path=opend_project_info["history_project_opened_file_path"] or nil
    local his_proj_path=opend_project_info["history_project_path"] or nil
    local auto_open=opend_project_info["auto_open"]
    if his_proj_path then
      if File(his_proj_path).exists() then
        if auto_open then
          if auto_open==true then
            thread(into_editor,his_proj_path)--,his_opend_dir_path,his_proj_path)
          end
        end
      end
    end
  end
end

--load project icon
function load_project_icon(path)
  local icon_paths={
    path.."/app/src/main/assets/icon.png",
    activity.getCustomDir() .. "/res/icons/icon.png",
    activity.getCustomDir() .. "/res/icons/icon.lsicon",
    activity.getLuaDir() .. "/res/icons/icon.png"
  }
  function check_path(paths)
    for index,content in pairs(paths) do
      if File(content).exists() then
        return content
      end
    end
  end
  return check_path(icon_paths)
end

--遍历所有工程信息
function load_all_projects_info()
  --检测 main.lua是否存在
  local function check_main_file_exists(path)
    if File(path.."/app/src/main/assets/main.lua").exists() then
      return true
     else
      return false
    end
  end
  --读取工程信息
  local function read_project_info(path)
    local project_information={}
    local build_information_file=path.."/build.lsinfo"
    local init_information_file=path.."/app/src/main/assets/init.lua"
    local status_1=pcall(loadfile(build_information_file))
    local status_2=pcall(loadfile(init_information_file,"bt",project_information))
    local status_3=pcall(loadfile(build_information_file,"bt",project_information))

    if status_1 and status_2 and status_3 then
      --status_3 必为 true
      if build_info then
        local project_information=build_info
        build_info=nil
        return project_information
      end
    end
  end
  --添加项目
  function add_project_item(data,path)--(adapter,path,name)
    if path and check_main_file_exists(path) then
      local project_information=read_project_info(path)
      local app_name=project_information["appname"]
      local app_packagename=project_information["packagename"]
      local app_type=project_information["template"]
      table.insert(data,{project_icon=load_project_icon(path),project_name=app_name,project_packagename=app_packagename,project_type=app_type,project_path=path})
    end
  end
  --遍历所有工程
  local project_dir=File(project_path)
  if project_dir.exists() then
    local lf=project_dir.listFiles()
    local project_dir_table=luajava.astable(lf)
    local item_num=#project_dir_table
    if item_num==0 then
     else
      table.sort(project_dir_table,function(a2,b2)
        return (a2.isDirectory()~=b2.isDirectory() and a2.isDirectory()) or ((a2.isDirectory()==b2.isDirectory()) and a2.Name<b2.Name)
      end)
      for n=1,#project_dir_table do
        if project_dir_table[n].isDirectory() then
          local load_project_path=project_dir_table[n].path
          add_project_item(projects_info_table,load_project_path)
        end
      end
      io.open(activity.getLuaDir().."/memory_file/projects_info.conf","w"):write("projects_info_table="..dump(projects_info_table)):close()
    end
  end
end

--工程列表设置波纹
function ripple_setting(data,adapter,value,search_text)
  local function setting_common(content,value,search_text)
    content.app_name_id.textColor=pc(text_color)
    if search_text then
      to_be_searched_text=content.app_name_id.text
      if value~="second" then
        to_be_sub_searched_text=content.app_packagename_id.text
       else
        to_be_sub_searched_text=""
      end
      if get_setting("case_sensitive") then
       else

        to_be_searched_text=utf8.lower(to_be_searched_text)
        search_text=utf8.lower(search_text)
      end
      --print(search_text)
      if to_be_searched_text:find(search_text) or to_be_sub_searched_text:find(search_text) then
        content.itemParent.backgroundColor=pc(search_results_background_color)
       else
        content.itemParent.backgroundColor=pc(get_theme_color("background_color"))
      end
     else
      content.itemParent.backgroundColor=pc(get_theme_color("background_color"))
    end
    content.item.background=Ripple(nil,0x22000000)
    if value=="second" then
      content.apk_packagename_id.textColor=pc(get_theme_color("paratext_color"))
      content.apk_version_id.textColor=pc(get_theme_color("paratext_color"))
     else
      content.app_packagename_id.textColor=pc(get_theme_color("paratext_color"))
    end
  end
  local function search_item(content,value,search_text)
    if content.itemParent==nil then
      content.itemParent={}
    end
    if content.item==nil then
      content.item={}
    end
    setting_common(content,value,search_text)
  end

  for index,content in pairs(data) do
    if content.app_name_id then
      search_item(content,value,search_text)
    end
  end
  adapter.notifyDataSetChanged()
end


--WebDav--
--WebDav 下载文件
function download_webdav_file(name,path)
  --print(name,path)
  if project_webdav then
    --local cache_proj_file_path=webdav_save_path.."/"..name
    project_webdav.download(path,true,function(code,data)
      --print(code,data)
      if code==200 then
        local cache_proj_file_path=data
        local save_proj_file_path=luastudio_download_path.."/"..name
        LuaUtil.copyDir(cache_proj_file_path,save_proj_file_path)
        return true
       else
        return false
      end
    end)
   else
    system_print(gets("not_logged_in_tips"))
  end
end

--WebDav 输出文件路径
function wdploutput_path(name,path)
  local save_proj_file_path=tostring(luastudio_download_path).."/"..name
  return save_proj_file_path
end

--WebDav 删除文件
function wdplodelete(name,path)
  deleting_proj_dialog2.show()
  task(200,function()
    if project_webdav then
      --local cache_proj_file_path=webdav_save_path.."/"..name
      project_webdav.delete(path,function(code,data)
        --print(code,data)
        if code==200 then
          reload_webdav_list()
          system_print(gets("delete_succeed_tips"))
          deleting_proj_dialog2.hide()
          return true
         else
          return false
        end
      end)
    end
  end)
end

--WebDav 上传文件
function wdploupload(path)
  local file_File=File(path)
  local file_name=file_File.Name
  if project_webdav then
    project_webdav.upload('luastudio/'..file_name,file_File,function(code,data)
      if code==200 then
        reload_webdav_list()
        system_print(gets("backup_succeed_tips"))
        uploading_proj_dialog2.hide()
       else
        system_print(gets("backup_failed_tips"))
        uploading_proj_dialog2.hide()
      end
    end)
   else
    system_print(gets("not_logged_in_tips"))
    uploading_proj_dialog2.hide()
  end
end

--WebDav 下载并导入文件
function wdplodownload(name,path,import)
  progress_dlg = ProgressDialog(this)
  progress_dlg.setMessage(gets("downloading_tips"))
  progress_dlg2=progress_dlg.show()
  local background_color=pc(background_color)
  progress_dlg2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(get_theme_color("background_color")))

  local save_proj_file_path=luastudio_download_path.."/"..name
  if File(save_proj_file_path).exists() then
    system_print(gets("file_downloaded_tips").."\t\t"..save_proj_file_path)
    if import then
      mimport_project(save_proj_file_path)
    end
   else
    local cache_proj_file_path=tostring(webdav_save_path).."/"..name
    local save_proj_file_path=tostring(luastudio_download_path).."/"..name
    if File(cache_proj_file_path).exists() then
      LuaUtil.copyDir(cache_proj_file_path,save_proj_file_path)
      system_print(gets("download_success_tips").."\t\t"..save_proj_file_path)
      if import then
        mimport_project(save_proj_file_path)
      end
     else
      if project_webdav then
        --local cache_proj_file_path=webdav_save_path.."/"..name
        project_webdav.download(path,true,function(code,data)
          --print(code,data)
          if code==200 then
            local cache_proj_file_path=data
            local save_proj_file_path=luastudio_download_path.."/"..name
            LuaUtil.copyDir(cache_proj_file_path,save_proj_file_path)
            system_print(gets("download_success_tips").."\t\t"..save_proj_file_path)
            if import then
              mimport_project(save_proj_file_path)
            end
            return true
           else
            return false
          end
        end)
       else
        system_print(gets("not_logged_in_tips"))
      end
    end
  end
  progress_dlg2.hide()
end

--WebDav 获取数据
function read_webdav_data(clear)
  pull_3.setRefreshing(true);
  if project_webdav then
    project_webdav.list('luastudio/',function(code,webdav_data)
      cloud_projects_table=webdav_data
      io.open(webdav_memory_filepath,"w"):write("cloud_projects_table="..dump(cloud_projects_table)):close()
    end)
  end
end

--WebDav 加载列表
function load_webdav_projects_list(clear)
  if clear then
    webdav_project_list_data={}
    project_list_item=import("layout.layout_items.layout_project_list_item")
    webdav_project_list_adp=LuaAdapter(activity,webdav_project_list_data,project_list_item)
    webdav_project_list_id.setAdapter(webdav_project_list_adp)
  end

  if cloud_projects_table then
    cproj_num=#cloud_projects_table
    if cproj_num==0 then
      empty_tips_3.setVisibility(0)
      webdav_project_list_background.setVisibility(0)
      progress_background_3.setVisibility(8)
      task(100,function()
        pull_3.setRefreshing(false);
      end)
      if get_webdav_list_first then
       else
        get_webdav_list_first=true
      end
     else
      for v in pairs(cloud_projects_table) do
        local item_data=cloud_projects_table[v]
        local item_type=item_data["isDir"]
        if item_type==false then
          local cproject_name=item_data["name"]
          local cproject_path=item_data["path"]
          local modify_time=item_data["modifyTime"]
          local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
          local file_length=item_data["length"]
          import "android.text.format.Formatter"
          local file_size=(Formatter.formatFileSize(activity,file_length))
          webdav_project_list_adp.add({app_icon_id=load_project_icon("path"),app_name_id={text=cproject_name},app_packagename_id={text=modify_time.."\t\t"..file_size},app_type_id="app_type",project_path=tostring(v)})
        end
        empty_tips_3.setVisibility(8)
        webdav_project_list_background.setVisibility(0)
        progress_background_3.setVisibility(8)
        --apk_list_id.setAdapter(apk_list_adp)

        ripple_setting(webdav_project_list_data,webdav_project_list_adp)
        task(500,function()
          pull_3.setRefreshing(false);
        end)
        if get_webdav_list_first then
         else
          get_webdav_list_first=true
        end
      end
    end
  end
end

--WebDav 重载列表
function reload_webdav_list()
  pull_3.setRefreshing(true);
  if project_webdav then
    project_webdav.list('luastudio/',function(code,webdav_data)
      if code==200 then
        cloud_projects_table={}
        for v in pairs(webdav_data) do
          if webdav_data[v] and webdav_data[v]["isDir"]==false then
            table.insert(cloud_projects_table,webdav_data[v])
          end
        end
        io.open(webdav_memory_filepath,"w"):write("cloud_projects_table="..dump(cloud_projects_table)):close()
        load_webdav_projects_list(true)
       else
        empty_tips_3.setVisibility(0)
        webdav_project_list_background.setVisibility(0)
        progress_background_3.setVisibility(8)
        task(100,function()
          pull_3.setRefreshing(false);
        end)
        if get_webdav_list_first then
         else
          get_webdav_list_first=true
        end
      end
    end)
   else
    empty_tips_3.setVisibility(0)
    webdav_project_list_background.setVisibility(0)
    progress_background_3.setVisibility(8)
    task(100,function()
      pull_3.setRefreshing(false);
    end)
    if get_webdav_list_first then
     else
      get_webdav_list_first=true
    end
  end
end
--WebDav END--