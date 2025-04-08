--item incident
item_incident={
  [gets("create_project")]="create_project",
  [gets("import_project")]="import_project",
  [gets("night_mode_text")]="night_mode",
  [gets("contact_dev")]="contact_dev",
  [gets("join_qqgroup")]="join_group",
  [gets("donation_text")]="donation",
  [gets("settings")]="settings_btn"
}

--system incident
if system_incident then
 else
  system_incident={}
end
--联系开发者
system_incident.contact_dev=function(path)
  open_qq_contact_window(dev_qqnum)
end
--加入交流群
system_incident.join_group=function(path)
  join_qq_group(qqgroup_num)
end
--克隆工程
system_incident.clone_project=function(path)
  if progress_dlg then
    progress_dlg.setMessage(gets("loading_text"))
   else
    progress_dlg,progress_dlg2=create_progress_dlg()
  end
  progress_dlg2.show()
  task(500,function()
    clone_project(path,function(status,new_proj_path)
      progress_dlg2.dismiss()
      if status then
        system_print(gets("clone_succeed_tips"))
        add_project_item(projects_data,new_proj_path)
        projects_rv_adapter.notifyDataSetChanged()
       else
        system_print(gets("clone_failed_tips"))
      end
    end)
  end)
end
system_incident.donation=function()
  if donation_dialog then
   else
    create_donation_dlg()
  end
  donation_dialog.show()
end
--修复工程
system_incident.fix_project=function(path)
  pcall(system_fix_project,path)
  pcall(reload_project_list)
end
--备份工程
system_incident.save_project=function(path)
  if spo_progress_dlg then
    spo_progress_dlg.setMessage(gets("loading_text"))
   else
    spo_progress_dlg,spo_progress_dlg_2=create_progress_dlg()
  end
  spo_progress_dlg_2.show()
  task(250,function()
    save_project(path,function()
      spo_progress_dlg_2.dismiss()
    end)
  end)
end
--分享工程
system_incident.share_project=function(path)
  if progress_dlg then
    progress_dlg.setMessage(gets("loading_text"))
   else
    progress_dlg,progress_dlg2=create_progress_dlg()
  end
  progress_dlg2.show()
  task(500,function()
    share_project(path,function()
      progress_dlg2.dismiss()
    end)
  end)
end
--删除工程
system_incident.delete_project = function(project_path,info,i,opreator)
  if progress_dlg then
    progress_dlg.setMessage(gets("deleting_proj_message_tips"))
   else
    progress_dlg,progress_dlg2=create_progress_dlg()
    progress_dlg.setMessage(gets("deleting_proj_message_tips"))
  end
  progress_dlg2.show()
  task(50,function()

    delete_project(project_path,true,function(status)
      if status then
        system_print(gets("delete_succeed_tips"))
        table.remove(projects_data,i)
        projects_rv_adapter.notifyDataSetChanged()
       else
        system_print(gets("delete_failed_tips"))
      end
      progress_dlg2.dismiss()
    end)

  end)
end


--关闭工程
system_incident.close_project=function(path)
  close_project()
end


--工程属性编辑器
system_incident.project_info_editor=function(path)
  system_projectinfo_editor(path)
end
system_incident.project_info=function(path)
  if opened_proj_path then
    system_projectinfo_editor(opened_proj_path)
  end
end

--工程恢复
system_incident.project_recovery=function()
  skipLSActivity("project_recovery")
end
--控件文本复制
system_incident.view_copy=function(a)
  pcall(copy_text,a.Text)
  system_print(gets("copy_tip"))
end

--新建工程
system_incident.webdav_list = function(project_path)
  SkipPage("activities/tools/webdav_tool/webdav_activity")
end
--导入工程
system_incident.import_project= function(project_path)
  system_import_project()
end
--窗口打开
system_incident.open_newwindow = function(project_path)
  SkipPage("editor_activity",{project_path},true)
end
system_incident.bin_project = function(project_path)
  --bin_activity_setting = bin_settings["bin_activity_setting"]
  -- auto_build:进入自动执行打包程序 manual_build:进入手动执行打包程序
  if type(project_path)=="string" then
    SkipPage("activities/bin_moudle/main",{project_path})
   else
    if opened_proj_path then
      SkipPage("activities/bin_moudle/main",{opened_proj_path})
    end
  end
