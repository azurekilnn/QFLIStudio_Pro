
function check_temp_app_dir(temp_dir)
  local src_paths={
    temp_dir.."/src",
    temp_dir.."/files",
    temp_dir.."/assets",
    temp_dir.."/lua_source",
  }
  local exists_dirs={}
  --检查主程序缓存文件夹
  for index,content in ipairs(src_paths) do
    if File(content).exists() then
      table.insert(exists_dirs,content)
    end
  end
  return exists_dirs
end

function clear_application(callback)
  local old_ver_dir=activity.getExternalFilesDir("files_bin")
  local backup_path=tostring(old_ver_dir)

  local local_dir=activity.getLocalDir()
  local input_1=backup_project(local_dir,backup_path)
  if input_1 then
    local local_dir_listfiles=File(local_dir).listFiles()

    if local_dir_listfiles~=nil then
      local local_dir_files=luajava.astable(local_dir_listfiles)
      for index,content in ipairs(local_dir_files) do

        LuaUtil.rmDir(content)
      end
    end
  end
  local md_dir=activity.getMdDir()
  local md_dir_listfiles=File(md_dir).listFiles()
  local input_2=backup_project(md_dir,backup_path)
  if input_2 then
    if md_dir_listfiles~=nil then
      local md_dir_files=luajava.astable(md_dir_listfiles)
      for index,content in ipairs(md_dir_files) do
        LuaUtil.rmDir(content)
      end
    end
  end
  if callback then
    callback()
  end
end

function check_temp_lua_dir(temp_dir)
  local lua_paths={
    temp_dir.."/lua",
    temp_dir.."/public_library/byo_public_library",
    temp_dir.."/public_library/custom_public_library",
    temp_dir.."/custom_public_library",
    temp_dir.."/custom_public_library",
  }
  local exists_dirs={}
  --检查主程序缓存文件夹
  for index,content in ipairs(lua_paths) do
    if File(content).exists() then
      table.insert(exists_dirs,content)
    end
  end
  return exists_dirs
end
function local_update_incident()
  choose_file(Environment.getExternalStorageDirectory().toString(),function(zip_file_path,name)

    local file_size=get_file_size(zip_file_path)
    local local_dir=activity.getLocalDir()
    local md_dir=activity.getMdDir()
    local temp_dir=tostring(activity.getLuaExtDir().."/update_dir")

    function create_progressbar_dlg(title,message,focus)
      import "system.system_dialogs"
      local progressbar_dlg = ProgressDialog(this,R.style.AlertDialogTheme)
      progressbar_dlg.setProgressStyle(ProgressDialog.STYLE_SPINNER)
      progressbar_dlg.setTitle(title or "")
      progressbar_dlg.setMessage(message or "")
      if focus then
        progressbar_dlg.setCancelable(false);
        progressbar_dlg.setCanceledOnTouchOutside(false)
      end
      local progressbar_dlg_2=progressbar_dlg.show().dismiss()
      set_dialog_style(progressbar_dlg_2)
      return progressbar_dlg,progressbar_dlg_2
    end

    function create_unzipping_dlg()
      local unzipping_dlg,unzipping_dlg_2=create_progressbar_dlg("请稍后","解压文件中……",true)
      return unzipping_dlg,unzipping_dlg_2
    end

    function create_updating_dlg()
      local updating_dlg,updating_dlg_2=create_progressbar_dlg("请稍后","正在更新……",true)
      return updating_dlg,updating_dlg_2
    end


    local function update_incident(temp_dir,local_dir,md_dir,src_paths,lua_paths)
      if updating_dlg_2 then
        updating_dlg_2.show()
       else
        updating_dlg,updating_dlg_2=create_updating_dlg()
        updating_dlg_2.show()
      end
      task(200,function()
        if ((#src_paths==0) and (#lua_paths==0)) then
          local copy_status=LuaUtil.copyDir(temp_dir,local_dir)
          if copy_status then
            updating_dlg_2.dismiss()
            system_print("更新成功")
           else
            updating_dlg_2.dismiss()
            system_print("更新失败")
          end
         else
          --更新公有库
          for index,content in ipairs(src_paths) do
            if File(content).exists() then
              local copy_status=LuaUtil.copyDir(content,local_dir)
              updating_dlg.setMessage(tostring(content))
            end
          end
          for index,content in ipairs(lua_paths) do
            if File(content).exists() then
              local copy_status=LuaUtil.copyDir(content,md_dir)
              updating_dlg.setMessage(tostring(content))
            end
          end
          updating_dlg_2.dismiss()
          system_print("更新成功")
        end
      end)
    end

    local function unzipUpdateZip(zip_path,temp_dir)
      local temp_dir_file=File(temp_dir)
      if (temp_dir_file.exists()) then
        LuaUtil.rmDir(temp_dir_file)
      end
      local unZipStatus=AzureLibrary.unZip(zip_path,temp_dir)
      if unzipping_dlg_2 then
        unzipping_dlg_2.dismiss()
      end
      return unZipStatus
    end

    if zip_file_path then
      if unzipping_dlg_2 then
       else
        unzipping_dlg,unzipping_dlg_2=create_unzipping_dlg()
      end
      unzipping_dlg_2.show()

      task(500,function()

        unzipUpdateZip(zip_file_path,temp_dir)

        if (File(temp_dir).exists()) then
          local src_paths=check_temp_app_dir(temp_dir)
          local lua_paths=check_temp_lua_dir(temp_dir)
          local src_paths_num=#src_paths
          local lua_paths_num=#lua_paths


          local update_type=((src_paths_num~=0 and lua_paths_num~=0 and "主程序/公有库更新") or (src_paths_num==0 and lua_paths_num~=0 and "公有库更新") or (src_paths_num~=0 and lua_paths_num==0 and "主程序更新") or "未知类型")
          local update_message_template="更新安装包路径：%s\n更新安装包大小：%s\n更新安装包类型：%s\n\n此操作不可逆，请谨慎操作。\n若更新后无法正常运行可前往系统设置找到LuaStudio+将其进行数据清除或卸载重新安装。"

          local update_message=string.format(update_message_template,zip_file_path,file_size,update_type)
          --普通对话框
          update_info_dialog=MaterialAlertDialogBuilder(activity,R.style.AlertDialogTheme)
          update_info_dialog.setTitle("本地更新")
          update_info_dialog.setMessage(update_message)
          update_info_dialog.setCancelable(false);
          update_info_dialog.setPositiveButton("覆盖更新",function()
            update_incident(temp_dir,local_dir,md_dir,src_paths,lua_paths)
          end)

          update_info_dialog.setNeutralButton("删除并更新",function()
            clear_application(function()
              update_incident(temp_dir,local_dir,md_dir,src_paths,lua_paths)

            end)
          end)
          update_info_dialog.setNegativeButton(gets("cancel_button"),function()
          end)
          update_info_dialog.show()


         else
          system_print("更新失败")
        end
      end)

     else
      system_print("更新失败")
    end


    --load_projects_list()
  end,"update_file")
end
local_update_incident()