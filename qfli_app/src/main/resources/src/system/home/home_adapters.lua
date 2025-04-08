--初始化工程列表适配器
function init_projects_adapter(item_layout,item_onclick,item_onlongclick)
  local item_layout=(item_layout or (use_new_longclick_menu and import("layout.layout_items.layout_project_list_item")) or (import("layout.layout_items.layout_project_list_item2")))
  local projects_data={}
  local projects_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #projects_data
    end,
    getItemViewType=function(position)
      return 0
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local view=loadlayout(item_layout,views)
      local holder=LuaRecyclerHolder(view)
      view.setTag(views)

      views.item.setBackground(Ripple(nil,0x22000000))
      views.app_name_id.setBackground(Ripple(nil,0x22000000,"方"))
      views.app_packagename_id.setBackground(Ripple(nil,0x22000000,"方"))

      views.item.onClick=function()
        item_onclick(views)
        return true
      end
      views.item.onLongClick=function()
        item_onlongclick(views)
        return true
      end
      return holder
    end,

    onBindViewHolder=function(holder,position)
      local data=projects_data[position+1]
      local tag=holder.view.getTag()
      tag["tag_data"]=data
      tag["position"]=position+1
      local project_icon=data["project_icon"]
      local project_name=data["project_name"]
      local project_packagename=data["project_packagename"]

      if local_search_key then
        local to_be_searched_text=project_name
        local to_be_sub_searched_text=project_packagename
        if not get_setting("case_sensitive") then
          to_be_searched_text=utf8.lower(to_be_searched_text)
          to_be_sub_searched_text=utf8.lower(to_be_sub_searched_text)
          local_search_key=utf8.lower(local_search_key)
        end
        if local_search_key=="" then
          tag.itemParent.setCardBackgroundColor(pc(get_theme_color("background_color")))
         else
          if to_be_searched_text:find(local_search_key) or to_be_sub_searched_text:find(local_search_key) then
            tag.itemParent.setCardBackgroundColor(pc(search_results_background_color))
           else
            tag.itemParent.setCardBackgroundColor(pc(get_theme_color("background_color")))
          end
        end
      end
      tag.app_name_id.setText(project_name)
      tag.app_packagename_id.setText(project_packagename)
      setImage(tag.app_icon_id,project_icon)

      if use_new_longclick_menu then
        tag.project_operation_list.setVisibility(8)
        if pad_mode then
          local projects_recyclerview_layout_manager2=StaggeredGridLayoutManager(8,StaggeredGridLayoutManager.VERTICAL)
          tag.project_info_dialog_rv.setLayoutManager(projects_recyclerview_layout_manager2)
         else
          local projects_recyclerview_layout_manager2=StaggeredGridLayoutManager(4,StaggeredGridLayoutManager.VERTICAL)
          tag.project_info_dialog_rv.setLayoutManager(projects_recyclerview_layout_manager2)
        end
      end
    end,
  }))
  return projects_data,projects_rv_adapter
end