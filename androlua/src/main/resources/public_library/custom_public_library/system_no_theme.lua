require "system.public_system_2"

--if auto_theme_value then
-- 跟随系统设置
ui_mode = get_ui_mode() -- true:夜间 false:日间
if ui_mode then
  load_theme_data("night_time")
 else
  load_theme_data("day_time")
end
--else
--[[手动设置
  theme_value = activity.getSharedData("system_theme") or "day_time" -- day_time or night_time
  if activity.getSharedData("system_theme") then
   else
    activity.setSharedData("system_theme", "day_time")
  end
  load_theme_data(theme_value)
end]]