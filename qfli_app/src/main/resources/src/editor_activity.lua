import "editor.editor_funlib"
import "editor.editor_util"
import "editor.editor_incidents"
project_path=activity.getLuaExtDir()
proj_path=...
print(proj_path)
current_editor_name=(current_editor_name or "SoraEditor")

activity.setContentView(R.layout.activity_editor_main)

editor_pgs_tv_background=activity.findViewById(R.id.editor_pgs_tv_background)
editor_pgs_tv=activity.findViewById(R.id.editor_pgs_tv)
editor_opeartions_bar=activity.findViewById(R.id.editor_opeartions_bar)
editor_tab_layout=activity.findViewById(R.id.editor_tab_layout)
home_framelayout=activity.findViewById(R.id.home_framelayout)
editor_background=activity.findViewById(R.id.editor_background)
bottom_root_layout=activity.findViewById(R.id.bottom_root_layout)
left_sidebar=activity.findViewById(R.id.left_sidebar)
left_sidebar_background=activity.findViewById(R.id.left_sidebar_background)
right_sidebar=activity.findViewById(R.id.right_sidebar)
right_sidebar_background=activity.findViewById(R.id.right_sidebar_background)
grid_view_root_layout=activity.findViewById(R.id.grid_view_root_layout)
dl_btm_nightmode_btn=activity.findViewById(R.id.dl_btm_nightmode_btn)
dl_btm_about_btn=activity.findViewById(R.id.dl_btm_about_btn)
dl_btm_settings_btn=activity.findViewById(R.id.dl_btm_settings_btn)
dl_btm_exit_btn=activity.findViewById(R.id.dl_btm_exit_btn)

left_sidebar_title_bar=activity.findViewById(R.id.left_sidebar_title_bar)
ch_project_path=activity.findViewById(R.id.ch_project_path)
project_open_file=activity.findViewById(R.id.project_open_file)
proj_list_button=activity.findViewById(R.id.proj_list_button)
ch_filelist_back_button=activity.findViewById(R.id.ch_filelist_back_button)
ch_add_file=activity.findViewById(R.id.ch_add_file)
ch_add_file_img=activity.findViewById(R.id.ch_add_file)
ch_more_fileoperation_close=activity.findViewById(R.id.ch_more_fileoperation_close)
ch_more_fileoperation=activity.findViewById(R.id.ch_more_fileoperation)
ch_menu_lay=activity.findViewById(R.id.ch_menu_lay)
search_edit=activity.findViewById(R.id.search_edit)
project_list_search=activity.findViewById(R.id.project_list_search)
file_rv=activity.findViewById(R.id.file_rv)
left_sidebar_refresh_layout=activity.findViewById(R.id.left_sidebar_refresh_layout)
list_background=activity.findViewById(R.id.list_background)

editorViewPager=activity.findViewById(R.id.editorViewPager)
editorViewPager.setVisibility(8)
editor_background=activity.findViewById(R.id.editor_background)

tool_bar_background=activity.findViewById(R.id.tool_bar_background)
toolbar_include=activity.findViewById(R.id.toolbar_include)
toolbar_include.setVisibility(8)

--侧滑
drawer_layout=activity.findViewById(R.id.drawer_layout)
drawer_layout.setScrimColor(pc(get_theme_color("background_color")))
drawer_layout.setLayoutTransition(newLayoutTransition())

main_progressbar=activity.findViewById(R.id.main_progressbar)

tool_bar=import "layout.layout_editor.editor_tool_bar"
tool_bar_background.addView(loadlayout(tool_bar))
tool_bar_background.setLayoutTransition(newLayoutTransition())

import "system.system_funlibs"

open_file_auto_format=true
updateUI({progressbar_status=true})
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);


if get_setting("home_page_mode") then
else
  local opened_project_file_path = activity.getLuaDir() .. "/memory_file/opened_project.table"--工程信息，历史打开文件，历史打开文件夹
  pcall(dofile,opened_project_file_path)
  if opened_project_info then
    local his_proj_path=opened_project_info["history_project_path"] or nil
    local auto_open=opened_project_info["auto_open"]
    if ((his_proj_path and File(his_proj_path).exists()) and (auto_open and auto_open==true)) then
      load_status=true
      if check_project_info(his_proj_path) then
        proj_path=his_proj_path
      end
    end
  end
end

main_handler_run(function()
  load_sidebar()
  load_other_editor_components()
  load_main_editor_view()
  main_handler_run(load_all_paths)
  init_editor_components()
  load_all_editor_settings()
  if proj_path then
    main_handler_run(set_project(proj_path))
   else
    main_handler_run(load_projects_list,500)
  end
end,500)



