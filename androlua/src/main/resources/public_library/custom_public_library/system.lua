require "system.public_system_2"

--if get_setting("follow_system_theme") then
--跟随系统设置
ui_mode=get_ui_mode() --true:夜间 false:日间
if ui_mode then
  theme_value="night_time"
 else
  theme_value="day_time"
end
--else
--[[手动设置
  theme_value = activity.getSharedData("system_theme") or "day_time" -- day_time or night_time
  if activity.getSharedData("system_theme") then
   else
    activity.setSharedData("system_theme", "day_time")
  end
end
]]

load_theme_data(theme_value)
--set_theme(theme_value)

function set_style()
  set_theme(theme_value)
end

import "system.system_dialogs"
global_loading_dlg,global_loading_dlg_2=create_progress_dlg()