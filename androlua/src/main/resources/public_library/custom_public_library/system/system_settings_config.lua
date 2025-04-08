color_set_key={
  gets("toolbar_color"),
  gets("background_color"),
  gets("basic_color"),
  gets("text_color"),
  gets("paratext_color"),
  --gets("gray_color"),
  gets("cardbackground_color"),
}

color_set_subtitle={
  [gets("toolbar_color")]="",
  [gets("background_color")] = "",
  [gets("basic_color")] = "",
  [gets("text_color")] = "",
  [gets("paratext_color")] = "",
  [gets("gray_color")] = "",
  [gets("cardbackground_color")] = ""
}

color_set={
  [gets("toolbar_color")]="tool_bar_color",
  [gets("background_color")] = "background_color",
  [gets("basic_color")] = "basic_color",
  [gets("text_color")] = "text_color",
  [gets("paratext_color")] = "paratext_color",
  [gets("gray_color")] = "gray_color",
  [gets("cardbackground_color")] = "card_background_color"
}

editor_color_set_key={
  gets("baseword_color"),
  gets("keyword_color"),--关键字
  gets("comment_color"),--注释颜色
  gets("userword_color"),--变量颜色
  gets("string_color"),--字符串颜色
  gets("editor_text_color"),--文本颜色
}

editor_color_set_subtitle={
  [gets("baseword_color")]="Editor颜色",
  [gets("keyword_color")] = "background_color",
  [gets("comment_color")] = "basic_color",
  [gets("userword_color")] = "text_color",
  [gets("string_color")] = "paratext_color",
  [gets("editor_text_color")] = "gray_color",
}

editor_color_set={
  [gets("baseword_color")]="baseword_color",
  [gets("keyword_color")] = "keyword_color",
  [gets("comment_color")] = "comment_color",
  [gets("userword_color")] = "userword_color",
  [gets("string_color")] = "string_color",
  [gets("editor_text_color")] = "editor_text_color",
}

ide_general_settings={
  --"quick_boot",
  --"quick_boot_mode2",
  "home_page_mode",
  "follow_system_theme",
  "auto_into_editor",
  "auto_close_search_bar",
  "auto_reload",
  "autoback_previous_path",
  "case_sensitive",
  "loading_dialog_show",
  "list_inverted_order",
  "layout_textsize_focus",
}

ide_general_settings["quick_boot"]=gets("quick_boot_info")
ide_general_settings["quick_boot_mode2"]="特别注意：在更新LuaStudio+之前记得关闭此模式。测试阶段，可能存在bug。"
ide_general_settings["home_page_mode"]="主页模式"
ide_general_settings["follow_system_theme"]="跟随系统主题"--启动后自动进入编辑器
ide_general_settings["auto_into_editor"]=gets("settings_auto_into_editor")--启动后自动进入编辑器
ide_general_settings["auto_close_search_bar"]=gets("settings_auto_close_search_bar")--主页自动关闭搜索栏（翻页）
--ide_general_settings["auto_reload"]=gets("settings_auto_reload")--自动加载主页列表等
ide_general_settings["autoback_previous_path"]=gets("settings_autoback_previous_path")--打开左侧滑时按下返回键返回目录
ide_general_settings["autoback_tip"]=gets("settings_autoback_tip")--返回不弹出提示
ide_general_settings["loading_dialog_show"]=gets("settings_loading_dialog_show")--显示加载对话框
ide_general_settings["case_sensitive"]=gets("settings_case_sensitive")--搜索功能区分大小写（搜索）
ide_general_settings["list_inverted_order"]=gets("settings_list_inverted_order")--列表数据倒序
ide_general_settings["layout_textsize_focus"]=gets("settings_layout_textsize_focus")--布局字体强制大小

