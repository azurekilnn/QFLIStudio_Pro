function repair_ver3_project(proj_path)
  local file_dir=File(proj_path)
  local file_dir_name=file_dir["name"]
  local cache_dir=activity.getLuaExtDir("cache/fix_projects/"..tostring(os.time()).."/"..file_dir_name)
  local new_project_dir=activity.getLuaExtDir().."/projects".."/"..file_dir_name
  local new_project_dir=((File(new_project_dir).exists() and new_project_dir.."_"..tostring(os.time())) or new_project_dir)
  local copy_status=LuaUtil.copyDir(proj_path,cache_dir)
  if copy_status then
    local cache_src=cache_dir.."/src"
    local cache_src_assets=cache_dir.."/src/assets"
    local cache_hist_file=cache_dir.."/history.conf"
    local cache_src_manifest=cache_dir.."/src/AndroidManifest.xml"
    local cache_src_java=cache_dir.."/src/java"
    local cache_src_res=cache_dir.."/src/res"
    local cache_new_src=cache_dir.."/app/src/main"
    --local copy_status_2=LuaUtil.copyDir(cache_src,cache_new_src)
    local copy_status_2=LuaUtil.copyDir(cache_src,cache_new_src)
    if copy_status then
      LuaUtil.rmDir(File(cache_src_assets))
      LuaUtil.rmDir(File(cache_src_res))
      LuaUtil.rmDir(File(cache_src_java))
      LuaUtil.rmDir(File(cache_src_manifest))
      LuaUtil.rmDir(File(cache_hist_file))
      local copy_status_3=LuaUtil.copyDir(cache_dir,new_project_dir)
      if copy_status_3 then
        if File(new_project_dir.."/src").exists() then
          LuaUtil.rmDir(File(new_project_dir.."/src"))
        end
        system_print(gets("repair_complete_tips"))
        return true
      else
        system_print(gets("runtime_error"))
        return false
      end
    else
      system_print(gets("runtime_error"))
      return false
    end
  else
    system_print(gets("runtime_error"))
    return false
  end
end

function batch_repair()
  local function repair_update(path)

    if global_loading_dlg then
      global_loading_dlg.setMessage(tostring(path))
    end
    if batch_repair_pg_card_tv then
      batch_repair_pg_card.setVisibility(View.VISIBLE)
      batch_repair_pg_card_tv.setText(tostring(path))
    end
  end
  local function repair_callback(s)
    if global_loading_dlg then
      global_loading_dlg.dismiss()
    end
    if batch_repair_button then
      batch_repair_button.setEnabled(true)
    end
    if home_progressbar then
      home_progressbar.setVisibility(View.GONE)
    end
    if batch_repair_pg_card then
      batch_repair_pg_card.setVisibility(View.GONE)
    end
    pcall(reload_project_list)
    if s then
      system_print(gets("repair_complete_tips"))
    else
      system_print(gets("runtime_error"))
    end
  end


  function batch_repair_method()
    require "import"
    require "system.public_system"

   local function repair_project(proj_path)
      local file_dir=File(proj_path)
      local file_dir_name=file_dir["name"]
      local cache_dir=activity.getLuaExtDir("cache/fix_projects/"..tostring(os.time()).."/"..file_dir_name)
      local new_project_dir=activity.getLuaExtDir().."/projects".."/"..file_dir_name
      local new_project_dir=((File(new_project_dir).exists() and new_project_dir.."_"..tostring(os.time())) or new_project_dir)
      local copy_status=LuaUtil.copyDir(proj_path,cache_dir)
      if copy_status then
        local cache_src=cache_dir.."/src"
        local cache_src_assets=cache_dir.."/src/assets"
        local cache_hist_file=cache_dir.."/history.conf"
        local cache_src_manifest=cache_dir.."/src/AndroidManifest.xml"
        local cache_src_java=cache_dir.."/src/java"
        local cache_src_res=cache_dir.."/src/res"
        local cache_new_src=cache_dir.."/app/src/main"
        --local copy_status_2=LuaUtil.copyDir(cache_src,cache_new_src)
        local copy_status_2=LuaUtil.copyDir(cache_src,cache_new_src)
        if copy_status then
          LuaUtil.rmDir(File(cache_src_assets))
          LuaUtil.rmDir(File(cache_src_res))
          LuaUtil.rmDir(File(cache_src_java))
          LuaUtil.rmDir(File(cache_src_manifest))
          LuaUtil.rmDir(File(cache_hist_file))
          local copy_status_3=LuaUtil.copyDir(cache_dir,new_project_dir)
          if copy_status_3 then
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    end
local project_storage=activity.getLuaExtDir("project")
    local proj_list=File(project_storage).listFiles()
    if proj_list then
      local proj_list=luajava.astable(proj_list)
      this.update({true,project_storage})
      for index,content in ipairs(proj_list) do
          local proj_path=content["path"]
          this.update(proj_path)
          repair_project(proj_path)
        end
        return true
      else
        return false
      end
  end
  --global_loading_dlg.show()
  activity.newTask(batch_repair_method,repair_update,repair_callback).execute({})
