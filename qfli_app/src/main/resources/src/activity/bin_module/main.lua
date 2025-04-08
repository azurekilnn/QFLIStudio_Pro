import "com.michael.NoScrollListView"
set_style()
setCommonView("layout","bin_project","back_mode")
import "build"

drawer_item_checked_background = GradientDrawable().setShape(GradientDrawable.RECTANGLE).setColor(parseColor(basic_color)-0xde000000).setCornerRadii({dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5)});

drawer_item=import "layout_bin_item"
adp=LuaMultiAdapter(activity,drawer_item)
main_lv.setAdapter(adp)

ch_table={
  --{gets("home"),"home"},
  {gets("bin_project"),"build"},
  {gets("install_application"),"adb"},
  --{gets("settings"),"settings"},
  --{gets("exit"),"exit"},
};
drawer_item_light(adp,ch_table,"build")

main_lv.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    local s=v.Tag.tv.Text
    if s==gets("install_application") then
      if build_apk_path and File(build_apk_path).exists() then
        activity.installApk(build_apk_path)
      else
        system_print(gets("cannot_install_application_tips"))
      end
    elseif s==gets("bin_project") then
      startBuild(proj_path,false)
    end
  end
})

local function update(content,code)
  if build_apk_status then
    build_apk_status='=>'..content.."\n"..build_apk_status
  else
    build_apk_status=content
  end
  --[[if content:find("出错") then
    build_apk_status_code=3
   else
    build_apk_status_code=1
  end]]
  build_apk_log.setText(build_apk_status)
end

local function callback(errorBuffer)
  if errorBuffer and type(errorBuffer)~="boolean" then
    build.updateContent(gets("build_failed_tips").."\n " ..errorBuffer.toString().."\n ")
  end
end

import "system.system_bin"

function startBuild(proj_path,autoOpenStatus)
  if buildTasks then
    buildTasks.cancel(true)
    buildTasks=nil
  end
  local status,str=pcall(dofile,proj_path.."/build.lsinfo")
  if status and build_info then

    local app_name=build_info["appname"]
    local app_ver=build_info["appver"]
    local app_code=build_info["appcode"]
    build_info["apkName"]=app_name.. "_" .. app_ver .. "_" .. app_code .. ".apk"
    build_apk_path=proj_path.."/build/apk/"..build_info["apkName"]

    build_info["autoOpenStatus"]=autoOpenStatus
    build_info["projectPath"]=proj_path
    build_info["signLibrary"]=switch_id4.isChecked()
    buildTasks=activity.newTask(build_pro, update,callback)
    task(50,function()
      buildTasks.execute({build_info})
    end)
  end
end

proj_path=...
if proj_path and File(proj_path).exists() then
  proj_path_tv.setText(proj_path)
  startBuild(proj_path)
end

home_root.onClick=function()
  if build_apk_path and File(build_apk_path).exists() then
    activity.installApk(build_apk_path)
  else
    system_print(gets("cannot_install_application_tips"))
  end
end

function onDestory()
  if buildTasks then
    buildTasks.cancel(true)
  end
  --executor.showdown()
end
function onStop()
  if buildTasks then
    buildTasks.cancel(true)
  end
  --executor.showdown()
end

function onPause()
  if buildTasks then
    buildTasks.cancel(true)
  end
end