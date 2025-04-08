-- Settings--
function load_settings()
  --主页模式
  if settings["home_page_mode"]~=nil then
   else
    settings["home_page_mode"] = false
  end
  -- 显示加载对话框
  if settings["loading_dialog_show"]~=nil then
   else
    settings["loading_dialog_show"] = false
  end
  -- 区分大小写（搜索）
  if settings["case_sensitive"]~=nil then
   else
    settings["case_sensitive"] = false
  end
  -- 主页自动关闭搜索栏（翻页）
  if settings["auto_close_search_bar"]~=nil then
    auto_close_search_bar = settings["auto_close_search_bar"]
   else
    auto_close_search_bar = false
  end
  -- 自动加载主页列表等
  if settings["auto_reload"]~=nil then
    auto_reload = settings["auto_reload"]
   else
    auto_reload = false
  end
  -- 打开左侧滑时按下返回键返回目录
  if settings["autoback_previous_path"]~=nil then
    autoback_previous_path = settings["autoback_previous_path"]
   else
    autoback_previous_path = true
  end
  -- 返回不弹出提示
  if settings["autoback_tip"]~=nil then
    autoback_tip = settings["autoback_tip"]
   else
    autoback_tip = false
  end
  -- 返回不弹出提示
  if settings["back_tips"]~=nil then
    back_tips = settings["back_tips"]
   else
    back_tips = false
  end
  -- 新版长按菜单
  if settings["use_new_longclick_menu"]~=nil then
    use_new_longclick_menu = settings["use_new_longclick_menu"]
   else
    use_new_longclick_menu = false
  end
  -- 新版长按菜单
  if settings["auto_login"]~=nil then
    auto_login = settings["auto_login"]
   else
    auto_login = false
  end
  -- 列表数据倒序
  if settings["list_inverted_order"]~=nil then
    list_inverted_order = settings["list_inverted_order"]
   else
    list_inverted_order = false
  end

  -- 编辑器侧滑栏锁定
  if editor_data["drawer_lock"]~=nil then
    drawer_lock = editor_data["drawer_lock"]
   else
    drawer_lock = true
  end
  -- brief_right_sidebar
  if editor_data["operations_bar"]~=nil then
   else
    editor_data["operations_bar"] = false
  end
  -- 编辑器独立窗口
  if editor_data["debug_windows"]~=nil then
    debug_windows = editor_data["debug_windows"]
   else
    debug_windows = "LuaAppCompatActivity"
    editor_data["debug_windows"]=debug_windows
  end
  --实时报错
  if editor_data["realtime_check_error"]~=nil then
   else
    editor_data["realtime_check_error"] = false
  end

  lite_windows_mode=false
  old_file_backup=true
  --[[if editor_data["lite_windows_mode"]~=nil then
    lite_windows_mode = editor_data["lite_windows_mode"]
else
end]]
  -- 布局字体强制大小
  if settings["layout_textsize_focus"]~=nil then
    layout_textsize_focus = editor_data["layout_textsize_focus"]
   else
    layout_textsize_focus = true
  end

  if activity.getSharedData("auto_theme_value") then
   else
    activity.setSharedData("auto_theme_value",false)
  end
  --write_file(extconfig_path,"config="..dump(config))
end