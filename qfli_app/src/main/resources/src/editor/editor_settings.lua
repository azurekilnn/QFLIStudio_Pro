local AdapterCreator=luajava.bindClass("com.luastudio.azure.adapter.AdapterCreator")
local LuaRecyclerAdapter=luajava.bindClass("com.luastudio.azure.adapter.LuaRecyclerAdapter")
local LuaRecyclerHolder=luajava.bindClass("com.luastudio.azure.adapter.LuaRecyclerHolder")
local file_list_item=import("layout.layout_items.layout_editor_file_list_item")
local ch_item=import("layout.layout_items.layout_editor_right_sidebar_item")

--左侧滑RecyclerView适配器
function init_files_adpater()
  local adapter_data={}
  local checkbox_status=false
  local adapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount = function()
      return #adapter_data
    end,
    getItemViewType = function(position) return 0 end,
    onCreateViewHolder = function(parent,viewType)
      local views={}
      local holder_view=loadlayout(file_list_item,views)
      local holder=LuaRecyclerHolder(holder_view)
      holder_view.setTag(views)

      views.root_file_item.onClick=function()
        local data=views["tag_data"]
        local file_list_mode=data["filelist"]
        local proj_list_mode=data["projectlist"]

        if file_list_mode then
          local select_status=data["select_status"]
          local file_object=data["file"]
          local file_is_directory=file_object.isDirectory()
          local file_is_file=file_object.isFile()
          if file_list_checkbox_status then
            if (views.filelist_checkbox.isChecked()) then
              views.filelist_checkbox.setChecked(false)
              data["select_status"]=false
             else
              views.filelist_checkbox.setChecked(true)
              data["select_status"]=true
            end
            --[[for index,content in ipairs(files_adapter_data) do
            local select_status=(content["select_status"])
            local file=content["file"]
            local file_name=file["name"]
            print(file_name,select_status)
          end]]
           else
            if file_is_file then
              if file_object["name"]=="build.lsinfo" then
               else
                open_file_by_editor(file_object,current_editor_name)
              end
             else
              load_files_list(file_object["path"],false)
            end
          end
         elseif proj_list_mode then
          local project_info=data["info"]
          local project_path=project_info["project_path"]
          local open_project_dlg=AlertDialog.Builder(this)
          open_project_dlg.setTitle("提示")
          open_project_dlg.setMessage("是否打开该工程？")
          open_project_dlg.setPositiveButton("确定",{onClick=function(v)
              save_all_files()
              set_project(project_path,true)
            end})
          open_project_dlg.setNegativeButton("取消",nil)
          open_project_dlg.setNeutralButton("打开工程目录",{onClick=function(v)

              --print(project_path)
              load_files_list(project_path)
            end})
          open_project_dlg_2=open_project_dlg.show()
          set_dialog_style(open_project_dlg_2)


        end
      end

      views.root_file_item.onLongClick=function()
        local data=views["tag_data"]
        local file_list_mode=data["filelist"]
        local proj_list_mode=data["projectlist"]

        if file_list_mode then
          local file_object=data["file"]
          local file_is_directory=file_object.isDirectory()
          local file_is_file=file_object.isFile()
          local tag_file_name=file_object["name"]
          if tag_file_name=="build.lsinfo" then
           else
            if file_list_checkbox_status then
              file_operations(data,file_list_checkbox_status)
             else
              file_operations(data)
            end
          end

         elseif proj_list_mode then

        end
      end
      return holder
    end,
    onBindViewHolder = function(holder,position)
      local data=adapter_data[position+1]
      local views=holder.view.getTag()
      views["tag_data"]=data
      views["tag_data"]["position"]=position+1
      local file_list_mode=data["filelist"]
      local proj_list_mode=data["projectlist"]
      local select_status=data["select_status"]
      if file_list_mode then
        local file_object=data["file"]
        local file_name=file_object["name"]
        local file_path=file_object["path"]
        local file_is_file=file_object.isFile()


        views.file_name.setText(file_name)
        views.file_img.setColorFilter(basic_color_num)

        main_handler_run(function()
          local file_size=(data["file_size"] or get_file_size(file_path))
          local file_sub_title=((file_object.isDirectory() and gets("folder")) or file_size)
          views.file_size.setText(file_sub_title)

          local status,file_icon=check_filelist_icon(filelist_icons,file_object)
          if status then
            setImage(views.file_img,file_icon)
           else
            if file_name:find("%.png$") or file_name:find("%.gif$") or file_name:find("%.jpg$") then
              setImage(views.file_img,file_path)
              views.file_img.setColorFilter(0x00000000)
             else
              setImage(views.file_img,lother_file_img)
            end
          end
        end,50)



       elseif proj_list_mode then
        local project_info=data["info"]
        local project_name=project_info["project_name"]
        local project_icon=project_info["project_icon"] or (activity.getLuaDir() .. "/icon.png")
        local project_packagename=project_info["project_packagename"]
        views.file_name.setText(project_name)
        views.file_size.setText(project_packagename)
        setImage(views.file_img,project_icon)
        views.file_img.setColorFilter(0x00000000)
      end



      if file_list_checkbox_status then
        views.filelist_checkbox_dc.setVisibility(View.VISIBLE)
        if select_status then
          views.filelist_checkbox.setChecked(select_status)
         else
          views.filelist_checkbox.setChecked(false)
        end
        setImage(ch_add_file_img,load_icon_path("delete"))
       else
        views.filelist_checkbox_dc.setVisibility(View.GONE)
        --views.filelist_checkbox.setChecked(false)
        --data["select_status"]=false
        setImage(ch_add_file_img,load_icon_path("add"))
      end
      system_ripple({views.root_file_item},"square_adaptive")
    end,
  }))

  return adapter,adapter_data
