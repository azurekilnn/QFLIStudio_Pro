--文件读取
function file_read(path)
  if File(path).exists() then
    local content=io.open(path):read("*a")
    save_history_config()
    return true,content
   else
    return false
  end
end

--文件删除
function file_delete(file)
  if (file_backup(file)) then
    --local file_path=file["path"]
    LuaUtil.rmDir(file)
    save_history_config()
    return true
   else
    return false
  end
end



--保存已打开的文件
function save_opened_file(file_name_label)
  --local file_path=file["path"]
  --local file_name=(((type(file)=="string") and file) or file["name"])
  local file_name=file_name_label
  local file_info=open_files_info[file_name_label]
  if file_info then
    local file_object=(file_info and file_info["file_object"])
    local can_save=file_info["can_save"]
    if (file_object and (can_save~=false)) then
      local file_path=(file_object["path"])
      local editor=(file_info["editor"])
      local content=editor.getText().toString()
      local backup_file_dir=tostring(files_backup_dir).."/"..project_app_name
      --print(backup_file_dir)
      local status,old_file_content=read_file_content(file_path)
      if status then
        if old_file_content==content then
         else
          if get_editor_setting("old_file_backup") then
            local file_name=(file_name or file_object["name"])
            local file_path=tostring(file_path)
            local file_path_2=(((initialization_dir and file_name and file_path:find(initialization_dir) and file_path:find(file_name) and file_path:match(initialization_dir.."(.-)/"..file_name)) or "/") or file_path)
            local backup_file_path=backup_file_dir..file_path_2.."/backup_"..get_file_last_time(file_path).."_"..file_name
            --print(backup_file_path)
            write_file(backup_file_path,old_file_content)
            update_open_file_path(current_open_file_path,true)
          end
          write_file(file_path,content)
          update_open_file_path(current_open_file_path,true)
        end
      end
    end
   else
    system_print("读取文件信息失败，保存失败")
  end
end

--保存已打开的所有文件
function save_all_files()
  for index,file_name_label in ipairs(open_files_info) do
    save_opened_file(file_name_label)
  end
end

function check_encrypt_file(path,content)

end

function close_project()
  current_open_dir=nil
  init_project_files_list_status=false
end


function output_language(file)

end

function load_project_info_to_surface(path)
  --读取工程信息
  project_information=read_project_information(path)
  if project_information then
    project_app_name=project_information["appname"]
    if project_app_name then
      update_project_name(project_app_name)
    end
  end
end

function reload_project_info_to_surface()
  load_project_info_to_surface(initialization_dir)
end

--保存历史数据
function save_history_config()
  if proj_history_info_file_path then
    local postion_content=((sora_editor_position and "sora_editor_position="..dump(sora_editor_position)) or (lua_editor_position and "lua_editor_position="..dump(lua_editor_position)))
    local the_last_opened_file_content=((current_open_file_path and string.format('the_last_opened_file_path="%s"',current_open_file_path)) or "")
    local the_last_opened_dir_content=((current_open_dir and string.format('the_last_opened_dir_path="%s"',current_open_dir)) or "")
    local save_content=postion_content.."\n"..the_last_opened_file_content.."\n"..the_last_opened_dir_content
    write_file(proj_history_info_file_path,save_content)
  end
  if proj_path then

  end
end

function set_project(path,no_delay)
  rebuild_all_data()
  --文件列表初始化路径
  current_open_project_path=path
  initialization_dir=path
  initialization_dir_2=path.."/app/src/main/assets"
  proj_history_info_file_path=path.."/history.conf"
  --加载工程历史信息
  pcall(dofile,proj_history_info_file_path)
  if (the_last_opened_dir_path and (!the_last_opened_dir_path:find(initialization_dir) or !File(the_last_opened_dir_path).exists())) then
    the_last_opened_dir_path=nil
  end
  updateUI({progressbar_status=true})
  main_file_info={}
  --main.lua
  project_main_file_path=output_open_file_path(path,true)
  load_project_info_to_surface(path)
  local status,content=read_file(project_main_file_path)
  if status and content then
    local file=File(project_main_file_path)
    open_file_by_editor(file,current_editor_name,"main_editor")
    update_open_file_path(project_main_file_path)
  end
  if the_last_opened_file_path then
    local file=File(the_last_opened_file_path)
    open_file_by_editor(file,current_editor_name,"second_editor")
  end
  function init_project_files_list()
    current_initialization_dir=(the_last_opened_dir_path or (get_editor_setting("auto_into_secondary_directory")==true and initialization_dir_2) or initialization_dir)
    --system_print(current_initialization_dir)
    load_files_list(current_initialization_dir)
  end
  updateUI({progressbar_status=false})

  if no_delay then
    main_handler_run(init_project_files_list)
   else
    main_handler_run(init_project_files_list,2000)
  end
  save_history_project_info(true)
  --main_handler_run(load_projects_list,200)
end


function get_file_last_time(path)
  f = File(path);
  time = f.lastModified()
  return time
end