end


function format_lua_files(path,progress_dlg,callback)
  local MyEditor=luajava.bindClass("com.luastudio.azure.MyEditor")
  local format_lua_file_editor=MyEditor()
  local format_backup_dir=activity.getExternalFilesDir("format_backup")
  local format_lua_file_backup_file_dir=tostring(format_backup_dir).."/"..tostring(os.time())

  local function flf_update(path)
    if progress_dlg then
      progress_dlg.setMessage(File(path)["name"])
    end

    local function check_encrypt_file(path)
      local content=io.open(path):read("*a")
      format_lua_file_editor.setText(content)
      local editor_text=format_lua_file_editor.getText().toString()
      return (content==editor_text)
    end

    local function format_lua_file(path)
      local content=io.open(path):read("*a")
      --format_lua_file_editor.setText(content)
      --format_lua_file_editor.format()

      if file_backup_3(File(path),format_lua_file_backup_file_dir,content) then
        local new_content=AzureUtil.formatLuaContent(content).toString()
        io.open(path,"w"):write(new_content):close()
      end
    end
    if check_encrypt_file(path) then
      format_lua_file(path)
    end
  end
  local function flf_callback(s)
    if progress_dlg then
      progress_dlg.dismiss()
    end
    if s then
      system_print(gets("format_successfully_tip"))
      callback(s)
     else
      system_print(gets("format_unsuccessfully_tip"))
    end
  end

  local function format_lua_files_method(path)
    require "import"
    import "java.io.*"

    --判断文件类型
    local function check_is_lua_file(name)
      if name:find("%.lu?a$") or name:find("%.al?y$") then
        return true
      end
    end

    function format_dir(path)
      local file_list=luajava.astable(File(path).listFiles())
      for index,file in ipairs(file_list) do
        if file.isDirectory() then
          format_dir(file["path"])
         else
          if check_is_lua_file(file["name"]) then
            this.update(file["path"])
          end
        end
      end
    end
    format_dir(path)
    return true
  end
  activity.newTask(format_lua_files_method, flf_update, flf_callback).execute({path})
end

--local path="/storage/emulated/0/LuaStudio_Pro/test"
--format_lua_files(path)

