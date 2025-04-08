local function init_project_operations_rv_adp(tag_data)
  local next_project_path=tag_data["project_path"]
  local next_project_template=tag_data["project_type"]
  local project_info_dialog_gridview_item2=import "layout.layout_items.project_info_dialog_gridview_item2"
  local operation_adapter=LuaRecyclerViewAdapter(activity,project_info_dialog_gridview_item2)
  local function pidga_add(click,icon,title)
    operation_adapter.add({item_img={src=load_icon_path(icon)},item_text=title,item_incident={text=click},item={onClick=function()
          if system_incident[click] then
            system_incident[click](next_project_path,next_project_template,tag_data["position"])
           else
            system_print(gets("not_developed_yet"))
          end
        end}})
  end
  return operation_adapter
end

function init_main_webdav_projects_list()
  wpls=true
  item_onclick=function(views)
    local tag_data=views["tag_data"]
    local next_project_path=tag_data["project_path"]
    local cproject_name=tag_data["project_name"]
    local cproject_path=tag_data["project_path"]
    local modify_time=tag_data["modifyTime"]
    local modify_time=os.date("%Y-%m-%d %H:%M:%S",modify_time)
    local file_length=tag_data["length"]
    local download_file_path=luastudio_download_path.."/"..cproject_name
    import "android.text.format.Formatter"
    -- local file_size=(Formatter.formatFileSize(activity,file_length))
    if File(download_file_path).exists() then
      mimport_project(download_file_path)
     else
      print(cproject_name,cproject_path)
      wdplodownload(cproject_name,cproject_path,true)
    end
    return true
  end

  item_onlongclick=function(views)
  end
  webdav_projects_data,webdav_projects_rv_adapter=init_projects_adapter(nil,item_onclick,item_onlongclick)

  webdav_projects_rv.setAdapter(webdav_projects_rv_adapter)
  local projects_recyclerview_layout_manager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
  webdav_projects_rv.setLayoutManager(projects_recyclerview_layout_manager)
end