function load_surface_ripple()
  --按钮波纹效果
  system_ripple({folder_button,menu_button,layout_helper_button,play_button,more_button,undo_button},"circular_theme")
  system_ripple({cancel_button,select_all_button,cut_button,copy_button,paste_button},"circular_theme")
  system_ripple({search_bar_cancel_button,search_bar_search_button},"circular_theme")
  system_ripple({toline_bar_cancel_button,toline_bar_search_button,project_list_search},"circular_theme")
  system_ripple({dl_btm_nightmode_btn,dl_btm_about_btn,dl_btm_settings_btn,dl_btm_exit_btn,ch_more_fileoperation,ch_more_fileoperation_close,proj_list_button,ch_add_file,ch_filelist_back_button},"circular_theme")
  system_ripple({ch_item1,ch_item2,ch_item3,ch_item4,ch_item5,ch_item6},"square_adaptive")

  system_ripple({finsert_code_button,fast_button_close,fformat_button,fpaste_button,fredo_button,fcode_operation_button},"square_black_theme")
end

function filelist_clear_selection()
  local clear_position={}
  for index,content in ipairs(files_adapter_data) do
    local select_status=(content["select_status"])
    if select_status then
      table.insert(clear_position,index)
    end
  end
  for index,content in ipairs(clear_position) do
    table.remove(files_adapter_data,content)
    if index==#clear_position then
      file_list_checkbox_status=false
      files_adapter.notifyDataSetChanged()
    end
  end
  table.clear(clear_position)
end



function file_operations(tag_data,select_status)
  local file_object=tag_data["file"]
  local file_is_directory=file_object.isDirectory()
  local file_is_file=file_object.isFile()
  local tag_file_name=file_object["name"]
  local item_position=tag_data["position"]
  if project_open_file.Text==project_path then
    --[[ local project_path=filelist_data[s]["project_path"]
      project_info(project_path,{p=p,v=v,i=i,s=s},"editor")]]
   else

    local file_operations_items={}


    if select_status~=true then
      --重命名
      if file_object.isDirectory() then
        table.insert(file_operations_items,gets("batch_format"))
      end
      if file_object.isFile() then
        table.insert(file_operations_items,gets("share"))
      end
      if old_file_name=="src" or old_file_name=="assets" or tag_file_name=="main.lua" or tag_file_name=="build.lsinfo" or tag_file_name=="init.lua" then
       else
        table.insert(file_operations_items,gets("rename_text"))
        table.insert(file_operations_items,gets("delete"))
      end
      table.insert(file_operations_items,gets("batch_deletion_text"))

      if tag_file_name:find("%.al?y$") or tag_file_name:find("%.lu?a$") then
        table.insert(file_operations_items,gets("compile_lua_file"))
       else
        local dfile_path=project_open_file.text.."/"..tag_file_name
        if tag_file_name.text=="java" and dfile_path:find("app/src/main/java") and File(dfile_path).isDirectory() then
          table.insert(file_operations_items,"Java编译")

         elseif tag_file_name:find("%.ja?va$") then
          table.insert(file_operations_items,"Java编译")
         elseif tag_file_name:find("%.pn?g$") or tag_file_name:find("%.jp?g$") or tag_file_name:find("%.bm?p$") or tag_file_name:find("%.gi?f$") then
          table.insert(file_operations_items,"上传到公有云 (5TB)")
        end
      end

      function console_bulid(path)
        import "console"
        local asd,str=console.build(path)
        if asd then
          system_print("编译完成: "..asd)
          --[[load_files_list(current_open_dir)
          left_sidebar_refresh_layout.setRefreshing(false);]]
         else
          system_print("编译出错："..str)
        end
      end
      local file_operations_items_incident={
        [gets("Java编译")]=function()
          local dfile_path=project_open_file.text.."/"..tag_file_name
          if tag_file_name=="java" and File(dfile_path).isDirectory() then
            activity.newLSActivity("activities/bin_moudle/java_compiler",{initialization_path,dfile_path})
           elseif tag_file_name:find("%.ja?va$") then
            activity.newLSActivity("activities/bin_moudle/java_compiler",{initialization_path,dfile_path,"java_file"})
          end
        end,
        [gets("compile_lua_file")]=function()
          local dfile_path=project_open_file.text.."/"..tag_file_name
          console_bulid(dfile_path)
        end,
        [gets("share")]=function()
          share_file(file_object["path"])
        end,
        [gets("rename_text")]=function()
          rename_file(file_object,item_position)
        end,
        [gets("delete")]=function()
          local delete_status=file_delete(file_object)
          if delete_status then
            system_print("删除成功")
            table.remove(files_adapter_data,item_position)
            files_adapter.notifyDataSetChanged()
          end

        end,
        [gets("batch_deletion_text")]=function()
          if file_list_checkbox_status then
            file_list_checkbox_status=false
            files_adapter.notifyDataSetChanged()
           else
            file_list_checkbox_status=true
            files_adapter.notifyDataSetChanged()
          end
        end,
        [gets("batch_format")]=function()


          import "system.system_dialogs"
          if formatting_dlg then
           else
            formatting_dlg,formatting_dlg_2=create_progress_dlg(gets("formatting_tips"),gets("formatting_tips"))
          end
          formatting_dlg.show()
          import "system.system_funlibs"
          format_lua_files(file_object["path"],formatting_dlg,function(status)
            if status then
              formatting_dlg.dismiss()
              pcall(check_current_file_changed)
            end
          end)
        end,


        ["上传到公有云 (5TB)"]=function()
          if check_login_status() then
            local file_path=file_object["path"]
            if uploading_dlg then
             else
              uploading_dlg=create_uploading_dlg()
            end
            uploading_dlg.show()

            local cloud_url="https://www.lqsxm666.top/cloud/?/images/"
            upload_file(cloud_url,file_path,function(code,content,url)
              uploading_dlg.dismiss()
              if code==302 then
                local url=url_filter(tostring(url))
                if file_upload_dlg then
                 else
                  file_upload_dlg=create_upload_dlg()
                end
                file_upload_dlg.show()
                file_upload_dlg_edittext.setText(tostring(url))
                file_upload_dlg_ok_button.onClick=function()
                  copy_text(url)
                end
               else
                system_print(gets("upload_unsuccessfully_tip"))
              end
            end)
           else
            system_print(gets("no_login_tips_text"))
          end
        end,
      }


      file_operation_dlg=AlertDialog.Builder(this)
      file_operation_dlg.setTitle(gets("file_operations_text"))
      file_operation_dlg.setItems(file_operations_items,{onClick=function(lll,dlg_item_position)
          local onclick_operation=file_operations_items[dlg_item_position+1]
          file_operations_items_incident[onclick_operation]()

        end})
      file_operation_dlg2=file_operation_dlg.show()
      set_dialog_style(file_operation_dlg2)
     else


      table.insert(file_operations_items,gets("batch_deletion_text"))
      local file_operations_items_incident={
        [gets("batch_deletion_text")]=function()
          filelist_batch_delete()
        end,
      }

      file_operation_dlg=AlertDialog.Builder(this)
      file_operation_dlg.setTitle(gets("file_operations_text"))
      file_operation_dlg.setItems(file_operations_items,{onClick=function(lll,dlg_item_position)
          local onclick_operation=file_operations_items[dlg_item_position+1]
          file_operations_items_incident[onclick_operation]()
        end})
      file_operation_dlg2=file_operation_dlg.show()
      set_dialog_style(file_operation_dlg2)
    end
  end
  return true
