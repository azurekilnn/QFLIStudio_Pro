import "system.system_imports"
internal_storage=Environment.getExternalStorageDirectory().toString()
--文件备份
files_backup_dir=activity.getExternalFilesDir("files_backup")
files_bin_dir=activity.getExternalFilesDir("files_bin")
format_backup_dir=activity.getExternalFilesDir("format_backup")

extconfig_path=activity.getLuaExtDir().."/config.lua"
webdav_save_path=tostring(activity.getExternalFilesDir("/Documents"))
webdav_deleted_backup_path=tostring(activity.getExternalFilesDir("/deleted_file/download"))
system_strings_memory_filepath=activity.getLuaDir().."/memory_file/table_system_strings.conf"
projects_memory_filepath=activity.getLuaDir().."/memory_file/table_projects_info.conf"
error_projects_memory_filepath=activity.getLuaDir().."/memory_file/table_error_projects_info.conf"
webdav_memory_filepath=activity.getLuaDir().."/memory_file/table_webdav_projects_info.conf"


luastudio_download_path=activity.getLuaExtDir().."/download"
resources = activity.getResources()

sdk_version=Build.VERSION.SDK_INT
smallestScreenWidthDp=resources.getConfiguration().smallestScreenWidthDp
pad_mode=smallestScreenWidthDp>=600

--全局变量
LuaStudio1=R.style.Theme_LuaStudio_Light
LuaStudio2=R.style.Theme_LuaStudio_Night
Theme_LuaStudio=R.style.Theme_LuaStudio

import "java.util.Locale"
NowLanguage = Locale.getDefault().getLanguage();

themes={
  night_time=Theme_LuaStudio,
  day_time=Theme_LuaStudio,
}
cloud_url="https://www.lqsxm666.top/cloud/?/images/"
-- load_config
if not pcall(dofile,extconfig_path) then
  import "config"
end

import {
  -- system theme
  "system.system_theme",
  -- system function
  "system.system_custom",
  "system.system_funlib",
  -- system language
  "system.system_strings",
  "system.system_settings",
  "system.system_incident",
  "system.system_layouts",
}

JsonUtil = require("JsonUtil")


app_type_table = {
  gets("lua_common_project"),
  gets("luajava_mix_project")
}
newapp_type_table = {
  [gets("lua_common_project")] = "common_lua",
  [gets("luajava_mix_project")] = "lua_java"
}
project_type = {
  common_lua = gets("lua_common_project"),
  lua_java = gets("luajava_mix_project")
}


--捐赠对话框二维码
donation_dialog_img_data = {
  [gets("alipay")] = activity.getLuaDir() .. "/donation_qr_code/alipay.png",
  [gets("weixin")] = activity.getLuaDir() .. "/donation_qr_code/weixin.png",
  [gets("qq")] = activity.getLuaDir() .. "/donation_qr_code/qq.png"
};


import "android.content.res.ColorStateList"
-- Ripple
circular_ripple_res = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
square_ripple_res = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)

common_ripple=0x3f000000
card_ripple_color=0x22000000
white_ripple_color=0x3fffffff
black_ripple_color=common_ripple

white_ripple_csl=ColorStateList(int[0].class{int{}},int{white_ripple_color})
black_ripple_csl=ColorStateList(int[0].class{int{}},int{black_ripple_color})
theme_ripple_csl=ColorStateList(int[0].class{int{}},int{0x3f448aff})


radiu=15
radius=30

function setWindowTitle(title)
  activity.setTitle(title)
  if main_title_id then
    main_title_id.setText(title)
  end
end

function load_common_components()
  import "layout.layout_table.layout_assembly"
  tool_bar = layout_assembly["tool_bar"]
  search_bar = layout_assembly["search_bar"]
  drawer_layout = layout_assembly["drawer_layout"]
end

function load_tool_bar(mode)
  import "layout.layout_table.layout_assembly"
  tool_bar = layout_assembly["tool_bar"]
end


function setContentView(layout)
  activity.setContentView(layout)
end