function load_tool_bar()
  updateUI({progressbar_status=true})
  local editor_control_bar=import "layout.layout_editor.editor_control_bar"
  local editor_search_bar=import "layout.layout_editor.editor_search_bar"
  local editor_toline_bar=import "layout.layout_editor.editor_toline_bar"
  local error_bar=import "layout.layout_editor.editor_error_bar"
  tool_bar_background.addView(loadlayout(editor_control_bar))
  tool_bar_background.addView(loadlayout(editor_search_bar))
  tool_bar_background.addView(loadlayout(editor_toline_bar))
  tool_bar_background.addView(loadlayout(error_bar))
  control_bar_title.setText(gets("choose_text"))
  editor_search_bar_edit.hint=(gets("search_tip"))
  toline_bar_edit.hint=(gets("toline_tip"))
  import "android.text.InputType"
  import "android.text.method.DigitsKeyListener"
  toline_bar_edit.setInputType(InputType.TYPE_CLASS_NUMBER)
  toline_bar_edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))

  view_radius(editor_search_bar_edit_root,dp2px(4),pc(gray_color))
  view_radius(toline_bar_edit_root,dp2px(4),pc(gray_color))
  load_tool_bar_incidents()
  updateUI({progressbar_status=false})
end

function load_sidebar(right_sidebar_status)
  updateUI({progressbar_status=true})
  import "layout.layout_editor.editor_sidebar"
  if right_sidebar_status==false then
   else
    if get_editor_setting("brief_right_sidebar") then  
    else
           local right_sidebar=editor_sidebar["new_right_sidebar"]
           grid_view_root_layout.addView(loadlayout(right_sidebar))
  end
end
  view_radius(search_edit,dp2px(4),pc(gray_color))
  load_sidebar_incidents()
  updateUI({progressbar_status=false})
end

function load_other_editor_components()

  fast_operation_bar=activity.findViewById(R.id.fast_operation_bar)
  finsert_code_button=activity.findViewById(R.id.finsert_code_button)
  fcode_operation_button=activity.findViewById(R.id.fcode_operation_button)
  fformat_button=activity.findViewById(R.id.fformat_button)
  fpaste_button=activity.findViewById(R.id.fpaste_button)
  fredo_button=activity.findViewById(R.id.fredo_button)
  symbol_bar_background=activity.findViewById(R.id.symbol_bar_background)
  symbol_bar=activity.findViewById(R.id.symbol_bar)
  editor_symbols_bar=activity.findViewById(R.id.editor_symbols_bar)
  fast_button_close=activity.findViewById(R.id.fast_button_close)
  fast_button_close_icon=activity.findViewById(R.id.fast_button_close_icon)


end

function bin_update(content)
if content then
  if build_apk_status then
    build_apk_status='=>'..content.."\n"..build_apk_status
  else
    build_apk_status=content
  end
  WriteFile(bin_log_file,build_apk_status)
  editor_pgs_tv.setText(content)
end
end

function bin_callback(s)
if s then
  main_progressbar.setVisibility(8)
  editor_pgs_tv_background.setVisibility(8)
  buildTasks.cancel(true)
  buildTasks=nil
  build_apk_status=nil
end
end

function check_environment()
  local androidjarPath=activity.getSharedData("android_jar_path") or activity.getLuaExtDir(".environment").."/res/android.jar"
if File(androidjarPath).exists() then
  return true
else
  return false
end
end

function bin_project()
  import "system.system_bin"
  if current_open_project_path then
local current_proj_path=current_open_project_path
if buildTasks then
else

  local current_time=os.date("%Y-%m-%d_%H%M%S")
  bin_log_file=activity.getLuaExtDir("cache").."/build_log_"..tostring(current_time)..".txt"
  local status,str=pcall(dofile,current_proj_path.."/build.lsinfo")
  if status and build_info then
    local app_name=build_info["appname"]
    local app_ver=build_info["appver"]
    local app_code=build_info["appcode"]
    local template=build_info["template"]
    if template=="lua_java" then
      if (not check_environment()) then
        system_print("请检查打包环境配置")
      return
      end
    end
    build_info["apkName"]=app_name.. "_" .. app_ver .. "_" .. app_code .. ".apk"
    build_apk_path=current_proj_path.."/build/apk/"..build_info["apkName"]
    build_info["autoOpenStatus"]=autoOpenStatus
    build_info["projectPath"]=current_proj_path
    build_info["signLibrary"]=getSharedData("signLibrary") or true
    buildTasks=activity.newTask(build_pro, bin_update,bin_callback)
    task(50,function()
      main_progressbar.setVisibility(0)
      editor_pgs_tv_background.setVisibility(0)
      buildTasks.execute({build_info})
    end)
  end
end
  end
end