function get_home_file_list_total_method(tv_id,path)
  local function gfs_update(content)
    tv_id.setText(tostring(content))
  end
  local function gfs_callback(s)
    if s then
      tv_id.setText(tostring(s))
    end
  end
  function get_filelist_totalsize(dir)
    require "import"
    import "java.io.*"
    import "android.text.format.Formatter"
    local total_length=0
    function get_filelist_length(path)
      local file_list=luajava.astable(File(path).listFiles() or ArrayList())
      for index,file in ipairs(file_list) do
        if file.isDirectory() then
          get_filelist_length(file["path"])
         else
          local length=file.length()
          total_length=total_length+length
          local update_text=(tostring(Formatter.formatFileSize(activity,total_length))..("\t("..total_length..")"))
          this.update(update_text)
        end
      end
    end
    get_filelist_length(tostring(dir))
    local update_text=(tostring(Formatter.formatFileSize(activity,total_length))..("("..total_length..")"))
    return update_text
  end
  activity.newTask(get_filelist_totalsize, gfs_update, gfs_callback).execute({path})
end



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

function create_newproject(appname,packagename,callback)
  import "system.system_template"
  local napp_type_key=app_type_table[app_type_list.getSelectedItemPosition()+1]
  local napp_type=newapp_type_table[napp_type_key]
  local napp_name=appname
  local napp_packagename=packagename
  local napp_dir=project_path.."/"..napp_name
  local napp_assets_dir=napp_dir.."/app/src/main/assets"
  local build_content=string.format(templates["build_lsinfo_template"],napp_name,napp_type,napp_packagename)
  --local init_content=string.format(init_lua_template,napp_name,napp_packagename)
  local init_content=string.format(templates["init_lua_template"],napp_name)
  
  local strings_content=string.format(templates["strings_template"],napp_name)
  local main_content=string.format(templates["main_content"],setlayout_code)
  local mainjava_content=string.format(templates["mainjava_template"],napp_packagename)
  local manifest_content=template_manager.getAndroidManifestTemplate(napp_packagename)
  if File(napp_dir).isDirectory() then
    system_print(gets("create_project_error"))
   else
    File(napp_dir).mkdirs()
    WriteFile(napp_dir.."/build.lsinfo",build_content)
    WriteFile(napp_assets_dir.."/init.lua",init_content)
    WriteFile(napp_assets_dir.."/main.lua",main_content)
    WriteFile(napp_assets_dir.."/layout.aly",aly_content)
    if napp_type=="common_lua" then
     elseif napp_type=="lua_java" then
      LuaUtil.unZip(activity.getLuaDir().."/Template_LuaJavaMix.zip",napp_dir)
  local mainjava_subpath=napp_packagename:gsub("%.","/")
  WriteFile(napp_dir.."/app/src/main/java/"..mainjava_subpath.."/MainActivity.java",mainjava_content)
  WriteFile(napp_dir.."/app/src/main/res/values/strings.xml",strings_content)
  WriteFile(napp_dir.."/app/src/main/AndroidManifest.xml",manifest_content)
    end

    create_project_dialog.dismiss()
    --load_project_list()
    add_project_item(projects_info_table,napp_dir)--(adapter,path,name)
    local new_project_info={}
    new_project_info["project_icon"]=load_project_icon(napp_dir)
    new_project_info["project_name"]=napp_name
    new_project_info["project_packagename"]=napp_packagename
    new_project_info["project_type"]=napp_type
    new_project_info["project_path"]=napp_dir
    system_print(gets("create_project_succeed"))
    callback(true,new_project_info)
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
        content.itemParent.backgroundColor=pc(background_color)
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
  local opened_project_file_path = activity.getLuaDir() .. "/memory_file/opened_project.table"--工程信息，历史打开文件，历史打开文件夹
  pcall(dofile,opened_project_file_path)
  if opened_project_info then
    local his_opend_dir_path=opened_project_info["history_project_opened_dir_path"] or nil
    local his_opend_file_path=opened_project_info["history_project_opened_file_path"] or nil
    local his_proj_path=opened_project_info["history_project_path"] or nil
    local auto_open=opened_project_info["auto_open"]
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
        uploading_proj_dialog2.dismiss()
       else
        system_print(gets("backup_failed_tips"))
        uploading_proj_dialog2.dismiss()
      end
    end)
   else
    system_print(gets("not_logged_in_tips"))
    uploading_proj_dialog2.dismiss()
  end