end



--右侧滑RecyclerView适配器
function init_drawer_adpater()
  local adapter_data={}
  local adapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount = function()
      return #adapter_data
    end,
    getItemViewType = function(position) return 0 end,
    onCreateViewHolder = function(parent,viewType)
      local views={}
      local holder_view=loadlayout(ch_item,views)
      local holder=LuaRecyclerHolder(holder_view)
      holder_view.setTag(views)

      views.item.onClick=function()
        local data=views["tag_data"]
        local mode_name=data["name"]
        run_incident(mode_name)
      end
      return holder
    end,
    onBindViewHolder = function(holder,position)
      local data=adapter_data[position+1]
      local views=holder.view.getTag()
      views["tag_data"]=data
      views["tag_data"]["position"]=position+1

      local mode_name=data["name"]
      local mode_pic=data["pic"]

      views.item.background=Ripple(nil,0x22000000)
      views.ittv.setText(gets(mode_name))
      setImage(views.itiv,mode_pic)
    end,
  }))
  return adapter,adapter_data
end

--初始化右侧滑功能RecyclerView
function init_drawer_rv(rv_id,data)
  local adapter,adapter_data=init_drawer_adpater()
  local layout_manager=GridLayoutManager(activity,4)
  rv_id.setLayoutManager(layout_manager)
  rv_id.setAdapter(adapter)
  for index,content in ipairs(data) do
    table.insert(adapter_data,content)
  end
  adapter.notifyDataSetChanged()
  return adapter,adapter_data
end

--加载右侧滑所有RecyclerView
function load_all_drawer_rvs()
  --代码操作
  local drawer_data_1={
    {name="code_format",pic=editor_icons("format")},--格式化
    {name="code_check",pic=load_icon_path("check")},--检查
    {name="import_analysis",pic=load_icon_path("insert_chart")},--导入分析
    {name="code_navigation",pic=load_icon_path("explore")},--代码导航
    {name="search_code",pic=load_icon_path("search")},--搜索
    {name="global_search_code",pic=load_icon_path("search")},--搜索
    {name="global_search_code_results",pic=load_icon_path("list_alt")},--搜索 showfilelist_dlg
    {name="jump_line",pic=load_icon_path("import_export")},--跳转行
  }
  --工程操作
  local drawer_data_2={
    {name="bin_project",pic=load_icon_path("adb")},--打包工程
    --{name="project_list",pic=load_icon_path("list_alt")},--工程列表
    {name="project_import",pic=load_icon_path("unarchive")},--工程导入
    {name="project_recovery",pic=load_icon_path("web")},--工程恢复
    {name="project_info",pic=load_icon_path("build")},--工程信息
    {name="import_resources",pic=load_icon_path("download")},--导入资源
    {name="create_project",pic=load_icon_path("add")},--新建工程
    --{name="webdav_list",pic=load_icon_path("list_alt")},--新建工程
    --{name="close_project",pic=load_icon_path("power")},--关闭工程
  }
  --文件处理
  local drawer_data_3={
    {name="compile_lua_file",pic=load_icon_path("insert_drive_file")},--编译文件
  }
  --工具
  local drawer_data_4={
    {name="icon_depository",pic=load_icon_path("photo_library")},--图标仓库
    {name="lua_course",pic=load_icon_path("book")},--lua教程
    {name="lua_explain",pic=load_icon_path("book")},--lua说明
    {name="argb_tool",pic=load_icon_path("color_lens")},--颜色选择器
    {name="java_api",pic=load_icon_path("book")},--javaapi
    {name="color_reference",pic=load_icon_path("format_color_fill")},--配色参考
    {name="layout_helper",pic=load_icon_path("photo")},--布局助手
    {name="logcat",pic=load_icon_path("assignment")},--Logcat
  }
  --其他
  local drawer_data_5={
    {name="help_roster",pic=load_icon_path("list_alt")},--支持名单
  }
  drawer_rv_adapter_1,drawer_rv_adapter_data_1=init_drawer_rv(drawer_rv_1,drawer_data_1)
  drawer_rv_adapter_2,drawer_rv_adapter_data_2=init_drawer_rv(drawer_rv_2,drawer_data_2)
  drawer_rv_adapter_3,drawer_rv_adapter_data_3=init_drawer_rv(drawer_rv_3,drawer_data_3)
  drawer_rv_adapter_4,drawer_rv_adapter_data_4=init_drawer_rv(drawer_rv_4,drawer_data_4)
  drawer_rv_adapter_5,drawer_rv_adapter_data_5=init_drawer_rv(drawer_rv_5,drawer_data_5)