function rebuild_data_table()
  open_files_info={}

  open_files={}
  open_files_editors={}
  editors_position={}
end

function rebuild_all_data()
  if current_editor_name=="SoraEditor" then
    sora_editor_position={}
   else
    lua_editor_position={}
  end
  rebuild_data_table()
  if editors_adp_titles then
    editors_adp_titles.clear()
  end
  if editors_adp_views then
    editors_adp_views.clear()
  end
end

function check_current_file_changed()
  if current_file then
    local file_path=current_file["path"]
    local status,content=read_file(file_path)
    if status and content then
      local current_content=current_editor.text
      if content~=current_content then
        local delete_tip_dialog=MaterialAlertDialogBuilder(activity)
        delete_tip_dialog.setTitle(gets("tip_text"))
        delete_tip_dialog.setMessage("检测到当前文件已被修改，是否更新内容到编辑器？")
        delete_tip_dialog.setPositiveButton(gets("ok_button"),function()

          current_editor.setText(content)
        end)
        delete_tip_dialog.setNegativeButton(gets("cancel_button"),nil)
        delete_tip_dialog_2=delete_tip_dialog.show()
        set_dialog_style(delete_tip_dialog_2)
      end
    end
  end
end

function init_editor_components()

  import "system_incident"
  import {
    "editor.editor_operations_bar",
    "editor.editor_operations_funlib",
    --"editor.editor_funlib"
  }
  current_editor_lib=editor_opeartions[current_editor_name]
  quiet_light_path=activity.getLuaDir().."/system/editor/quiet_light.json"
  quiet_dark_path=activity.getLuaDir().."/system/editor/quiet_dark.json"

  if (theme_value and theme_value=="night_time") then
    --print("night")
    editor_theme_file_path=quiet_dark_path
   else
    editor_theme_file_path=quiet_light_path
  end
  --print(theme_value)

  rebuild_all_data()
  --print(control_bar)
  import "java.io.BufferedReader"
  import "java.io.InputStreamReader"
  import "system.system_funlibs"

  files_backup_dir=activity.getExternalFilesDir("files_backup")
  files_bin_dir=activity.getExternalFilesDir("files_bin")

  editor_opeartions_bar.tabTextAppearance=R.style.TabLayoutTextStyle
  editor_tab_layout.tabTextAppearance=R.style.TabLayoutTextStyle
  editor_tab_layout.setupWithViewPager(editors_vp);

  local LuaBasePagerAdapter = luajava.bindClass("com.luastudio.azure.adapter.LuaBasePagerAdapter")
  editors_adp_titles=ArrayList()
  editors_adp_views=ArrayList()
  editors_adp=LuaBasePagerAdapter(editors_adp_views,editors_adp_titles)
  editors_vp.setAdapter(editors_adp)
  editors_vp.addOnPageChangeListener{
    onPageSelected=function(position)
      --print(open_files_info[position+1])
      current_file_name=open_files_info[position+1]
      current_file_info=(open_files_info[current_file_name] or {})
      current_file=(current_file_info["file_object"] or current_file)
      current_open_file_path=(current_file~=nil and current_file["path"])
      current_editor=current_file_info["editor"]

      current_file_language=current_file_info["file_language"]

      update_open_file_path(current_open_file_path)
      auto_show_layout_helper(current_file_name or current_open_file_path)

      pcall(check_current_file_changed)
    end
  }
end


function save_history_project_info(boolean)
  local proj_path_2=(current_open_project_path or proj_path)
  if proj_path_2 then
    local opened_project_info={}
    opened_project_info["history_project_path"]=proj_path_2
    opened_project_info["auto_open"]=boolean

    local opened_project_file_path = activity.getLuaDir() .. "/memory_file/opened_project.table"--工程信息，历史打开文件，历史打开文件夹
    write_file(opened_project_file_path,"opened_project_info="..dump(opened_project_info))
  end
end