end

--WebDav 下载并导入文件
function wdplodownload(name,path,import)
  progress_dlg = ProgressDialog(this)
  progress_dlg.setMessage(gets("downloading_tips"))
  progress_dlg2=progress_dlg.show()
  local background_color=pc(background_color)
  progress_dlg2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(background_color))

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
function load_webdav_projects_list(clear,func)
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

function load_webdav_projects(func,reload)
  if project_webdav and reload then
    project_webdav.list('luastudio/',function(code,webdav_data)
      if code==200 then
        cloud_projects_table={}
        for v in pairs(webdav_data) do
          if webdav_data[v] and webdav_data[v]["isDir"]==false then
            table.insert(cloud_projects_table,webdav_data[v])
            local item_data=webdav_data[v]
            local item_type=item_data["isDir"]
            if item_type==false and webdav_projects_data then
              local cproject_name=item_data["name"]
              local cproject_path=item_data["path"]
              local modify_time=item_data["modifyTime"]
              local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
              local file_length=item_data["length"]
              local file_size=(Formatter.formatFileSize(activity,file_length))
              table.insert(webdav_projects_data,{project_icon=load_project_icon("path"),project_name=cproject_name,project_packagename=modify_time.."\t\t"..file_size,project_type="app_type",project_path=cproject_path})
            end

          end
        end
        pcall(func,true,cloud_projects_table)
        io.open(webdav_memory_filepath,"w"):write("cloud_projects_table="..dump(cloud_projects_table)):close()
       else

        if func then
          pcall(func,false)
        end
      end
    end)

   else
    if cloud_projects_table then
      if #cloud_projects_table==0 then
        if func then
          pcall(func,false)
        end
       else
        for v in pairs(cloud_projects_table) do
          local item_data=cloud_projects_table[v]
          local item_type=item_data["isDir"]
          if item_type==false and webdav_projects_data then
            local cproject_name=item_data["name"]
            local cproject_path=item_data["path"]
            local modify_time=item_data["modifyTime"]
            local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
            local file_length=item_data["length"]
            import "android.text.format.Formatter"
            local file_size=(Formatter.formatFileSize(activity,file_length))
            table.insert(webdav_projects_data,{project_icon=load_project_icon("path"),project_name=cproject_name,project_packagename=modify_time.."\t\t"..file_size,project_type="app_type",project_path=cproject_path})
          end

          if func then
            pcall(func,true,cloud_projects_table)
          end
        end
      end
     else
      if func then
        pcall(func,false)
      end
    end
  end
end


function Request_DataDir()
  if sdk_version > 29 and sdk_version < 33 then
    --请求/Android/data访问权限
    import "DataLibrary"
    if not DataLibrary.isGrant() then --该方法判断是否获取访问data权限
      local authorization_dlg=AlertDialog.Builder(this)
      authorization_dlg.setTitle(gets("tip_text"))
      authorization_dlg.setMessage(gets("authorization_datafolder_tips"))
      authorization_dlg.setPositiveButton(gets("go_to_authorization_button"),{onClick=function(v)
          DataLibrary.requestPermission()
        end})
      authorization_dlg.setNegativeButton(gets("cancel_button"),nil)
      authorization_dlg.show()
    end
  end
end

function setSwipeRefreshLayout(id,refresh_click)
  id.setColorSchemeColors({basic_color_num});
  id.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=refresh_click})
end

