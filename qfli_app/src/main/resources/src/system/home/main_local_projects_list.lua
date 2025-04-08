import "system.home.home_adapters"
--初始化工程操作适配器
function init_project_operations_adapter(item_layout,tag_data)
  local item_layout=(item_layout or import("layout.layout_items.project_info_dialog_gridview_item2"))
  local next_project_path=tag_data["project_path"]
  local next_project_template=tag_data["project_type"]
  local operation_adapter=LuaRecyclerViewAdapter(activity,item_layout)
  local function pidga_add(click,icon,title)
    operation_adapter.add({item_img={src=load_icon_path(icon)},item_text=title,item_incident={text=click},item={onClick=function()
          if system_incident[click] then
            system_incident[click](next_project_path,next_project_template,tag_data["position"])
           else
            system_print(gets("not_developed_yet"))
          end
        end}})
  end

  pidga_add("open_newwindow","photo_library",gets("open_by_window"))
  pidga_add("bin_project","adb",gets("bin_project"))
  pidga_add("clone_project","file_copy",gets("clone_project"))
  pidga_add("project_info_editor","settings",gets("project_info_editor"))
  pidga_add("fix_project","build",gets("fix_project"))
  pidga_add("save_project","save",gets("save_project"))
  pidga_add("share_project","open_in_new",gets("share_project"))
  pidga_add("delete_project","delete",gets("delete"))
  return operation_adapter
end


function init_main_local_projects_list()
  local item_onclick=function(views)
    local tag_data=views["tag_data"]
    local next_project_path=tag_data["project_path"]
    skip_editor(next_project_path)
    return true
  end
  local item_onlongclick=function(views)
    local tag_data=views["tag_data"]
    local next_project_path=tag_data["project_path"]

    if use_new_longclick_menu then
      if views.project_info_dialog_gridview_adp then
       else
        views.project_info_dialog_gridview_adp=init_project_operations_adapter(nil,tag_data)
        views.project_info_dialog_rv.setAdapter(ids.project_info_dialog_gridview_adp)
      end
      if views.project_operation_list.getVisibility()==8 then
        views.project_operation_list.setVisibility(0)
       else
        views.project_operation_list.setVisibility(8)
      end
     else
      open_project_operations_dlg(next_project_path,views["position"])
    end
  end
  projects_data,projects_rv_adapter=init_projects_adapter(nil,item_onclick,item_onlongclick)
  projects_recyclerview.setAdapter(projects_rv_adapter)
  local projects_recyclerview_layout_manager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
  projects_recyclerview.setLayoutManager(projects_recyclerview_layout_manager)
  current_projects_adapter=projects_rv_adapter
  --init_rv_anim(projects_recyclerview)
  --activity.initRecyclerViewAnim(projects_recyclerview)
end



function init_main_error_projects_list()
  local item_onclick=function(views)
    local tag_data=views["tag_data"]
    local proj_path=tag_data["project_path"]

local fix_error_project_dlg,fix_error_project_dlg_2=create_fix_error_project_dlg(function()
  global_loading_dlg.show()
  task(50,function()
      local status=repair_ver3_project(proj_path)
 if status then
      pcall(reload_project_list)
      local delete_tips_dialog,delete_tips_dialog_2=create_delete_old_proj_dlg(function()
        if progress_dlg then
          progress_dlg.setMessage(gets("deleting_proj_message_tips"))
         else
          progress_dlg,progress_dlg2=create_progress_dlg()
          progress_dlg.setMessage(gets("deleting_proj_message_tips"))
        end
        progress_dlg2.show()
        task(50,function()
          delete_project(proj_path,true,function(status)
            if status then
              system_print(gets("delete_succeed_tips"))
             else
              system_print(gets("delete_failed_tips"))
            end
            progress_dlg2.dismiss()
          end)
        end)
      end)
      delete_tips_dialog_2.show()
 end
  global_loading_dlg.dismiss()
    end)
end)
    return true
  end
  local item_onlongclick=function(views)
    local tag_data=views["tag_data"]
    local next_project_path=tag_data["project_path"]

  end
  error_projects_data,error_projects_rv_adapter=init_projects_adapter(nil,item_onclick,item_onlongclick)
  error_projects_recyclerview.setAdapter(error_projects_rv_adapter)
  local projects_recyclerview_layout_manager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
  error_projects_recyclerview.setLayoutManager(projects_recyclerview_layout_manager)
end