function load_all_editor_settings()
  import "system.system_dialogs"
  import "editor.editor_settings"

  import "system.system_config"

  filelist_tree={}
  deleting_file_dialog,deleting_file_dialog2=create_progress_dlg(gets("deleting_tips"),gets("deleting_message_tips"))

  --输入法影响布局
  activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

  main_handler_run(load_surface_ripple,600)


  support_languages=current_editor_lib["get_support_languages"]()

  if realtime_check_error then
    realtime_check_error_status=true
    if current_editor_name=="SoraEditor" then
     else
      thread(check_code_thread)
    end
    --circle_message_handler(check_code_main)
  end


  --editor_opeartions_bar.setSelectedTabIndicatorColor(pc(get_theme_color("background_color")))
  project_open_file.onLongClick=system_incident["view_copy"]
  main_title_id.onLongClick=system_incident["view_copy"]
  opened_file.onLongClick=system_incident["view_copy"]

  smybols_quick_codes={}
  smybols_quick_codes[gets("redo")]=function()
    current_editor_lib["redo"](current_editor)
  end
  editor_symbols=editor_data["new_symbol_content"]

  main_handler_run(load_symbols_bar,200)

  files_adapter,files_adapter_data=init_files_adpater()
  local layout_manager = LinearLayoutManager(activity, RecyclerView.VERTICAL, false);
  file_rv.setLayoutManager(layout_manager)
  file_rv.setAdapter(files_adapter)
  load_filelist_icons()
  lfile_img=load_icon_path("description")
  lpho_img=load_icon_path("photo")
  lother_file_img=load_icon_path("insert_drive_file")
  filelist_icons={}
  filelist_icons["%.lua$"]=lllua_file_img
  filelist_icons["%.aly$"]=llaly_file_img
  filelist_icons["%.java$"]=lljava_file_img
  filelist_icons["%.html$"]=llhtml_file_img
  filelist_icons["%.css$"]=llcss_file_img

  search_edit.setOnEditorActionListener(TextView.OnEditorActionListener{
    onEditorAction=function(view,actionId,event)
      local_files_list_search_key=view.text
      if files_adapter then
        files_adapter.notifyDataSetChanged()
      end
      return false
    end
  })

  if get_editor_setting("fast_operations_bar") then
    main_handler_run(load_fast_operations_bar,800)
  else
    fast_button_close.onLongClick=function()
        current_editor_lib["goto_line"](current_editor,1)
      return true
    end
  end

  SearchOptions=luajava.bindClass "io.github.rosemoe.sora.widget.EditorSearcher$SearchOptions"
  
  if get_editor_setting("operations_bar") then
    main_handler_run(load_operations_bar,400)
  end
  --load_right_sidebar()
  main_handler_run(load_right_sidebar,1000)
  main_handler_run(load_all_incidents,500)
  main_handler_run(load_all_click_incidents,800)

  searchOptions=SearchOptions(false, false)

  function onDestroy()

  end


  function onPause()
    if get_editor_setting("files_auto_save") then
      save_all_files()
    end
  end

  function onResume()
    if init_project_files_list_status then
      main_handler_run(reload_files_list(),1000)
    end
    pcall(check_current_file_changed)
    request_editor_focus()
  end

  function onDestroy()

    if get_editor_setting("files_auto_save") then
      save_all_files()
    end
    clear_all_runnables()
    realtime_check_error_status=false
  end
end


function request_editor_focus()
  if ((!drawer_layout.isDrawerOpen(3)) and (!drawer_layout.isDrawerOpen(5))) then
    if current_editor then
      current_editor.requestFocus()
    end
  end
end


import "androidx.drawerlayout.widget.DrawerLayout"

drawer_layout.setDrawerListener(DrawerLayout.DrawerListener{
  onDrawerClosed=function(drawerView)--侧滑关闭时
    request_editor_focus()
  end;
  onDrawerOpened=function(drawerView)--侧滑展开时
    request_editor_focus()
    drawerView.setClickable(true);
  end;
  onDrawerSlide=function(drawerView,slideOffset)
    request_editor_focus()
  end
})


function load_main_editor_view()
  local editor_view={
    AutoEditorViewPager{
      id="editors_vp";
    };
  };
  local loaded_editor_view=loadlayout(editor_view)
  editor_background.addView(loaded_editor_view)
end

function onPause()
  clear_all_runnables()
end

function onDestroy()
  clear_all_runnables()
end

function onResult(name,...)
  --活动返回
  callback=...
  if callback=="project_info_changed" then
    reload_project_info_to_surface()
  end
end

parameter = 0
function onKeyDown(code, event)
  if string.find(tostring(event), "KEYCODE_BACK") ~= nil then
    if drawer_layout.isDrawerOpen(5) then
      system_incident["close_drawer_layout"]()
     elseif drawer_layout.isDrawerOpen(3) then
      if file_list_checkbox_status then
        file_list_checkbox_status=false
        files_adapter.notifyDataSetChanged()
       else
        back_last_dir()
      end
     else
      if back_tips then
        if parameter + 2 > tonumber(os.time()) then
          --[[if check_opened_file() then
            save_file(false) 
          end]]
          --activity.finish()
          save_history_project_info(false)
          activity.result({"editor_back"})
         else
          system_print(gets("back_tip"))
          parameter=tonumber(os.time())
        end
       else
        --[[if check_opened_file() then
          save_file(false)
        end]]
        --activity.finish()
        save_history_project_info(false)
        activity.result({"editor_back"})
      end
    end
    return true
  end
end