function load_activities(activities_dir,tables)
  local activities_ls=File(activities_dir).listFiles()
  if activities_ls~=nil then
    local activities_ls=luajava.astable(activities_ls) --全局文件列表变量
    table.sort(activities_ls,function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
    end)
    if tables then
      for index,content in ipairs(activities_ls) do
        local tool_info_file_path=content["path"].."/init.lua"
        if File(content["path"]).isDirectory() and File(tool_info_file_path).exists() then
          local tool_info={}
          pcall(loadfile(tool_info_file_path,"bt",tool_info))
          tool_info["tool_dir"]=content["path"]
          tool_info["tool_info_file_path"]=tool_info_file_path
          local tool_name_key=tool_info["tool_name_key"]
          if tool_info["tool_home_activity"] then
            tool_info["tool_home_path"]=tostring(content["path"]).."/"..tool_info["tool_home_activity"]
          end
          if tool_name_key then
            if tool_info["tool_status"] and tool_info["tool_status"]==true then
              table.insert(tables,tool_name_key)
              tables[tool_name_key]=tool_info
             else
              tool_info["tool_status"]=false
              table.insert(tables,tool_key)
              tables[tool_name_key]=tool_info
            end
          end
          load_activities(content["path"],tables)
         else
          load_activities(content["path"],tables)
        end
      end
      return tables
    end
  end
end

function write_local_table(path,name,content)
  if content then
    local content=name.."="..dump(content)
    WriteFile(path,content)
  end
end

function read_local_table(path)
  pcall(dofile,path)
end

function load_apks_config()

end

function load_webdav_projects_config()
  pcall(dofile,webdav_memory_filepath)
end

function load_activities_config(reload)
  local activities_memory_filepath=activity.getLuaDir().."/memory_file/table_all_activities_info.conf"
  activities_dir=activity.getLuaDir().."/activities"
  all_activities_info={}
  if reload then
    all_activities_info=(load_activities(activities_dir,all_activities_info))
    write_local_table(activities_memory_filepath,"all_activities_info",all_activities_info)
   else
    if File(activities_memory_filepath).exists() then
      read_local_table(activities_memory_filepath)
     else
      all_activities_info=(load_activities(activities_dir,all_activities_info))
      write_local_table(activities_memory_filepath,"all_activities_info",all_activities_info)
    end
  end
end

function load_plugins_config(reload)
  local plugins_memory_filepath=activity.getLuaDir().."/memory_file/table_plugins_info.conf"
  plugins_dir=activity.getLuaExtDir().."/plugin"
  plugins_info={}
  if reload then
    plugins_info=(load_activities(plugins_dir,plugins_info))
    if plugins_info then
      write_local_table(plugins_memory_filepath,"plugins_info",plugins_info)
    end
   else
    if File(plugins_memory_filepath).exists() then
      if pcall(dofile,plugins_memory_filepath) then
      end
     else
      plugins_info=(load_activities(plugins_dir,plugins_info))
      if plugins_info then
        write_local_table(plugins_memory_filepath,"plugins_info",plugins_info)
      end
    end
  end
end

function load_activities_list()
  if all_activities_info then
    for i=1,#all_activities_info do
      table.insert(activities_data,i,all_activities_info[i])
    end
    if #all_activities_info==0 then
      empty_tips_4.setVisibility(0)
      activities_recyclerview_background.setVisibility(8)
      progress_bar_4_background.setVisibility(8)
     else
      empty_tips_4.setVisibility(8)
      activities_recyclerview_background.setVisibility(0)
      activities_rv_adapter.notifyDataSetChanged()
      progress_bar_4_background.setVisibility(8)
    end
    pull_4.setRefreshing(false);
  end
end

function load_plugins_list()
  if plugins_info then
    for i=1,#plugins_info do
      table.insert(plugins_data,i,plugins_info[i])
    end
    if #plugins_info==0 then
      empty_tips_5.setVisibility(0)
      plugins_recyclerview_background.setVisibility(8)
      progress_bar_5_background.setVisibility(8)
     else
      empty_tips_5.setVisibility(8)
      plugins_recyclerview_background.setVisibility(0)
      plugins_rv_adapter.notifyDataSetChanged()
      progress_bar_5_background.setVisibility(8)
    end

    pull_5.setRefreshing(false);
  end
end