end

function check_data_index(data,position,file_name)
  for index,content in pairs(data) do
    if type(content)=="number" then
      if content==position then
        data[index]=nil
       elseif content>position then
        data[index]=content-1
      end
     elseif type(content)=="string" then
      if content==file_name then
        table.remove(data,index)
      end
    end
  end
end

function reload_tab_layout()
  local tab_count=editor_tab_layout.getTabCount()
  for i=0,(tab_count-1) do
    local tab=editor_tab_layout.getTabAt(i)
    tab.view.onLongClick=function()
      system_incident["file_tab_incident"](tab)
    end
  end
end

function read_file_content(path)
  local status,content=pcall(function()return io.open(path):read("*a") end)
  return status,content
end

function circle_message_handler(func,delay)
  local delay_time
  if delay then
    delay_time=delay
   else
    delay_time=0
  end
  if main_handler then
    cm_handler_runnable=Runnable{
      run=function()
        func()
        main_handler.postDelayed(cm_handler_runnable,delay_time)
      end
    }
    main_handler.post(cm_handler_runnable);
  end
end

function main_paste_text(text)
  current_editor_lib["insert_text"](current_editor,text)
end

function update_project_name(name)
  project_app_name=name
  activity.setTitle(gets("current_project")..project_app_name)
  main_title_id.setText(project_app_name)
  ch_project_path.setText(project_app_name)
end

function set_sora_editor_postions(editor,file_path)
  if editor and sora_editor_position then
    local positions=sora_editor_position[file_path]
    if positions then
      local left_line=positions["left_line"]
      local left_column=positions["left_column"]
      editor.setSelection(left_line,left_column)
    end
  end
end

function update_file_position(editor)
  local cursor=editor.cursor
  if cursor.isSelected then
    local left_line=cursor.getLeftLine()
    local left_column=cursor.getLeftColumn()
    if sora_editor_position then
      sora_editor_position[current_open_file_path]={left_line=left_line,left_column=left_column}
      save_history_config()
    end
    --print(left_line,left_column)
  end
end

function update_open_file_path(path,status)
  if status then
    local read_status,file_content=read_file_content(path)
    if read_status then
      if file_content==current_editor.text then
        opened_file.setText(path)
       else
        opened_file.setText(path.."*")
      end
     else
      opened_file.setText(path.."*")
    end
   else
    opened_file.setText(path)
  end
  current_open_file_path=path
end

function check_init_dir()
  if current_open_dir==project_path then
    return true
  end
end