end

system_incident.add_file=function(view)
  items={

  }
  table.insert(items,"*.lua")
  table.insert(items,"*.aly")
  table.insert(items,"*.java")
  table.insert(items,"*.xml")
  table.insert(items,"*.html")
  table.insert(items,"*.css")
  table.insert(items,"*.txt")
  table.insert(items,gets("custom_suffix"))
  table.insert(items,gets("folder"))

  add_file_dlg=AlertDialog.Builder(this)
  add_file_dlg.setTitle(gets("add_file"))
  add_file_dlg.setItems(items,{onClick=function(l,v)
      add_new_file(items[v+1])
    end})
  add_file_dlg2=add_file_dlg.show()
  set_dialog_style(add_file_dlg2)

end
system_incident.close_drawer_layout = function()
  drawer_layout.closeDrawer(5)
  drawer_layout.closeDrawer(3)
end
--function table
system_incident.redo = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["redo"] then
    eu.redo(editor)
  end
end

system_incident.undo = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["undo"] then
    eu.undo(editor)
  end
end

system_incident.selectAll = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["selectAll"] then
    eu.selectAll(editor)
  end
end

system_incident.cut = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["cutText"] then
    eu.cutText(editor)
  end
end

system_incident.copy = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["copyText"] then
    eu.copyText(editor)
  end
end

system_incident.paste = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["pasteText"] then
    eu.pasteText(editor)
  end
end

system_incident.setSelection = function()
  editor.setSelection(ed)
end

system_incident.format = function()
  system_incident["close_drawer_layout"]()
  if eu and eu["format"] then
    eu.format(editor)
  end
end

system_incident.finish=function()
  activity.finish()
end


system_incident.code_format=function()
  system_incident.format()
end

system_incident.insert_code=function()
  system_incident["close_drawer_layout"]()
  if insert_code_dialog then
    insert_code_dialog.show()
   else
    create_insert_code_dlg()
    insert_code_dialog.show()
  end
end

system_incident.code_check=function(status)
  system_incident["close_drawer_layout"]()
  if (opened_file.Text==gets("file_not_open")) then
    system_print(gets("file_not_open"))
   elseif opened_file.Text:find("%.lua") or opened_file.Text:find("%.aly") then
    af=project_path..opened_file.text
    local src=editor.getText()
    src=src.toString()
    if af:find("%.aly$") then
      src="return "..src
    end
    local _,data=loadstring(src)
    if data then
      local _,_,line,data=data:find(".(%d+).(.+)")
      current_editor_lib["goto_line"](current_editor,tonumber(line))
      if (!status) then
        system_print(line..":"..data)
      end
      return true
     else
      if (!status) then
        system_print(gets("noerror_tips"))
      end
    end
  end
end

system_incident.import_analysis=function()
  system_incident["close_drawer_layout"]()
  if (opened_file.Text==gets("file_not_open")) then
    system_print(gets("file_not_open"))
   else
    --导入分析
    skipLSActivity("import_analysis",{opened_file.text})
  end
end

system_incident.code_navigation=function()
  system_code_navigation()
end

system_incident.search_code=function()
  system_incident["close_drawer_layout"]()
  if search_bar_id.getVisibility()==8 then
    tool_bar_id.setVisibility(8)
    search_bar_id.setVisibility(0)
    toline_bar_id.setVisibility(8)
    control_bar_id.setVisibility(8)
  end
end
system_incident.global_search_code_results=function()
  system_incident.close_drawer_layout()
  if showfilelist_dlg_2 then
    showfilelist_dlg_2.show()
  end
