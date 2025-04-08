require "system.public_system_2"

function set_theme(value)
  activity.setTheme(themes[value] or R.style.Theme_LuaStudio)
  --白色状态栏高亮
  if ((value=="day_time") and (sdk_version>=23) and (status_bar_color) and (tostring(pc(status_bar_color))=="-1")) then
    activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
  end
  --隐藏标题栏
  --pcall(function()activity.getActionBar().hide()end)
  --pcall(function()activity.getSupportActionBar().hide()end)
  if not ((value=="day_time") or (value=="night_time")) then
    get_theme_colors()
  end
  --set_status_bar_color(status_bar_color)
  --set_navigation_bar_color(navigation_bar_color)
end
-- 主题是否根据系统设置
--[[auto_theme_value = activity.getSharedData("auto_theme_value") or false -- true or false
if auto_theme_value then]]
-- 跟随系统设置
ui_mode = get_ui_mode() -- true:夜间 false:日间
if ui_mode then
  load_theme_data("night_time")
  set_theme("night_time")
 else
  load_theme_data("day_time")
  set_theme("day_time")
end
--[[else
  -- 手动设置
  theme_value = activity.getSharedData("system_theme") or "day_time" -- day_time or night_time
  if activity.getSharedData("system_theme") then
   else
    activity.setSharedData("system_theme", "day_time")
  end
  load_theme_data(theme_value)
  load_theme(theme_value)
end
]]