function reload_plugins(func)
  load_plugins_config(true)
  if plugins_info then
    if plugins_data then
      table.clear(plugins_data)
    end
    for i=1,#plugins_info do
      table.insert(plugins_data,i,plugins_info[i])
    end
  end
  plugins_rv_adapter.notifyDataSetChanged()
  if func then
    pcall(func)
  end
end

function reload_activities(func)
  load_activities_config(true)
  if all_activities_info then
    if activities_data then
      table.clear(activities_data)
    end
    for i=1,#all_activities_info do
      table.insert(activities_data,i,all_activities_info[i])
    end
  end
  activities_rv_adapter.notifyDataSetChanged()
  if func then
    pcall(func)
  end
end

function load_activities_config(reload)
  local activities_memory_filepath=activity.getLuaDir().."/memory_file/table_all_activities_info.conf"
  activities_dir=activity.getLuaDir().."/activity"
  all_activities_info={}
  if reload then
    all_activities_info=(load_activities(activities_dir,all_activities_info))
    write_local_table(activities_memory_filepath,"all_activities_info",all_activities_info)
   else
    if File(activities_memory_filepath).exists() then
      read_local_table(activities_memory_filepath)
     else
      all_activities_info=(load_activities(activities_dir,all_activities_info))
      write_local_table(activities_memory_filepath,"all_activities_info",all_activities_info)
    end
  end
end
load_activities_config()


function load_bottom_sheet_incident(bottom_sheet_dialog,func)
  local material_r=luajava.bindClass("com.google.android.material.R")
  local view=bottom_sheet_dialog.getWindow().findViewById(material_r.id.design_bottom_sheet)
  local bottomSheetBehavior = BottomSheetBehavior.from(view);

  local hide_incident=(func or function() end)
  bottomSheetBehavior.setBottomSheetCallback(BottomSheetBehavior.BottomSheetCallback{
    onStateChanged=function(bottomSheet,newState)
      if (newState == BottomSheetBehavior.STATE_HIDDEN) then
        pcall(hide_incident)
        bottom_sheet_dialog.dismiss()
      end
    end,
    onSlide=function(bottomSheet,slideOffset)
      --print(slideOffset)

    end});
end


function create_plugin_dlg(plugin_title,content_view,name,dialog_type,reload)
  import "system.system_dialogs"
  if content_view then
    local plugin_dlg,views_data=create_basic_dlg({title=plugin_title,view=content_view,type=dialog_type})
    plugin_dlg.setOnDismissListener(DialogInterface.OnDismissListener{
      onDismiss=function()
        exit_dlg_mode()
      end
    })

    load_bottom_sheet_incident(plugin_dlg,function()
      exit_dlg_mode()
    end)
    --plugin_dlg.setCancelable(false)
    --setHideableBottomSheetDialog(plugin_dlg)
    if menu_back_button then
      menu_back_button.onClick=function()
        plugin_dlg.dismiss()
        if reload==false then
         else
          exit_dlg_mode()
        end
      end
    end
    basic_tool_bar_menu_button.onClick=function()
      plugin_dlg.dismiss()
      if reload==false then
       else
        exit_dlg_mode()
      end
    end

    more_img=views_data["basic_tool_bar_more_button_img"]
    more_button=views_data["basic_tool_bar_more_button"]
    more_lay=views_data["basic_tool_bar_more_lay"]
    search_button=views_data["basic_tool_bar_search_button"]
    search_bar_edit = views_data["basic_search_bar_edit"]
    search_bar_cancel_button_img = views_data["basic_search_bar_cancel_button_img"]
    search_bar_search_button = views_data["basic_search_bar_search_button"]
    search_bar_search_button_img =views_data["basic_search_bar_search_button_img"]
    if plugin_dlgs then
     else
      plugin_dlgs={}
    end

    plugin_dlgs[name]=plugin_dlg
    return plugin_dlg,views_data
  end
end