function updateUI(value)
  local progressbar_status=value["progressbar_status"]
  local editor_select_status=value["editor_select_status"]
  if progressbar_status then
    main_progressbar.setVisibility(0)
   else
    main_progressbar.setVisibility(8)
  end
  if editor_select_status then
    tool_bar_id.setVisibility(8)
    if editor_search_bar_id then
      editor_search_bar_id.setVisibility(8)
    end
    if toline_bar_id then
      toline_bar_id.setVisibility(8)
    end
    if control_bar_id then
      control_bar_id.setVisibility(0)
    end
   else
    tool_bar_id.setVisibility(0)
    if editor_search_bar_id then
      editor_search_bar_id.setVisibility(8)
    end
    if toline_bar_id then
      toline_bar_id.setVisibility(8)
    end
    if control_bar_id then
      control_bar_id.setVisibility(8)
    end
  end
end

--Lua格式化
function format_lua_code(text)
  if lua_format_editor then
   else
    lua_format_editor=MyEditor(activity)
  end
  lua_format_editor.setText(text)
  lua_format_editor.format()
  local formatted_code=lua_format_editor.text
  return formatted_code
end

--判断文件类型
function check_is_lua_file(name)
  if name:find("%.lu?a$") or name:find("%.al?y$") then
    return true
  end
end

function check_is_aly_file(name)
  if name:find("%.aly$") then
    return true
  end
end

function get_code_navigation(src)
  local navigation_lines={}
  local navigation_lines_content={}
  local Content=luajava.bindClass("io.github.rosemoe.sora.text.Content")
  local content=Content(src)
  local all_lines=(content.getLineCount()-1)
  for index=0,all_lines do
    local line_content=content.getLineString(index)
    local function_sentense=line_content:match("([%w%._]* *=? *function *[%w%._]*%b())()")
    if (function_sentense) then
      table.insert(navigation_lines,index+1)
      table.insert(navigation_lines_content,function_sentense)
    end
  end
  return navigation_lines,navigation_lines_content
end

function check_file_exists(file_path)
  if file_path:find("%.lua$") then
    local file_path_2=file_path:gsub(".lua",".aly")
    return (File(file_path).exists() or File(file_path_2).exists())
   elseif file_path:find("%.aly$") then
    local file_path_2=file_path:gsub(".aly",".lua")
    return (File(file_path).exists() or File(file_path_2).exists())
   else
    return File(file_path).exists()
  end
end

function file_mkdir(file_dir)
  return File(file_dir).mkdir()
end

function add_new_file(file_type)
  if add_new_file_dlg then
   else
    add_new_file_dlg=create_add_file_dlg()
  end
  add_new_file_dlg.show()
  add_file_dlg_edittext.setKeyListener(DigitsKeyListener.getInstance("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."))
  add_file_dlg_edittext.setText("")
  add_file_dlg_edittext.addTextChangedListener{
    onTextChanged=function(s)
      if #s==0 then
        helpertext_1.setTextColor(pc(text_color))
        helpertext_1.setText(gets("type_appname_tips"))
        helpertext_1.setVisibility(0)
        create_file_dialog_ok_button.setEnabled(false)
       else
        local file_name=add_file_dlg_edittext.text
        local file_suffix=((file_type:find("*") and file_type:match("*(.+)")) or ((file_type==gets("custom_suffix")) and "") or "")
        local file_dir=current_open_dir
        local file_name=file_name..file_suffix
        local new_file_path=file_dir.."/"..file_name
        if check_file_exists(new_file_path) then
          helpertext_1.setText(gets("file_is_exists"))
          helpertext_1.setVisibility(0)
         else
          helpertext_1.setTextColor(pc(text_color))
          helpertext_1.setText("")
          helpertext_1.setVisibility(8)
          create_file_dialog_ok_button.setEnabled(true)
        end
      end
    end
  }
  create_file_dialog_ok_button.onClick=function()
    local file_name=add_file_dlg_edittext.text
    local file_suffix=((file_type:find("*") and file_type:match("*(.+)")) or ((file_type==gets("custom_suffix")) and "") or false)
    local file_dir=current_open_dir
    if file_name~="" then
      if file_suffix then
        local file_name=file_name..file_suffix
        local new_file_path=file_dir.."/"..file_name
        if check_file_exists(new_file_path) then
          helpertext_1.setText(gets("file_is_exists"))
          helpertext_1.setVisibility(0)
         else
          write_file(new_file_path,"")
          add_new_file_dlg.dismiss()
        end
       else
        local new_file_path=file_dir.."/"..file_name
        if check_file_exists(new_file_path) then
          helpertext_1.setText(gets("file_is_exists"))
          helpertext_1.setVisibility(0)
         else
          if (file_mkdir(new_file_path)) then
            add_new_file_dlg.dismiss()
           else
            helpertext_1.setText(gets("error"))
            helpertext_1.setVisibility(0)
          end
        end
      end
     else
      helpertext_1.setText(gets("file_name_empty_tips"))
      helpertext_1.setVisibility(0)
    end
  end
end

function read_system_components_config()
  load_activities_config()
end

function check_file_opened_status()
  if opened_file.Text == gets("file_not_open") then
    return false
   else
    return true
  end
end



function run_incident(incident_name,status)
  if current_open_project_path then
    local incident=system_incident[incident_name] or function() system_print(gets("cannot_operate_tips")) end
    if status then
      return incident
     else
      if incident_name=="bin_project" then
        bin_project()
      else
      pcall(incident,proj_path)
      end
    end
  end
