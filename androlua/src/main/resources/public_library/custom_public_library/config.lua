config = {
  colors = {
    day_time = {
      tool_bar_color = "#ffffffff",
      background_color = "#ffffffff",
      basic_color = "#448aff",
      text_color = "#212121",
      paratext_color = "#424242",
      gray_color = "#ECEDF1",
      card_background_color = "#ffffffff",
      viewshader_color = "#00000000",
      editor = {
        baseword_color = "#448aff",
        -- 关键字
        keyword_color = "#FF3F7FB5",
        -- 注释
        comment_color = "#7f212121",
        -- 变量
        userword_color = "#009688",
        -- 字符串
        string_color = "#ff4081",
        -- 文本颜色
        editor_text_color = "#ff000000"
      }
    },
    night_time = {
      tool_bar_color = "#ff000000",
      background_color = "#ff191919",
      basic_color = "#ff3368c0",
      text_color = "#808080",
      paratext_color = "#666666",
      gray_color = "#212121",
      card_background_color = "#ff212121",
      viewshader_color = "#80000000",
      editor = {
        baseword_color = "#ff3368c0",
        -- 关键字
        keyword_color = "#FF3F7FB5",
        -- 注释
        comment_color = "#3fffffff",
        -- 变量
        userword_color = "#009688",
        -- 字符串
        string_color = "#FFE57373",
        -- 文本颜色
        editor_text_color = "#fafafefe"
      }
    }
  },
  editor = {
    --编辑器独立窗口
    independent_editor = false,
    debug_windows="LuaAppCompatActivity",
    --实时报错
    realtime_check_error = false,
    defalut_editor = "SoraEditor",
    new_symbol_content={"FUN","(",")","[","]","{","}","<",">","=",'"',"'",",",".",";","_","+","-","*","/","|","\\","%","#","?","重做",'""'},
    symbol_content = [[FUN ( ) [ ] { } " = : . ; _ + - * / \ % # ^ $ ? < > ~ , ' 重做 ]],
    word_wrap = false,
    auto_into_editor = true,
    icons = nil,
  -- 编辑器文件列表自动进入二级目录
    auto_into_secondary_directory=true,
    drawer_lock=false;
    brief_right_sidebar=true,
    quick_boot=false,
    quick_boot_mode2=false,
    lite_windows_mode = false,
    files_auto_save = true,
    old_file_backup = true,
    fast_operations_bar = false,
    operations_bar = false
  },
  bin_moudle={
    settings={
      use_new_version_apk_template=true;
      old_device_compatible=true;
      built_in_tbs_kenrel=false;
      auto_build=true;
      bin_activity_setting = "auto_build";
      -- auto:跟随工程设置，若工程目录下有密钥文件则使用该文件打包 public:若公有目录有则使用公有目录下密钥文件 off:使用默认文件进行打包
      bin_key_settings = "auto"
    },
  },
  -- 通用
  general = {
    settings = {
      auto_login=false;
      --个性化IDE
      use_new_longclick_menu=false;
      custom_mode=false;
      home_page_mode=true,
      follow_system_theme = true,
      -- 自动进入编辑器
      list_inverted_order=false,
       -- 自动进入编辑器（仅在单独窗口模式生效）
      auto_into_editor = true,
      -- 加载对话框是否显示
      loading_dialog_show = false,
      -- 在滑动主页时自动关闭主页搜索栏
      auto_close_search_bar = false,
      -- 在切换主页模式时重新加载列表
      auto_reload = false,
      -- 打开左侧滑时按下返回键返回目录
      autoback_previous_path = true,
      -- 自动返回提示
      autoback_tip = false,
      -- 返回提示
      back_tips = true,
      -- 区分大小写
      case_sensitive = false,
      -- 强制IDE字体大小
      layout_textsize_focus=true,
      quick_boot=false,
      choose_file_module = "ide" -- system 系统 ide 自带--目前暂不支持调用系统
    },
    paths = {
      environment_root_path = activity.getLuaExtDir() .. "/.environment",
      cache_path = activity.getLuaExtDir() .. "/cache",
      bin_cache_path = activity.getLuaExtDir() .. "/cache/bin_project",
      project_path = activity.getLuaExtDir() .. "/projects",
      backup_path = activity.getLuaExtDir() .. "/backup",
      plugin_path = activity.getLuaExtDir() .. "/plugin",
      custom_path = activity.getCustomDir() .. "",
      data_storage = tostring(activity.getExternalFilesDir("")),
    },
    -- 字体
    fonts = {},
    -- 图标
    icons = {
      qrcode_icon = "/res/icons/qrcode.lsicon",
      delete_icon = "/res/icons/delete_96x96.lsicon",
      more_icon = "/res/icons/ic_more_menu.lsicon",
      format_icon = "/res/icons/twotone_format_align_left_black_24dp.lsicon",
      download_icon = "/res/icons/twotone_get_app_black_24dp.lsicon",
      other_file_icon = "/res/icons/twotone_insert_drive_file_black_24dp.lsicon",
      share_icon = "/res/icons/twotone_open_in_new_black_24dp.lsicon",
      pause_icon = "/res/icons/twotone_pause_black_24dp.lsicon",
      upload_icon = "/res/icons/twotone_publish_black_24dp.lsicon",
      apk_list_icon = "/res/icons/twotone_work_black_24dp.lsicon",
      exit_icon = "/res/icons/twotone_exit_to_app_black_24dp.lsicon",
    }
  }
}