end

--更多菜单
function load_more_menu()
  more_menu_tables={
    {
      SubMenu,
      title=gets("code_operation"),
      {MenuItem,title=gets("code_format"),id="code_format"},
      {MenuItem,title=gets("code_check"),id="code_check"},
      {MenuItem,title=gets("import_analysis"),id="import_analysis"},
      {MenuItem,title=gets("code_navigation"),id="code_navigation"},
      {MenuItem,title=gets("search_code"),id="search_code"},
      {MenuItem,title=gets("global_search_code"),id="global_search_code"},
      {MenuItem,title=gets("global_search_code_results"),id="global_search_code_results"},
      {MenuItem,title=gets("jump_line"),id="jump_line"},
    },
    {
      SubMenu,
      title=gets("project_operation"),
      {MenuItem,title=gets("bin_project"),id="bin_project"},
      {MenuItem,title=gets("project_import"),id="project_import"},
      {MenuItem,title=gets("project_recovery"),id="project_recovery"},
      {MenuItem,title=gets("project_info"),id="project_info"},
      {MenuItem,title=gets("import_resources"),id="import_resources"},
      {MenuItem,title=gets("create_project"),id="create_project"},
      --{MenuItem,title=gets("webdav_list"),id="webdav_list"},
      --{MenuItem,title=gets("close_project"),id="close_project"},
    },
    {
      SubMenu,
      title=gets("file_operation"),
      {MenuItem,title=gets("compile_lua_file"),id="compile_lua_file"},
    },
    {
      SubMenu,
      title=gets("tools_text"),
      {MenuItem,title=gets("icon_depository"),id="icon_depository"},
      {MenuItem,title=gets("lua_course"),id="lua_course"},
      {MenuItem,title=gets("lua_explain"),id="lua_explain"},
      {MenuItem,title=gets("argb_tool"),id="argb_tool"},
      {MenuItem,title=gets("java_api"),id="java_api"},
      {MenuItem,title=gets("color_reference"),id="color_reference"},
      {MenuItem,title=gets("layout_helper"),id="layout_helper"},
      {MenuItem,title=gets("logcat"),id="logcat"},
    },
    {MenuItem,title=gets("contact_dev"),id="contact_dev"},--联系开发者
    {MenuItem,title=gets("join_qqgroup"),id="join_group"},--加入qq群
    {MenuItem,title=gets("settings"),id="settings_btn"},--设置
    {MenuItem,title=gets("about"),id="application_about"},--关于
    {MenuItem,title=gets("exit"),id="exit_application"},--退出
  }

  optmenu={}
  drawer_popupMenu=PopupMenu(activity,more_lay)
  drawer_popup_menu=drawer_popupMenu.Menu
  loadmenu(drawer_popup_menu,more_menu_tables,optmenu)
  for index,content in pairs(optmenu) do
    optmenu[tostring(index)].onMenuItemClick=function(a)
      run_incident(tostring(index))
      end
  end
  optmenu["contact_dev"].onMenuItemClick=function(a)
    system_incident["contact_dev"]()
  end
  optmenu["join_group"].onMenuItemClick=function(a)
    system_incident["join_group"]()
  end
  optmenu["settings_btn"].onMenuItemClick=function(a)
    system_incident["settings_btn"]()
  end
  optmenu["exit_application"].onMenuItemClick=function(a)
    system_incident["exit_application"]()
  end
  optmenu["application_about"].onMenuItemClick=function(a)
    system_incident["application_about"]()
  end
end

--加载右侧滑栏
function load_right_sidebar()
  if get_editor_setting("brief_right_sidebar") then
    load_more_menu()
    more_button.onClick=function()
      drawer_popupMenu.show()
    end
   else
    load_all_drawer_rvs()
    more_button.onClick=function()
      drawer_layout.openDrawer(5)
    end
    dl_btm_nightmode_btn.onClick=function()
      system_print("此版本不支持自行切换主题")
    end
  
    dl_btm_about_btn.onClick=function()
      system_incident["application_about"]()
    end
  
    dl_btm_settings_btn.onClick=function()
      system_incident["settings_btn"]()
    end
  
    dl_btm_exit_btn.onClick=function()
      system_incident["exit_application"]()
    end
  end
end

