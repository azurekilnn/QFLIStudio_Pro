activities_rv_item=import "layout.layout_items.layout_common_rv_item"
activities_data={}
activities_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #activities_data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local ids={}
    local view=loadlayout(activities_rv_item,ids)
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
      local tool_need_value=ids["_data"]["tool_value"]
      local tool_use_activity=ids["_data"]["use_activity"]
      local must_need_value=ids["_data"]["must_need_value"]
      local tool_need_data=ids["_data"]["tool_need_data"]
      local message="功能/插件介绍："..tool_introduction.."\n当前版本: "..version.."\n当前版本号: "..code.."\n当前版本更新内容: "..tool_update_log
      if tool_need_value then
        system_print("该组件需要传入参数才能正常使用",false)
      end
      --普通对话框
      activities_info_dialog=MaterialAlertDialogBuilder(activity,R.style.AlertDialogTheme)
      activities_info_dialog.setTitle(title)
      activities_info_dialog.setMessage(message)
      activities_info_dialog.setCancelable(false);
      activities_info_dialog.setPositiveButton("跳转",{onClick=function()

          function check_need_value(tool_need_values,values,callback)
            for index,content in ipairs(tool_need_values) do
              if values[index] then
               else
                if content=="lua_path" then
                  choose_file(activity.getLuaExtDir(),function(path,name)
                    if path then
                      table.insert(values,index,path)
                      check_need_value(tool_need_values,values,callback)
                    end
                  end,"lua")
                  return true
                elseif content=="dex_path" then
                  choose_file(activity.getLuaExtDir(),function(path,name)
                    if path then
                      table.insert(values,index,path)
                      check_need_value(tool_need_values,values,callback)
                    end
                  end,"dex")
                 elseif content=="lua_dir" then
                  table.insert(values,index,activity.getLuaExtDir())
                end
              end
              if index==#tool_need_values then
                callback(values)
              end
            end
          end
          if (tool_need_value and type(tool_need_value)=="table" and #tool_need_value~=0) then
            local check_values={}
            check_need_value(tool_need_value,check_values,function(values)
              if ((values and #values~=0) and #values==#tool_need_value) then
                skipLSActivity(ids["_data"]["tool_name_key"],values,tool_use_activity)
               elseif (must_need_value==false) then
                skipLSActivity(ids["_data"]["tool_name_key"],nil,tool_use_activity)
              end
            end)
           else
            skipLSActivity(ids["_data"]["tool_name_key"],nil,tool_use_activity)
          end
        end})
      activities_info_dialog.setNegativeButton(gets("cancel_button"),function()
      end)
      local support_open_by_dialog=ids["_data"]["support_open_by_dialog"]
      if support_open_by_dialog then
        activities_info_dialog.setNeutralButton("弹窗打开",function()
          local name=ids["_data"]["tool_name_key"]
          if plugin_dlgs and plugin_dlgs[name] then
            local plugin_dialog=plugin_dlgs[name]
            plugin_dialog.show()
            function SkipPage(page,value)
              local page_file=tool_dir.."/"..page
              if File(page_file..".lua").exists() then
                pcall(dofile,page_file..".lua")
               elseif File(page_file).exists() then
                pcall(dofile,page_file)
              end
              plugin_dlg=create_plugin_dlg(plugin_title,content_view,page,dialog_type,false)
              if load_shared_codes then
                pcall(load_shared_codes,value)
              end

              plugin_dlg.show()
              --activity.newLSActivity(page,value)
            end
           else
            local plugin_dialog=load_plugin_dlg(name)
            if plugin_dialog then
              plugin_dialog.show()
            end
          end
        end)
      end
      activities_info_dialog2=activities_info_dialog.show()
      set_dialog_style(activities_info_dialog2)
    end
    return holder
  end,

  onBindViewHolder=function(holder,position)
    local data=all_activities_info[activities_data[position+1]]
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
    message.setVisibility(View.GONE)
  end,
}))
activities_recyclerview.setAdapter(activities_rv_adapter)
layoutManager=StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL)
activities_recyclerview.setLayoutManager(layoutManager)