local lua_dir=activity.getLuaDir()
local main_path=lua_dir.."/main_activity.lua"
local editor_main_path=lua_dir.."/editor_activity.lua"

--百度用户统计
--import "com.baidu.mobstat.StatService"
--StatService.setAppKey("70d859671a").start(this)

--加载主页
if get_setting("home_page_mode") then
  loadfile(main_path)()
 else
  loadfile(editor_main_path)()
end