end

function check_filelist_icon(icons,file)
  local file_is_directory=file.isDirectory()
  if file_is_directory then
    local file_icon=(file_is_directory and llfolder_img)
    return true,file_icon
   else
    for index,content in pairs(icons) do
      local file_name=file["name"]
      if file_name:find(index) then
        return true,content
      end
    end
  end
end

function output_open_file_path(path,main)
  if main then
    local open_file_path=path.."/app/src/main/assets/main.lua"
    project_main_file_path=open_file_path
    return open_file_path
   elseif proj_hist_open_file_path then
    return proj_hist_open_file_path
   else
    local open_file_path=path.."/app/src/main/assets/main.lua"
    project_main_file_path=open_file_path
    return open_file_path
  end
end

function read_project_information(path)
  local project_information={}
  build_information_file=path.."/build.lsinfo"
  --init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file))
  --local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  --if status_1 and status_2 then
  if build_info then
    project_information=build_info
    build_info=nil
    return project_information
  end
  --end
end

function update_open_file_dir(dir)
  --全局变量 current_open_dir
  current_open_dir=dir
  project_open_file.setText(current_open_dir)
  if (check_init_dir()) then
    --隐藏返回按钮
    ch_filelist_back_button.setVisibility(8)
    proj_list_button.setVisibility(0)
   else
    --显示返回按钮
    ch_filelist_back_button.setVisibility(0)
    proj_list_button.setVisibility(8)
  end
  ch_add_file.setVisibility(0)
  --隐藏文件操作功能按钮
  ch_more_fileoperation.setVisibility(8)
  ch_more_fileoperation_close.setVisibility(8)
end

function load_files_list(dir,refresh_data)
  init_project_files_list_status=true
  if filelist_tree then
   else
    filelist_tree={}
  end
  updateUI({progressbar_status=true})

  if files_adapter_data then
    table.clear(files_adapter_data)
  end
  --全局变量 current_open_dir
  --current_open_dir=path
  if dir then
    if (filelist_tree[dir]~=nil and refresh_data==false) then
      local this_list_files_data=filelist_tree[dir]
      for index,content in ipairs(this_list_files_data) do
        local file=content["file"]
        table.insert(files_adapter_data,{file=file,filelist=true})
      end
     else
      local this_list_files_data=get_list_files(dir)
      filelist_tree[dir]=this_list_files_data
      for index,content in ipairs(this_list_files_data) do
        local file=content["file"]
        table.insert(files_adapter_data,{file=file,filelist=true})
      end

    end
    files_adapter.notifyDataSetChanged()
    activity.initRecyclerViewAnim(file_rv)
    update_open_file_dir(dir)
  end
  updateUI({progressbar_status=false})
  save_history_config()
end


--工程列表
function load_projects_list(reload)
  import "system.system_config"

  if files_adapter_data then
    table.clear(files_adapter_data)
  end
  load_all_projects_info(reload)
  if (projects_info_table and #projects_info_table~=0) then
    for index,content in ipairs(projects_info_table) do
      table.insert(files_adapter_data,{info=content,projectlist=true})
    end
    files_adapter.notifyDataSetChanged()
    activity.initRecyclerViewAnim(file_rv)
  end
  update_open_file_dir(project_path)
end

--文件读取
function read_file(path)
  if File(path).exists() then
    local content=io.open(path):read("*a")
    return true,content
   else
    return false
  end
end



--返回上级目录
function back_last_dir()
  local refresh_path=tostring(File(current_open_dir).getParentFile())
  search_edit.setText("")
  if current_open_dir==project_path then
    system_incident["close_drawer_layout"]()
   else
    if refresh_path~=project_path then
      if file_list_checkbox_status then
        file_list_checkbox_status=false
        files_adapter.notifyDataSetChanged()
       else
        load_files_list(refresh_path,false)
      end
     else
      load_projects_list()
    end
  end
end

--文件列表批量删除
function filelist_batch_delete()
  local message=gets("delete_tips")
  system_dialog({title=gets("tip_text"),message=message,positive_button={button_name=gets("ok_button"),func=function()
        deleting_file_dialog2.show()
        task(500,function()
          for index,content in ipairs(files_adapter_data) do
            local select_status=(content["select_status"])
            local file=content["file"]
            local file_name=file["name"]
            --print(file_name,select_status)
            if select_status then
              local file=content["file"]
              local file_name=file["name"]
              if (file_name and file_name~="main.lua") then
                file_delete(file)
                --content["select_status"]=false
                --table.remove(files_adapter_data,index)
                deleting_file_dialog.setMessage(file_name)
              end
            end
            if index==#files_adapter_data then
              --filelist_clear_selection()
              reload_files_list()
              deleting_file_dialog2.dismiss()

              system_print("删除成功")
              file_list_checkbox_status=false
              files_adapter.notifyDataSetChanged()
            end
          end
        end)
      end},negative_button={button_name=gets("cancel_button")}})

end

--重命名文件
function rename_file(file,position)
  if file then
    local file_name=file["name"]
    local file_path=file["path"]
    local file_dir=tostring(file.getParentFile())
    if file_rename_dlg then
     else
      file_rename_dlg=create_rename_dlg()
    end
    file_rename_dlg.show()

    file_rename_dlg_edittext.requestFocus()
    file_rename_dlg_edittext.setText(file_name)

    start_position,end_position=string.find(file_name,"%.")
    --print(start_position,end_position)
    local all_text_num=#file_rename_dlg_edittext.text
    input_position=((start_position and start_position-1) or all_text_num)
    file_rename_dlg_edittext.setSelection(input_position)

    file_rename_dlg_ok_button.onClick=function()
      local new_name_file_path=file_dir.."/"..file_rename_dlg_edittext.text

      if (file_path==new_name_file_path) then
       else
        if renaming_file_dlg then
         else
          renaming_file_dlg,renaming_file_dlg2=create_progress_dlg(gets("tip_text"),gets("renaming_tips"))
        end
        renaming_file_dlg.show()
        task(200,function()
          if (file_backup(file)) then
            local new_file=File(new_name_file_path)
            file.renameTo(new_file)
            files_adapter_data[position]={file=new_file,filelist=true}
            files_adapter.notifyDataSetChanged()
            system_print(gets("rename_succeed_tips"))
            file_rename_dlg.dismiss()
           else
            system_print("重命名失败")
          end
        end)

      end
    end
  end
end



function get_list_files(dir)
  local list_files_data={}
  local list_files=File(dir).listFiles()
  if list_files~=nil then
    local list_files=luajava.astable(list_files)
    table.sort(list_files,function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and ul(a.Name)<ul(b.Name))
    end)
    for index,file_object in ipairs(list_files) do
      local file_path=file_object["path"]
      local file_is_directory=file_object.isDirectory()
      local file_is_file=file_object.isFile()
      local file_sub_title=((file_is_directory and gets("folder")) or get_file_size(file_object["path"]))
      if file_is_directory then
        table.insert(list_files_data,{file=file_object})
       else
        local file_size=(get_file_size(file_path) or nil)
        table.insert(list_files_data,{file=file_object,file_size=file_size})
      end
    end
  end
  return list_files_data