function setCommonView(main_view,title,mode)
  local main_view=loadlayout(main_view)
  local common_view={
    LinearLayoutCompat;
    layout_height="fill";
    layout_width="fill";
    orientation="vertical";
    backgroundColor=background_color;
  };
  local common_view = loadlayout(common_view)
  load_system_incidents()

  import "layout.layout_table.layout_assembly"
  local tool_bar = layout_assembly["tool_bar"]
  local search_bar = layout_assembly["search_bar"]
  if mode=="back_mode" then
    local tool_bar = loadlayout(tool_bar)
    common_view.addView(tool_bar)
    --返回按钮
    if back_button then
      back_button.setVisibility(0)
    end
    if menu_img then
      menu_img.setVisibility(8)
    end
   elseif mode=="back_with_more_mode" then
    local tool_bar = loadlayout(tool_bar)
    common_view.addView(tool_bar)
    --返回按钮
    if back_button then
      back_button.setVisibility(0)
    end
    if menu_img then
      menu_img.setVisibility(8)
    end
    --更多按钮
    if more_button then
      more_button.setVisibility(0)
    end
   elseif mode=="white_page" then
   elseif mode=="editor_top_bar" then
    local editor_control_bar = layout_assembly["editor_control_bar"]
    local editor_top_bar = layout_assembly["editor_top_bar"]
    local editor_top_bar=loadlayout(editor_top_bar)
    local editor_control_bar=loadlayout(editor_control_bar)
    common_view.addView(editor_top_bar)
    common_view.addView(editor_control_bar)

   elseif mode=="back_with_search_mode" then
    local tool_bar = loadlayout(tool_bar)
    parameter=0
    function onKeyDown(code,event)
      if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
        if search_bar_id.getVisibility()==8 then
          if parameter+2 > tonumber(os.time()) then
            activity.finish()
           else
            system_print(gets("back_tip"))
            parameter=tonumber(os.time())
          end
         else
          search_bar_id.setVisibility(8)
          tool_bar_id.setVisibility(0)
        end
        return true
      end
    end


    if back_button then
      back_button.setVisibility(0)
    end
    if menu_img then
      menu_img.setVisibility(8)
    end
    --更多按钮
    if more_button then
      more_button.setVisibility(0)

    end
    common_view.addView(tool_bar)
    local search_bar = loadlayout(search_bar)
    common_view.addView(search_bar)
    --搜索按钮
    more_button.setVisibility(8)
    --search_bar_search_button.setVisibility(8)
    search_button.setVisibility(0)
    system_ripple({search_bar_cancel_button,search_bar_search_button},"circular_theme")
    setImage(search_bar_cancel_button_img,load_icon_path("close"))
    if search_bar_edit then
      search_bar_edit.setHint(gets("search_tips"))
    end
    search_bar_cancel_button.onClick=function()
      search_bar_id.setVisibility(8)
      tool_bar_id.setVisibility(0)
    end

    search_button.onClick=function()
      tool_bar_id.setVisibility(8)
      search_bar_id.setVisibility(0)
    end

  end

  system_ripple({search_button,back_button,more_button},"circular_theme")

  if title then
    --设置标题
    set_window_title(title)
  end
  common_view.addView(main_view)
  setContentView(common_view)
end

function loadLocalUrl(webview_id,url)
  webview_id.loadUrl("file://"..activity.getLuaDir().."/"..url)
end

function change_color_strength(strength,color)
  return (tonumber("0x"..strength..string.sub(Integer.toHexString(color),3,8)))
end

function main_handler_run(func,delay)
  local delay_time
  if delay then
    delay_time=delay
   else
    delay_time=0
  end
  --异步执行
  if func then
    if main_handler then
     else
      main_handler=Handler()
      main_handler_runnables={}
    end
    local runnable=Runnable{
      run=function()
        func()
      end
    }
    table.insert(main_handler_runnables,runnable)
    if delay_time==0 then
      main_handler.post(runnable)
     else
      main_handler.postDelayed(runnable,delay_time)
    end
  end
end

function SkipPage(page,value,boolean)
  if boolean then
    activity.newLSActivity(page,value,boolean)
   else
    activity.newLSActivity(page,value)
  end
end

function output_search_key(key)
  if get_setting("case_sensitive") then
    return key
   else
    return utf8.lower(key)
  end
end

if config then
  -- read config.lua file
  common_data = config["general"]
  fonts_data = common_data["fonts"]
  icons_data = common_data["icons"]
  settings = common_data["settings"]
  editor_data = config["editor"]
  load_settings()
  if settings["back_tips"] then
    parameter = 0
    function onKeyDown(code, event)
      if string.find(tostring(event), "KEYCODE_BACK") ~= nil then
        if parameter + 2 > tonumber(os.time()) then
          activity.finish()
         else
          system_print(gets("back_tip"))
          parameter = tonumber(os.time())
        end
        return true
      end
    end
  end
end

RecyclerView = luajava.bindClass("com.luastudio.azure.widget.RecyclerView")

--[[

internal_storage = Environment.getExternalStorageDirectory().toString()
gridview_num_columns = 2
pidgv_numColumns=4
]]

--[[import "math"
if pad_mode then
  ViewsPaddingBottom=0
else
  ViewsPaddingBottom=dp2int(56)
end]]

function getSharedData(key)
  return activity.getSharedData(key)
end

function get_setting(setting_key)
  if settings[setting_key]~=nil then
    return settings[setting_key]
   else
    return true
  end
end

function get_editor_setting(setting_key)
  if editor_data[setting_key]~=nil then
    return editor_data[setting_key]
   else
    return true
  end
end