ide_general_settings["quick_boot_title"]=gets("quick_boot")
ide_general_settings["quick_boot_mode2_title"]=gets("quick_boot")
ide_general_settings["home_page_mode_title"]="主页模式"
ide_general_settings["follow_system_theme_title"]="跟随系统主题"--启动后自动进入编辑器
ide_general_settings["auto_into_editor_title"]=gets("settings_auto_into_editor_title")--启动后自动进入编辑器
ide_general_settings["auto_close_search_bar_title"]=gets("settings_auto_close_search_bar_title")--主页自动关闭搜索栏（翻页）
ide_general_settings["auto_reload_title"]=gets("settings_auto_reload_title")--自动加载主页列表等
ide_general_settings["autoback_previous_path_title"]=gets("settings_autoback_previous_path_title")--打开左侧滑时按下返回键返回目录
ide_general_settings["autoback_tip_title"]=gets("settings_autoback_tip_title")--返回不弹出提示
ide_general_settings["loading_dialog_show_title"]=gets("settings_loading_dialog_show_title")--显示加载对话框
ide_general_settings["case_sensitive_title"]=gets("settings_case_sensitive_title")--搜索功能区分大小写（搜索）
ide_general_settings["list_inverted_order_title"]=gets("settings_list_inverted_order_title")--列表数据倒序
ide_general_settings["layout_textsize_focus_title"]=gets("settings_layout_textsize_focus_title")--布局字体强制大小

ide_editor_settings={
  "drawer_lock",
  "independent_editor",
  "realtime_check_error",
  "brief_right_sidebar",
  "files_auto_save",
  "auto_into_secondary_directory",
  "old_file_backup",
  "fast_operations_bar",
  "operations_bar",
  "symbol_bar_settings"
}
ide_editor_settings["drawer_lock"]=gets("settings_drawer_lock")--编辑器侧滑栏锁定
ide_editor_settings["independent_editor"]=gets("settings_independent_editor")--编辑器独立窗口
ide_editor_settings["realtime_check_error"]=gets("realtime_check_error")--实时查错
ide_editor_settings["brief_right_sidebar"]="打开后，将使用popupMenu作为功能菜单"--启动后自动进入编辑器

ide_editor_settings["files_auto_save"]="打开后，打开的文件将会自动保存"--启动后自动进入编辑器
ide_editor_settings["old_file_backup"]="打开后，打开的文件检测到修改时会自动备份（仅支持SoraEditor）"--启动后自动进入编辑器
ide_editor_settings["operations_bar"]="编辑器顶部快速功能栏"--启动后自动进入编辑器
ide_editor_settings["fast_operations_bar"]="编辑器底部快速操作栏"--启动后自动进入编辑器
ide_editor_settings["symbol_bar_settings"]="可对符号栏的符号进行自定义"--启动后自动进入编辑器

ide_editor_settings["drawer_lock_title"]=gets("settings_drawer_lock_title")--编辑器侧滑栏锁定
ide_editor_settings["independent_editor_title"]=gets("settings_independent_editor_title")--编辑器独立窗口
ide_editor_settings["realtime_check_error_title"]=gets("realtime_check_error_title")--实时查错
ide_editor_settings["brief_right_sidebar_title"]="极简功能栏"--启动后自动进入编辑器
ide_editor_settings["files_auto_save_title"]="自动保存"--启动后自动进入编辑器
ide_editor_settings["old_file_backup_title"]="自动备份（高性能）"--启动后自动进入编辑器
ide_editor_settings["fast_operations_bar_title"]="底部快速操作栏"--启动后自动进入编辑器
ide_editor_settings["operations_bar_title"]="顶部快速功能栏"--启动后自动进入编辑器
ide_editor_settings["symbol_bar_settings_title"]="符号栏设置"--启动后自动进入编辑器
ide_editor_settings["auto_into_secondary_directory"]=gets("settings_auto_into_secondary_directory")--进入编辑器后自动打开二级目录
ide_editor_settings["auto_into_secondary_directory_title"]=gets("settings_auto_into_secondary_directory_title")--进入编辑器后自动打开二级目录

cloud_settings={
  "webdav",
}
cloud_settings["webdav"]=gets("settings_webdav")
cloud_settings["webdav_title"]=gets("webdav_title")