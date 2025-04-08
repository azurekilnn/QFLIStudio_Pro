--检查工程完整性
function check_project_info(path)
  if (path and File(path).exists()) then

    local project_information={}
    local build_information_file=path.."/build.lsinfo"
    local init_information_file=path.."/app/src/main/assets/init.lua"
    local main_file=File(path.."/app/src/main/assets/main.lua")
    local status_1=pcall(loadfile(build_information_file))
    if main_file and status_1 and build_info then
      return true
     else
      return false
    end
    --清空 build_info
    if build_info then
      build_info=nil
    end
   else
    return false
  end
end

--跳转到编辑器
function skip_editor(proj_path)
  if check_project_info(proj_path) then
    if get_editor_setting("independent_editor") then
      activity.newLSActivityX("editor_activity",{proj_path},true)
      table.insert(editor_windows,proj_path)
      editor_windows[proj_path]=true
     else
      activity.newLSActivity("editor_activity",{proj_path})
    end
  end
end
--跳转到编辑器
function only_skip_editor(proj_path,ie_status)
  if ie_status then
      activity.newLSActivity("editor_activity",{proj_path},ie_status)
  else
    activity.newLSActivity("editor_activity",{proj_path})
  end
end

--读取上次打开的工程并进入编辑器
function read_and_into_editor()
  local opened_project_file_path = activity.getLuaDir() .. "/memory_file/opened_project.table"--工程信息，历史打开文件，历史打开文件夹
  pcall(dofile,opened_project_file_path)
  if opened_project_info then
    local his_proj_path=opened_project_info["history_project_path"] or nil
    local auto_open=opened_project_info["auto_open"]
    if ((his_proj_path and File(his_proj_path).exists()) and (auto_open and auto_open==true)) then
      load_status=true
      if check_project_info(his_proj_path) then
        if get_editor_setting("independent_editor") then
          thread(only_skip_editor,his_proj_path,true)
          table.insert(editor_windows,his_proj_path)
          editor_windows[proj_path]=true
         else
          thread(only_skip_editor,his_proj_path)
        end
      end
      --main_handler_run(skip_editor(his_proj_path))
    end
  end
end