end
system_incident.global_search_code=function()
  system_incident["close_drawer_layout"]()

  function create_global_search_dlg()
    import "system.system_dialogs"
    local layout_global_search_dlg = import "layout.layout_dialogs.layout_global_search_dlg"
    local global_search_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
    global_search_dlg.setContentView(loadlayout(layout_global_search_dlg))

    dialog_corner(layout_global_search_dlg_background,pc(background_color),radiu)
    widget_radius(global_search_dlg_ok_button,basic_color_num,radiu)
    --global_search_dlg_edittext
    return global_search_dlg
  end

  if global_search_dlg then

   else
    global_search_dlg=create_global_search_dlg()
  end
  global_search_dlg.show()


  global_search_dlg_ok_button.onClick=function()
    global_search_dlg.dismiss()

    current_global_search_key=global_search_dlg_edittext.text
    if current_global_search_key~="" then
      global_loading_dlg.show()
      local search_project_path=initialization_dir
      task(50,function()
        search_filelist(search_project_path,current_global_search_key,search_project_path)
        task(500,function()
          if #showfile_list > 0 then
            showfilelist_dlg = AlertDialog.Builder(activity)
            showfilelist_dlg.setPositiveButton(gets("ok_button"), nil)
            showfilelist_dlg.setTitle(gets("search_results_text").." ("..#showfile_list..")")
            showfilelist_dlg.setItems(showfile_list,{onClick=function(l,v)
                local file_path=search_files_results[v+1]
                local file_object=File(file_path)
                open_file_by_editor(file_object,current_editor_name)
                system_incident.search_code(current_global_search_key)
              end})
            showfilelist_dlg_2=showfilelist_dlg.show()
            set_dialog_style(showfilelist_dlg_2)
           else
            system_print(gets("search_no_results"))
          end
          global_loading_dlg.hide()
          --print(dump(showfile_list))
        end)
      end)
    end
  end

  local will_search_files={}
  showfile_list={}
  search_files_results={}


  function search_file(path,content,search_project_path)
    local all_content=io.open(path):read("*a")
    if get_setting("case_sensitive") then
     else
      all_content=utf8.lower(all_content)
      content=utf8.lower(content)
    end
    if all_content:find(content) then
      --local show_filepath=path:match(search_project_path.."/(.+)")
      local show_filepath=(path:match("app/src/main/assets/(.+)") or path:match(initialization_dir.."(.+)") or path)
      table.insert(showfile_list,show_filepath)
      table.insert(search_files_results,path)
      return true
    end
  end

  function search_filelist(initial_path,content,proj_path)
    ls=File(initial_path).listFiles()
    if ls~=nil then
      ls=luajava.astable(File(initial_path).listFiles()) --全局文件列表变量
      table.sort(ls,function(a,b)
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
      end)
     else
      ls={}
    end

    for index,c in ipairs(ls) do
      if c.isDirectory() then--如果是文件夹则
        --print(initial_path.."/"..c.Name)
        search_filelist(initial_path.."/"..c.Name,content,proj_path)
       else
        if c.isFile() then
          --如果为文件
          if c.Name:find("%.lua$") or c.Name:find("%.aly$") or c.Name:find("%.html$") or c.Name:find("%.css$") or c.Name:find("%.java$") or c.Name:find("%.txt$") or c.Name:find("%.bat$") or c.Name:find("%.xml$") or c.Name:find("%.lsinfo$") or c.Name:find("%.conf$") then
            local file_path=c["path"]
            table.insert(will_search_files,file_path)
            global_loading_dlg.setMessage(file_path)
            search_file(file_path,content,proj_path)
          end
        end
      end
    end
  end
  --search_filelist(path,"layout")
end

system_incident.jump_line=function()
  system_incident["close_drawer_layout"]()
  if toline_bar_id.getVisibility()==8 then
    tool_bar_id.setVisibility(8)
    search_bar_id.setVisibility(8)
    toline_bar_id.setVisibility(0)
    control_bar_id.setVisibility(8)
  end
end

system_incident.project_import=function()
  choose_file(Environment.getExternalStorageDirectory().toString(),function(path,name)
    if name:find("%.alp$") then
      import_alp_project(path)
     else
      import_project(path)
    end
  end,"project_backup_file")
end

system_incident.import_resources=function()
  system_import_resources()
end

system_incident.compile_lua_file=function()
  if (opened_file.Text==gets("file_not_open")) then
    system_print(gets("file_not_open"))
    system_incident["close_drawer_layout"]()
   else
    system_incident["close_drawer_layout"]()
    import "console"
    local asd,str=console.build(opened_file.text)
    if asd then
      system_print("编译完成: "..asd)
      if project_open_file.Text~=gets("project_not_open") then
        local refresh_path=project_open_file.Text
        load_file_list(app_name,refresh_path,project_open_file.Text)
      end
      left_sidebar_refresh_layout.setRefreshing(false);
     else
      system_print("编译出错："..asd)
    end
  end
end

--Lua教程
system_incident.lua_course=function()
  skipLSActivity("lua_course")
end
system_incident.icon_depository=function()
  skipLSActivity("icon_depository",{current_open_project_path})
end
--Lua文档
system_incident.lua_explain=function()
  skipLSActivity("lua_explain")
end
--颜色选择
system_incident.argb_tool=function()
  system_incident["close_drawer_layout"]()
  arbg_dialog_func(function()
    editor.paste(color4)
    editor.requestFocus()
  end,"editor")--(func,arbg_type)
end
--Java Api浏览器
system_incident.java_api=function()
  skipLSActivity("java_api")
end
--配色参考
system_incident.color_reference=function()
  skipLSActivity("color_reference")
end
--布局助手
system_incident.layout_helper=function()
  if opened_file.text:find("%.aly$") then
    skipLSActivity("layout_helper",{initialization_dir_2,opened_file.text},"LuaAppCompatActivity")
   else
    system_print(gets("open_layout_helper_error"))
  end
end

--贡献列表
system_incident.help_roster=function()
  SkipPage("activities/help_roster")
end

system_incident.application_about=function()
  import "system.system_dialogs"
  about_dialog.show()
end

system_incident.night_mode=function(activity_main)
  settings["follow_system_theme"] = false
  local extconfig_path=activity.getLuaExtDir().."/config.lua"
  local config_content="config="..dump(config)
  io.open(extconfig_path,"w"):write(config_content):close()
  local theme_value=activity.getSharedData("system_theme") or "day_time"
  if theme_value=="day_time" then
    activity.setSharedData("system_theme","night_time")
   else
    activity.setSharedData("system_theme","day_time")
  end
  if activity_main then
    SkipPage(activity_main)
    activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
    activity.finish()
   else
    SkipPage("main")
    activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
    activity.finish()
  end
end

system_incident.settings_btn=function()
  skipLSActivity("control_panel")
end

system_incident.exit_tip=function()
  local message=gets("exit_tip")
  system_dialog({title=gets("tip_text"),message=message,positive_button={button_name=gets("exit"),func=function()activity.finish()task(100,function()os.exit()end)end},negative_button={button_name=gets("cancel_button")}})
end

system_incident.exit_application=function()
  save_file()
  system_incident["exit_tip"]()
end

system_incident.check=function()
  if check_opened_file() then
    af=opened_file.Text
    if af:find("%.lua") or af:find("%.aly") then
      local src=editor.getText()
      src=src.toString()
      if af:find("%.aly$") then
        src="return "..src
      end
      local _,data=loadstring(src)
      if data then
        local _,_,line,data=data:find(".(%d+).(.+)")
        editor.gotoLine(tonumber(line))
        system_print(line..":"..data)
        return true
      end
    end
  end
end


--新建工程
system_incident.create_project = function(project_path)
  create_project_dlg()
  create_project_dialog.show()
  create_project_dialog_ok_button.onClick=function()
    --print("create")
    create_newproject(new_app_name.Text,new_app_packagename.Text,function(status,info)
    end)
  end
end

wdploperations={
  [gets("download_text")]=function(name,path)
    wdplodownload(name,path)
  end,
  [gets("download_and_import_text")]=function(name,path)
    wdplodownload(name,path,true)
  end,
  [gets("delete_webdav_file_text")]=function(name,path)
    wdplodelete(name,path)
  end,
  [gets("import_project_text")]=function(name,path)
    mimport_project(wdploutput_path(name,path))
  end,
  [gets("delete_local_file_text")]=function(name,path)
    delete_webdav_local_file(name,path)
  end,
}