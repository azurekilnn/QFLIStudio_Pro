set_style()
import "system.system_dialogs"

import "main_1"
import "system.system_funlibs"
setCommonView("layout.layout_webdav_activity","project_info","back_with_more_mode")
activity.setContentView(loadlayout("layout.layout_webdav_activity"))

--设置标题
activity.setTitle("WebDav")

--目录按钮
--more_img.setImageBitmap(loadbitmap(load_icon_path("book")))
--setImage(more_img,load_icon_path("book"))
more_img.setVisibility(8)
--返回按钮
back_button.setVisibility(0)
menu_img.setVisibility(8)
webdav_project_list_data={}
project_list_item=import("layout.layout_items.layout_project_list_item")
webdav_project_list_adp=LuaAdapter(activity,webdav_project_list_data,project_list_item)
webdav_project_list_id.setAdapter(webdav_project_list_adp)

function setting_common(content,value,search_text)
  content.app_name_id.textColor=pc(text_color)
  if search_text then
    to_be_searched_text=content.app_name_id.text
    if value~="second" then
      to_be_sub_searched_text=content.app_packagename_id.text
     else
      to_be_sub_searched_text=""
    end
    if get_setting("case_sensitive") then
     else

      to_be_searched_text=utf8.lower(to_be_searched_text)
      search_text=utf8.lower(search_text)
    end
    --print(search_text)
    if to_be_searched_text:find(search_text) or to_be_sub_searched_text:find(search_text) then
      content.itemParent.backgroundColor=pc(search_results_background_color)
     else
      content.itemParent.backgroundColor=pc(background_color)
    end
   else
    content.itemParent.backgroundColor=pc(background_color)
  end
  content.item.background=Ripple(nil,0x22000000)
  if value=="second" then
    content.apk_packagename_id.textColor=pc(get_theme_color("paratext_color"))
    content.apk_version_id.textColor=pc(get_theme_color("paratext_color"))
   else
    content.app_packagename_id.textColor=pc(get_theme_color("paratext_color"))
  end
end

function search_item(content,value,search_text)
  if content.itemParent==nil then
    content.itemParent={}
  end
  if content.item==nil then
    content.item={}
  end
  setting_common(content,value,search_text)
end

function ripple_setting(data,adapter,value,search_text)
  for index,content in pairs(data) do
    if content.app_name_id then
      search_item(content,value,search_text)
    end
  end
  adapter.notifyDataSetChanged()
end

webdav_memory_filepath=activity.getLuaDir().."/memory_file/webdav_projects_list.table"
if get_webdav_list_first then
 else
  --pull_2.setRefreshing(true);
  task(500,function()
    reload_webdav_list()
  end)
end

webdav_project_list_id.onItemClick=function(p,v,i,s)
  local table_key=tonumber(v.Tag.project_path.text)
  local item_data=cloud_projects_table[table_key]
  local cproject_name=item_data["name"]
  local cproject_path=item_data["path"]
  local modify_time=item_data["modifyTime"]
  local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
  local file_length=item_data["length"]
  local download_file_path=luastudio_download_path.."/"..cproject_name
  import "android.text.format.Formatter"
  local file_size=(Formatter.formatFileSize(activity,file_length))
  if File(download_file_path).exists() then
    mimport_project(wdploutput_path(cproject_name,cproject_path))
   else
    wdplodownload(cproject_name,cproject_path,true)
  end
end

webdav_project_list_id.onItemLongClick=function(p,v,i,s)
  local table_key=tonumber(v.Tag.project_path.text)
  local item_data=cloud_projects_table[table_key]
  local cproject_name=item_data["name"]
  local cproject_path=item_data["path"]
  local modify_time=item_data["modifyTime"]
  local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
  local file_length=item_data["length"]
  local download_file_path=luastudio_download_path.."/"..cproject_name
  import "android.text.format.Formatter"
  local file_size=(Formatter.formatFileSize(activity,file_length))
  notdownloaded_webdav_project_list_operations={
    gets("download_text"),
    gets("download_and_import_text"),
    gets("delete_webdav_file_text")
  }
  downloaded_webdav_project_list_operations={
    gets("import_project_text"),
    gets("delete_webdav_file_text"),
    gets("delete_local_file_text")
  }
  if File(download_file_path).exists() then
    wdplod_items=downloaded_webdav_project_list_operations
   else
    wdplod_items=notdownloaded_webdav_project_list_operations
  end
  webdav_project_list_operations_dlg=AlertDialog.Builder(this)
  webdav_project_list_operations_dlg.setTitle(cproject_name)
  webdav_project_list_operations_dlg.setItems(wdplod_items,{onClick=function(lll,vvv)
      wdploperations[wdplod_items[vvv+1]](cproject_name,cproject_path)
    end})
  webdav_project_list_operations_dlg2=webdav_project_list_operations_dlg.show().hide()
  local background_color=pc(background_color)
  webdav_project_list_operations_dlg2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(background_color))
  webdav_project_list_operations_dlg2.show()
  --print(cproject_name,cproject_path,modify_time,file_size)
  return true
end

wdploperations={
  [gets("download_text")]=function(name,path)
    wdplodownload(name,path)
  end,
  [gets("download_and_import_text")]=function(name,path)
    wdplodownload(name,path,true)
  end,
  [gets("delete_webdav_file_text")]=function(name,path)
    wdplodelete(name,path)
  end,
  [gets("import_project_text")]=function(name,path)
    mimport_project(wdploutput_path(name,path))
  end,
  [gets("delete_local_file_text")]=function(name,path)
    deleting_proj_dialog2.show()
    task(200,function()
      local save_proj_file_path=tostring(luastudio_download_path).."/"..name
      local backup_proj_file_path=tostring(webdav_deleted_backup_path).."/"..name
      LuaUtil.copyDir(save_proj_file_path,backup_proj_file_path)
      LuaUtil.rmDir(File(save_proj_file_path))
      system_print(gets("delete_succeed_tips"))
      deleting_proj_dialog2.hide()
    end)
  end,
}