function exit_dlg_mode()
  if sub_dlg_open then
    sub_dlg_open=false

    more_img=main_views_data["basic_tool_bar_more_button_img"]
    more_button=main_views_data["basic_tool_bar_more_button"]
    more_lay=main_views_data["basic_tool_bar_more_lay"]
    search_button=main_views_data["basic_tool_bar_search_button"]
    search_bar_edit = main_views_data["basic_search_bar_edit"]

    search_bar_cancel_button_img = main_views_data["basic_search_bar_cancel_button_img"]
    search_bar_search_button = main_views_data["basic_search_bar_search_button"]
    search_bar_search_button_img =main_views_data["basic_search_bar_search_button_img"]
    earch_bar_search_button=main_views_data["basic_search_bar_search_button"]
   else
    function SkipPage(page,value,boolean)
      if boolean then
        activity.newLSActivity(page,value,boolean)
       else
        activity.newLSActivity(page,value)
      end
    end
  end
end

function start_dlg_mode(tool_dir,tool_info)
  function SkipPage(page,value)
    sub_dlg_open=true
    dlg_mode=true
    local page_file=tool_dir.."/"..page
    if File(page_file..".lua").exists() then
      pcall(dofile,page_file..".lua")
     elseif File(page_file).exists() then
      pcall(dofile,page_file)
    end
    if content_view then
      local dialog_type=(current_dialog_type or tool_info["dialog_type"] or "tool_bar_dialog")
      local plugin_dlg,sub_views_data=create_plugin_dlg(plugin_title,content_view,page,dialog_type,false)
      if load_shared_codes then
        pcall(load_shared_codes,value)
      end

      plugin_dlg.show()
    end
    --activity.newLSActivity(page,value)
  end

end

function load_plugin_dlg(name)
  if all_activities_info and all_activities_info[name] then
    if all_activities_info[name] then
      local tool_info=all_activities_info[name]
      local tool_home_path=tool_info["tool_home_path"]

      local plugin_title=gets(tool_info["tool_name_key"])
      local plugin_layout_path=tool_info["tool_home_layout"]
      local support_open_by_dialog=tool_info["support_open_by_dialog"]
      local dialog_type=current_dialog_type or tool_info["dialog_type"] or "tool_bar_dialog"
      local tool_dir=tool_info["tool_dir"]
      activity_dir=tool_dir
      local dialog_type=current_dialog_type or tool_info["dialog_type"] or "tool_bar_dialog"

      function loadLocalUrl(webview_id,url)
        webview_id.loadUrl("file://"..tool_dir.."/"..url)
      end

      start_dlg_mode(tool_dir,tool_info)

      dlg_mode=true

      if File(tool_dir.."/main.lua").exists() then
        pcall(dofile,tool_dir.."/main.lua")
      end
      if File(tool_dir.."/shared_codes.lua").exists() then
        pcall(dofile,tool_dir.."/shared_codes.lua")
      end
      plugin_dlg,dialog_data=create_plugin_dlg(plugin_title,content_view,name,dialog_type)
      main_views_data=dialog_data["dialog_views_data"]

      more_img=main_views_data["basic_tool_bar_more_button_img"]
      more_button=main_views_data["basic_tool_bar_more_button"]
      more_lay=main_views_data["basic_tool_bar_more_lay"]
      search_button=main_views_data["basic_tool_bar_search_button"]
      search_bar_edit = main_views_data["basic_search_bar_edit"]

      search_bar_cancel_button_img = main_views_data["basic_search_bar_cancel_button_img"]
      search_bar_search_button = main_views_data["basic_search_bar_search_button"]
      search_bar_search_button_img =main_views_data["basic_search_bar_search_button_img"]
      earch_bar_search_button=main_views_data["basic_search_bar_search_button"]

      if load_shared_codes then
        load_shared_codes()
        load_shared_codes=nil
      end
      return plugin_dlg
     else
      system_print(gets("cannot_operate_tips"))
    end
  end
end