import {
  "layout.layout_library.layout_progressbar",
  "layout.layout_library.layout_empty_tips",
  "layout.layout_library.layout_funlib",
}
main_handler=Handler()
main_surface_handler=Handler()

import "system.main_settings"
import "system.emlog_funlib"
import "system.home.home_funlib"
import "system.system_dialogs"

load_main_incidents()

login_dialog2=create_login_dlg()
set_dialog_style(login_dialog2)
load_settings()
if get_setting("auto_into_editor") then
  read_and_into_editor()
end

activity.setContentView(loadlayout("layout.layout_main"))
setImage(home_header_img,(activity.getSharedData("my_account_header") or activity.getLuaDir().."/system/defalut_header.png"))

main_viewpager_1=import "layout.layout_pages.layout_main_viewpager_1"
main_viewpager_background_1.addView(loadlayout(main_viewpager_1))
home_local_projects_list_background.addView(loadlayout("layout.layout_pages.layout_home_viewpage_1.layout_main_local_projects_list"))
empty_tips.setVisibility(8)

import "system_incident"
import "system.system_config"
import "system.home.main_local_projects_list"

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
load_all_paths()
home_tab_layout.setupWithViewPager(home_pageview);

init_main_local_projects_list()

view_radius(projects_list_search_bar_edit,dp2px(8),pc(gray_color))

projects_list_search_bar_edit.setOnEditorActionListener(TextView.OnEditorActionListener{
  onEditorAction=function(view,actionId,event)
    local_search_key=view.text
    if current_projects_adapter then
      current_projects_adapter.notifyDataSetChanged()
    end
    return false
  end
})

query_helper_roster_list_first=false
get_webdav_list_first=false
member_center_load_first=false
first_load_plugins=false

import "system.home.home_surface"
load_bottombar()



function MainThread_2()
  load_config()
  load_surface()
  load_listeners()
  load_swiperefreshlayout()
  load_incidents()
end

main_handler.postDelayed(Runnable{
  run=function()
load_local_projects_list()
    MainThread_2()
  end
},50)
main_surface_handler.postDelayed(Runnable{
  run=function()
    load_other_pages()
  end
},500)

function onPause()
  if (!load_status) then
    clear_all_runnables()
  end
end

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

function onResult(name,...)
  --活动返回
  callback=...
  if callback=="settings_update" then
    webdav_serve=activity.getSharedData("webdav_serve") or nil
    webdav_user=activity.getSharedData("webdav_user") or nil
    webdav_pass=activity.getSharedData("webdav_pass") or nil
    load_webdav_config()
  end
  if callback=="article_update" then
    load_article_list(true)
  end
  if callback=="editor_back" then
    local opened_project_file_path = activity.getLuaDir() .. "/memory_file/opened_project.table"--工程信息，历史打开文件，历史打开文件夹
    pcall(dofile,opened_project_file_path)
    if opened_project_info then
      opened_project_info["auto_open"]=false
      io.open(opened_project_file_path,"w"):write("opened_project_info="..dump(opened_project_info)):close()
    end
  end
end