end

function create_rename_dlg()

  local layout_file_rename_dlg = import "layout.layout_dialogs.layout_file_rename_dialog"
  local file_rename_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  file_rename_dlg.setContentView(loadlayout(layout_file_rename_dlg))

  dialog_corner(layout_file_rename_dlg_background,pc(get_theme_color("background_color")),radiu)
  widget_radius(file_rename_dlg_ok_button,basic_color_num,radiu)

  helpertext_1.setVisibility(8)

  return file_rename_dlg
end

function create_upload_dlg()

  local layout_file_upload_dlg = import "layout.layout_dialogs.layout_file_upload_dialog"
  local file_upload_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  file_upload_dlg.setContentView(loadlayout(layout_file_upload_dlg))

  dialog_corner(layout_file_upload_dlg_background,pc(get_theme_color("background_color")),radiu)
  widget_radius(file_upload_dlg_ok_button,basic_color_num,radiu)

  file_upload_dlg_helpertext_1.setVisibility(8)

  return file_upload_dlg
end

function create_uploading_dlg()
  local uploading_dlg = ProgressDialog(this,R.style.AlertDialogTheme)
  uploading_dlg.setProgressStyle(ProgressDialog.STYLE_SPINNER)
  uploading_dlg.setTitle(gets("tip_text"))
  uploading_dlg.setMessage("上传中")
  uploading_dlg.setCancelable(false)
  uploading_dlg.setCanceledOnTouchOutside(false)
  local uploading_dlg_2=uploading_dlg.show().dismiss()
  set_dialog_style(uploading_dlg_2)

  return uploading_dlg
end

function create_add_file_dlg()

  local layout_add_file_dlg = import "layout.layout_dialogs.layout_add_file_dialog"
  local add_file_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  add_file_dlg.setContentView(loadlayout(layout_add_file_dlg))

  dialog_corner(layout_add_file_dlg_background,pc(get_theme_color("background_color")),radiu)
  widget_radius(add_file_dlg_ok_button,basic_color_num,radiu)

  add_file_dlg_edittext_helpertext_1.setVisibility(8)

  return add_file_dlg
end

function add_file_list_item(path,item_name,file_type)
  local file=File(path)
  if file then
    table.insert(files_adapter_data,{file=file,filelist=true})
  end
  files_adapter.notifyDataSetChanged()
end

