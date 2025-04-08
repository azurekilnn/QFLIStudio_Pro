layout_mode_item=import "layout.layout_items.layout_mode_item"

plugins_data={}
plugins_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #plugins_data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local ids={}
    local view=loadlayout(layout_mode_item,ids)
    local holder=LuaRecyclerHolder(view)
    view.setTag(ids)
    ids.cardViewChild.setBackground(Ripple(nil,0x22000000))
    ids.cardViewChild.onClick=function()
      local title=gets(ids["_data"]["tool_name_key"])
      local version=ids["_data"]["tool_version"]
      local code=ids["_data"]["tool_code"]
      local tool_update_log=ids["_data"]["tool_update_log"]
      local tool_introduction=ids["_data"]["tool_introduction"]
      local tool_home_path=ids["_data"]["tool_home_path"]
      local message="功能/插件介绍："..tool_introduction.."\n当前版本: "..version.."\n当前版本号: "..code.."\n当前版本更新内容: "..tool_update_log
      --普通对话框
      plugin_info_dialog=MaterialAlertDialogBuilder(activity,R.style.AlertDialogTheme)
      plugin_info_dialog.setTitle(title)
      plugin_info_dialog.setMessage(message)
      plugin_info_dialog.setCancelable(false);
      plugin_info_dialog.setPositiveButton("跳转",{onClick=function()
          skipLSActivity(ids["_data"]["tool_name_key"])
        end})
      plugin_info_dialog.setNegativeButton(gets("cancel_button"),function()
      end)

      plugin_info_dialog.show()
    end
    return holder
  end,

  onBindViewHolder=function(holder,position)
    local data=all_activities_info[plugins_data[position+1]]
    local tag=holder.view.getTag()
    tag._data=data
    local name=gets(data["tool_name_key"])
    local tool_introduction=data["tool_introduction"]
    local version=data["tool_update_time"].."\t\t"..data["tool_version"].."\t\t"..data["tool_code"]
    tag.title.text=name

    local sub_title=tag.sub_title
    local message=tag.message
    if tool_introduction then
      sub_title.text=tool_introduction
      sub_title.setVisibility(View.VISIBLE)
     else
      sub_title.setVisibility(View.GONE)
    end
    if version then
      message.text=version
      message.setVisibility(View.VISIBLE)
     else
      message.setVisibility(View.GONE)
    end
  end,
}))
plugins_recyclerview.setAdapter(plugins_rv_adapter)
layoutManager=StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL)
plugins_recyclerview.setLayoutManager(layoutManager)