function add_new_file_incident(type_content)
  import "system.system_template"
  if add_file_dlg then
   else
    add_file_dlg=create_add_file_dlg()
  end
  local java_file_template=[[package %s;

public class %s {

}
]]

  add_file_dlg.show()
  add_file_dlg_edittext.setKeyListener(DigitsKeyListener.getInstance("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."))
  addfile_incident={}
  addfile_incident["*.lua"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".lua"
      if File(new_file_path).exists() or File(project_open_file.text.."/"..add_file_dlg_edittext.text..".aly").exists() then
        system_print(gets("file_is_exists"))
       else
        local main_content=string.format(newmain_content,"")
        write_file(new_file_path,main_content)
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".lua",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.aly"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".aly"
      if File(project_open_file.text.."/"..add_file_dlg_edittext.text..".lua").exists() or File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,aly_content)
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".aly",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.java"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_name=add_file_dlg_edittext.text
      local new_file_path=project_open_file.text.."/"..new_file_name..".java"
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        local napp_packagename=project_open_file.text:match("java/(.+)")
        local napp_packagename=((napp_packagename and napp_packagename:gsub("/",".")) or "com.luastudio.helloworld")
        --print(napp_packagename)
        local mainjava_content=string.format(java_file_template,napp_packagename,new_file_name)
        write_file(new_file_path,mainjava_content)
        add_file_list_item(new_file_path,new_file_name..".java",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.css"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".css"
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,"")
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".css",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.html"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".html"
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,"")
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".html",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.txt"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".txt"
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,"")
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".txt",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident["*.xml"]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..".xml"
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,"")
        add_file_list_item(new_file_path,add_file_dlg_edittext.text..".xml",type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident[gets("custom_suffix")]=function()
    local add_file_dialog_button_incident=function()
      local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..""
      if File(new_file_path).exists() then
        system_print(gets("file_is_exists"))
       else
        write_file(new_file_path,"")
        add_file_list_item(new_file_path,add_file_dlg_edittext.text,type_content)
        add_file_dlg.dismiss()
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident[gets("folder")]=function()
    add_file_dialog_button_incident=function()
      if add_file_dlg_edittext.text=="src" or add_file_dlg_edittext.text=="assets" then
        system_print("error")
       else
        local new_file_path=project_open_file.text.."/"..add_file_dlg_edittext.text..""
        if File(new_file_path).isDirectory() then
          system_print(gets("file_is_exists"))
         else
          File(new_file_path).mkdir()
          add_file_list_item(new_file_path,add_file_dlg_edittext.text,type_content)
          add_file_dlg.dismiss()
        end
      end
    end
    add_file_dlg_ok_button.onClick=add_file_dialog_button_incident
  end
  addfile_incident[type_content]()
end




function reload_files_list()
  if current_open_dir==project_path then
   else
    if current_open_dir then
      load_files_list(current_open_dir)
    end
  end
end

function DebugActivity(activity_file_path)
  if debug_windows=="LuaAppCompatActivity" then
    activity.newAppCompatActivity(activity_file_path)
   elseif debug_windows=="LuaActivity" then
    activity.newActivity(activity_file_path)
   elseif debug_windows=="LuaAppActivity" then
    SkipPage(activity_file_path)
   elseif debug_windows=="LuaActivityX" then
    activity.newActivity(activity_file_path,true)
   elseif debug_windows=="LuaLSActivity" then
    SkipPage(activity_file_path)
  end
end

function skipLSActivity(name,value,use_activity)
  read_system_components_config()
  if lite_windows_mode then
    if plugin_dlgs and plugin_dlgs[name] then
      local plugin_dialog=plugin_dlgs[name]
      plugin_dialog.show()
      function SkipPage(page,value)
        local page_file=activity_dir.."/"..page
        if File(page_file..".lua").exists() then
          pcall(dofile,page_file..".lua")
         elseif File(page_file).exists() then
          pcall(dofile,page_file)
        end
        plugin_dlg=create_plugin_dlg(plugin_title,content_view,page,dialog_type,false)

        if load_shared_codes then
          pcall(load_shared_codes,value)
        end

        plugin_dlg.show()

        --activity.newLSActivity(page,value)
      end
     else
      local plugin_dialog=load_plugin_dlg(name)
      if plugin_dialog then
        plugin_dialog.show()
      end
    end
   else
    if all_activities_info and all_activities_info[name] then
      local tool_info=all_activities_info[name]
      local tool_home_path=tool_info["tool_home_path"]
      if value then
        if use_activity then
          if use_activity=="LuaAppCompatActivity" then
            activity.newAppCompatActivity(tool_home_path,value)
           else
            system_print(gets("cannot_operate_tips"))
          end
         else
          activity.newLSActivity(tool_home_path,value)
        end
       else
        if use_activity then
          if use_activity=="LuaAppCompatActivity" then
            activity.newAppCompatActivity(tool_home_path)
           else
            system_print(gets("cannot_operate_tips"))
          end
         else
          activity.newLSActivity(tool_home_path)
        end
      end
     else
      system_print(gets("cannot_operate_tips"))
    end
  end
end

function write_file(path,content)
  if (path and content) then
    File(tostring(File(tostring(path)).getParentFile())).mkdirs()
    io.open(path,"w"):write(content):close()
  end
end

function add_photoview(id,file)
  if open_files_editors[file_name] and editors_position[file_name] then
    editors_vp.setCurrentItem(editors_position[file_name])
    system_incident["close_drawer_layout"]()
   else
    local src=file["path"]
    local file_name=file["name"]
    local new_editor_view=create_photoview(id,src)
    local new_editor=new_editor_view.getChildAt(0)

    table.insert(open_files_info,file_name)
    local editor_position=#open_files_info
    local editor_position=((editor_position~=0 and (editor_position-1)) or editor_position)

    open_files_info[file_name]={file_language="images",file_name=file_name,can_save=false,file_object=file,editor=new_editor,editor_position=editor_position}
    current_editor=new_editor
    current_file_name=file_name

    editors_adp.add(new_editor_view,file_name)

    editors_vp.setCurrentItem(editor_position)



    system_incident["close_drawer_layout"]()

    reload_tab_layout()
  end
end

function update_current_file_info(info)
  if (info) then
    current_file=info["file_object"]
    current_file_name=(info["file_name"] or current_file["name"])
  end
end

function add_editor(id,editor,text,file_name,file)
  system_incident["close_drawer_layout"]()
  if open_files_info[file_name] then
    local editor_position=(open_files_info[file_name]["editor_position"]~=nil and open_files_info[file_name]["editor_position"])
    editors_vp.setCurrentItem(editor_position)
   else
    local file_path=file["path"]

    local formatted_code=format_lua_code(text)
    local new_text=((open_file_auto_format and formatted_code) or text)
    if open_file_auto_format and file then
      file_backup_2(file,file_name,text)
      write_file(file_path,new_text)
    end
    local new_editor_view=create_editor(id,editor,new_text)
    local new_editor=new_editor_view.getChildAt(0)

    current_editor_lib["register_selection_change_event"](new_editor)
    if support_languages then
     else
      support_languages=current_editor_lib["get_support_languages"]()
    end
    --print(dump(support_languages))

    function check_language(support_languages,file_name)
      for index,language in ipairs(support_languages) do
        if file_name:find("%"..language.."$") then
          return true,language
        end
      end
    end

    local check_language_status,file_language=check_language(support_languages,file_name)
    local file_language=((check_language_status and file_language) or "lua")
    local scope_name=((file_language and support_languages[file_language]) or "source.lua")
    current_editor_lib["set_attributes"](new_editor,scope_name)

    table.insert(open_files_info,file_name)
    local editor_position=#open_files_info
    local editor_position=((editor_position~=0 and (editor_position-1)) or editor_position)

    open_files_info[file_name]={file_language=file_language,can_save=true,file_object=file,editor=new_editor,editor_position=editor_position}
    --print(dump(open_files_info))
    current_editor=new_editor
    if current_editor_name=="SoraEditor" then
      pcall(set_sora_editor_postions,new_editor,file_path)
     else

    end
    local file_info={}
    file_info["editor"]=new_editor
    file_info["editor_view"]=new_editor_view
    file_info["file_name"]=file_name
    file_info["file_object"]=file
    file_info["file_language"]=file_language
    file_info["can_save"]=true
    update_current_file_info(file_info)

    editors_adp.add(new_editor_view,file_name)

    editors_vp.setCurrentItem(editor_position)

    new_editor.requestFocus()
    reload_tab_layout()

    if id=="main_editor" then
      main_file_info={}
      main_file_info["editor"]=new_editor
      main_file_info["editor_view"]=new_editor_view
      main_file_info["file_name"]=file_name
      main_file_info["file_object"]=file
      main_file_info["file_language"]=file_language
      main_file_info["can_save"]=true
    end
  end
end

function open_file_by_editor(file,editor_name,editor_id)
  local item_content=file["name"]
  local file_path=file["path"]
  local this_item_content=((file_path:match("assets/(.+)") or file_path:match("src/(.+)") or item_content))
  local other_item_content=(file_path:match(project_path.."/(.+)"))
  local item_content=((file_path:find(initialization_dir) and this_item_content) or other_item_content)
  local read_status,file_content=read_file_content(file_path)
  local file_content=((check_is_lua_file(item_content) and format_lua_code(file_content)) or file_content)
  local editor_id_num=tostring(math.random(1,os.time()))
  local new_editor_id=(editor_id or "editor_"..editor_id_num)
  if open_files_info[item_content] then
    local file_info=open_files_info[item_content]
    local editor_position=file_info["editor_position"]
    if editor_position then
      editors_vp.setCurrentItem(editor_position)
    end
   else
    if item_content:find("%.png$") or item_content:find("%.gif$") or item_content:find("%.jpg$") then
      add_photoview(new_editor_id,file)
     else
      import "EditorUtil"

      if EditorUtil.checkEncryptFile(file_path) then

        add_editor(new_editor_id,editor_name,file_content,item_content,file)
       else
        local wraning_dialog=MaterialAlertDialogBuilder(activity)
        wraning_dialog.setTitle(gets("tip_text"))
        wraning_dialog.setMessage("编译的文件不可编辑")
        wraning_dialog.setPositiveButton(gets("ok_button"),function()
        end)
        wraning_dialog_2=wraning_dialog.show()
        set_dialog_style(wraning_dialog_2)
      end
    end
  end
  --自动显示布局助手按钮
  auto_show_layout_helper(item_content)
  system_incident["close_drawer_layout"]()
end



--自动显示布局助手按钮
function auto_show_layout_helper(name)
  if (name and check_is_aly_file(name)) then
    layout_helper_button.setVisibility(View.VISIBLE)
   else
    layout_helper_button.setVisibility(View.GONE)
  end
end