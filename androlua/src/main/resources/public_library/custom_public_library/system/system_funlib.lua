--custom editor
function custom_editor(id,name,text)
  local editors={
    ["SoraEditor"]="io.github.rosemoe.sora.widget.CodeEditor",
    ["LuaEditor"]="com.androlua.LuaEditor",
    ["MyEditor"]="com.luastudio.azure.MyEditor"
  }
  local LuaStudioEditor=luajava.bindClass(editors[name])
  return {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    {
      LuaStudioEditor,
      layout_weight = "1",
      layout_width = "fill",
      --Typeface = load_font("editor"),
      id = id or "editor",
      text=text or "";
      layout_height="fill",
    };
  };
end

function get_resources(value)
  return activity.getResources().getString(value)
end

function get_ui_mode()
  return activity.getResources().getConfiguration().uiMode==33
end

function get_theme_colors()
  local array = activity.getTheme().obtainStyledAttributes({
    android.R.attr.colorBackground,
    android.R.attr.textColorPrimary,
    android.R.attr.colorPrimary,
    android.R.attr.colorPrimaryDark,
    android.R.attr.colorAccent,
    android.R.attr.navigationBarColor,
    android.R.attr.statusBarColor,
    android.R.attr.colorButtonNormal,
  });

  local colorBackground=array.getColor(0,0xFF00FF)
  local textColorPrimary=array.getColor(1,0xFF00FF)
  local colorPrimary=array.getColor(2,0xFF00FF)
  local colorPrimaryDark=array.getColor(3,0xFF00FF)
  local colorAccent=array.getColor(4,0xFF00FF)
  local navigationBarColor=array.getColor(5,0xFF00FF)
  local statusBarColor=array.getColor(6,0xFF00FF)
  local colorButtonNormal=array.getColor(7,0xFF00FF)

  background_color=colorBackground
  basic_color=colorAccent

  status_bar_color=statusBarColor
  navigation_bar_color=navigationBarColor
  basic_color_num=basic_color_num
  theme_ripple_csl=ColorStateList(int[0].class{int{}},int{basic_color_num})
end

function system_title_color()
  return basic_color_num
  --[[if tostring(pc(tool_bar_color))=="-1" then
    return basic_color
   else
    return white_color
  end]]
end

function change_color_strength(strength,color)
  return (tonumber("0x"..strength..string.sub(Integer.toHexString(color),3,8)))
end

function AutoSetToolTip(view,text)
  if tonumber(Build.VERSION.SDK) >= 26 then
    view.setTooltipText(text)
  end
end

function load_all_paths()
  if paths_data then
   else
    paths_data = common_data["paths"]
  end
  -- load paths
  environment_root_path = paths_data["environment_root_path"]
  environment_path = paths_data["environment_root_path"]
  cache_path = paths_data["cache_path"]
  local new_project_storage = activity.getLuaExtDir("projects")
  if paths_data["project_path"] then
    if paths_data["project_path"]~=new_project_storage then
      paths_data["project_path"]=new_project_storage
    end
  end
  project_path = paths_data["project_path"]
  project_storage = paths_data["project_path"]
  --system_print(project_storage)
  plugin_path = paths_data["plugin_path"]
  backup_path = paths_data["backup_path"]
  data_storage = paths_data["data_storage"]
  custom_path = paths_data["custom_path"]
end

function load_filelist_icons()
  description=load_icon_path("description")
  --文件图标
  lllua_file_img=description
  llhtml_file_img=description
  llcss_file_img=description
  lltxt_file_img=description
  lljava_file_img=description
  llaly_file_img=load_icon_path("photo")
  llother_file_img=load_icon_path("insert_drive_file")
  llfolder_img=load_icon_path("folder")
end

--[[layoutTransition=LayoutTransition()
.enableTransitionType(LayoutTransition.CHANGING)
.setDuration(LayoutTransition.CHANGE_APPEARING,300)
.setDuration(LayoutTransition.CHANGE_DISAPPEARING,300)]]

function newLayoutTransition()
  if not AnimStatus then
    return LayoutTransition().enableTransitionType(LayoutTransition.CHANGING)
  end
end

function getr(value)
  return get_resources(R.string[value])
end

function pc(value)
  return parseColor(value)
end

function ul(value)
  return utf8.lower(value)
end

--获取文本
function gets(value)
  return get_string(value)
end

-- parseColor
function parseColor(value)
  if type(value)=="string" then
    return Color.parseColor(value)
   else
    return value
  end
end

--修改颜色强度
function change_color_intensity(intensity,color)
  if type(color)=="string" then
    color=parseColor(color)
  end
  return (tonumber("0x"..intensity..string.sub(Integer.toHexString(color),3,8)))
end

--Copy Text
function copy_text(value)
  import "android.content.*"
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(value)
end

function symbol_bar_icon_color()
  if tostring(pc(get_theme_color("tool_bar_color")))=="-1" then
    return text_color
   else
    return system_title_color()
  end
end

function symbol_bar_color()
  return change_color_strength("EE",pc(get_theme_color("background_color")))
end

function open_qq_contact_window(qqnum)
  local url="mqqwpa://im/chat?chat_type=wpa&uin="..tostring(qqnum)
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function join_qq_group(groupnum)
  local url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..tostring(groupnum).."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function load_ripples()
  if ripples_type then
   else
    ripples_type={}
    ripples_type["circular_white"]=resources.getDrawable(circular_ripple_res).setColor(white_ripple_csl)
    ripples_type["square_white"]=resources.getDrawable(square_ripple_res).setColor(white_ripple_csl)
    ripples_type["circular_black"]=resources.getDrawable(circular_ripple_res).setColor(black_ripple_csl)
    ripples_type["square_black"]=resources.getDrawable(square_ripple_res).setColor(black_ripple_csl)
    ripples_type["circular_theme"]=resources.getDrawable(circular_ripple_res).setColor(theme_ripple_csl)
    ripples_type["square_theme"]=resources.getDrawable(square_ripple_res).setColor(theme_ripple_csl)
    if theme_value=="day_time" then
      ripples_type["circular_adaptive"]=resources.getDrawable(circular_ripple_res).setColor(black_ripple_csl)
      ripples_type["square_adaptive"]=resources.getDrawable(square_ripple_res).setColor(black_ripple_csl)
     else
      ripples_type["circular_adaptive"]=resources.getDrawable(circular_ripple_res).setColor(white_ripple_csl)
      ripples_type["square_adaptive"]=resources.getDrawable(square_ripple_res).setColor(white_ripple_csl)
    end
  end
end

function get_ripple(type)
  if ripples_type then
    if ripples_type[type] then
      return ripples_type[type]
    end
   else
    load_ripples()
    if ripples_type[type] then
      return ripples_type[type]
    end
  end
end

function set_webview_onkeylistener(webview_id)
  webview_id.setOnKeyListener(View.OnKeyListener{
    onKey=function(view,key_code,event)
      if ((key_code==event.KEYCODE_BACK) and view.canGoBack()) then
        view.goBack();
        return true
      end
      return false
    end
  })
end

function set_window_title(title,boolean)
  local trust_title
  if title then
    if boolean==false then
      trust_title=title
     else
      trust_title=gets(title)
    end
    activity.setTitle(trust_title)
    if main_title_id then
      main_title_id.setText(trust_title)
    end
  end
end

function get_file_changed_time(path)
  local f = File(path);
  local cal = Calendar.getInstance();
  local time = f.lastModified()
  cal.setTimeInMillis(time);
  return cal.getTime().toLocaleString()
end

function open_by_browser(url)
  import "android.content.Intent"
  import "android.net.Uri"
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
  activity.startActivity(viewIntent)
end

function open_url(url)
  xpcall(function()
    import "androidx.browser.customtabs.CustomTabsIntent"
    CustomTabsIntent.Builder()
    .setShowTitle(true)
    .setToolbarColor(basic_color_num)
    .build()
    .launchUrl(activity, Uri.parse(url))
  end,
  function()
    open_by_browser(url)
  end)
end

function check_login_status()
  return ((activity.getSharedData("login_username") and activity.getSharedData("login_username")~=nil) and (activity.getSharedData("login_password") and activity.getSharedData("login_password")~=""))
end

function rmDir(path)
  return LuaUtil.rmDir(File(path))
end

function get_file_size(path)
  import "java.io.File"
  import "android.text.format.Formatter"
  size=File(tostring(path)).length()
  Sizes=Formatter.formatFileSize(activity, size)
  return Sizes
end

function WriteFile(file_path,content)
  import "java.io.File"
  f=File(tostring(File(tostring(file_path)).getParentFile())).mkdirs()
  return pcall(function()io.open(tostring(file_path),"w"):write(tostring(content)):close()end)
end

function write_file(path,content)
  local status,err=pcall(function()io.open(path,"w"):write(content):close()end)
  return status,err
end

function ReadFile(file_path)
  import "java.io.File"
  return io.open(tostring(file_path)):read("*a")
end

function replace_text(path,pending_replace,replaced_text)
  if File(path).exists() then
    local path=tostring(path)
    local content=io.open(path):read("*a")
    io.open(path,"w+"):write(tostring(content:gsub(pending_replace,replaced_text))):close()
   else
    return false
  end
end

--文件备份
function file_backup(file)
  local backup_file_dir=tostring(files_bin_dir).."/"..project_app_name.."/"..tostring(os.time())
  if get_editor_setting("old_file_backup") then
    local file_name=file["name"]
    local dtrust_file_path=file["path"]
    local backup_file_path=backup_file_dir.."/"..file_name
    return LuaUtil.copyDir(dtrust_file_path,backup_file_path)
   else
    return true
  end
end

function file_backup_2(file,file_name,content)
  if get_editor_setting("old_file_backup") then
    local file_name=(file_name or file["name"])
    local file_path=file["path"]
    local file_path_2=(((initialization_dir and file_name and file_path:find(initialization_dir) and file_path:find(file_name) and file_path:match(initialization_dir.."(.-)/"..file_name)) or "/") or file_path)
    local backup_file_dir=tostring(files_backup_dir).."/"..project_app_name
    local backup_file_path=backup_file_dir..file_path_2.."/backup_"..get_file_last_time(file_path).."_"..file_name
    write_file(backup_file_path,content)
  end
end

function file_backup_3(file,backup_file_dir,content)
  if get_editor_setting("old_file_backup") then
    local file_name=file["name"]
    local dtrust_file_path=file["path"]
    local status,str=pcall(function()return dtrust_file_path:match(activity.getLuaExtDir().."(.-)"..file_name) end)
    if status and str then
      local backup_file_path=backup_file_dir.."/"..str.."/"..file_name
      return LuaUtil.copyDir(dtrust_file_path,backup_file_path)
     else
      local backup_file_path=backup_file_dir..dtrust_file_path
      return LuaUtil.copyDir(dtrust_file_path,backup_file_path)
    end
   else
    return true
  end
end

function parseJson(content)
  local cjson_m=require "cjson"
  if pcall(function()cjson_m.decode(content)
    end) then
    local json_cotent=cjson_m.decode(content)
    return true,json_cotent
   else
    return false
  end
end

function clear_all_runnables()
  if main_handler and main_handler_runnables then
    for index,content in pairs(main_handler_runnables) do
      main_handler.removeCallbacks(content)
    end
  end
  if main_handler then
    main_handler.removeCallbacksAndMessages(null)
  end
  main_handler=nil
end

function view_radius(view,radiu,InsideColor)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  if view then
    view.setBackgroundDrawable(drawable)
   else
    return drawable
  end
end

function widget_radius(view,InsideColor,radiu,return_view)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  if return_view then
    return drawable
   else
    view.setBackgroundDrawable(drawable)
  end
end

function Ripple(id,color,t)
  import "android.content.res.ColorStateList"
  local ripple
  if t=="圆" or t==nil then
    if not(RippleCircular) then
      RippleCircular=activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
    end
    ripple=RippleCircular
   elseif t=="方" then
    if not(RippleSquare) then
      RippleSquare=activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
    end
    ripple=RippleSquare
  end
  local Pretend=activity.Resources.getDrawable(ripple)
  if id then
    id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{color})))
   else
    return Pretend.setColor(ColorStateList(int[0].class{int{}},int{color}))
  end
end

function system_ripple(id, lx)
  xpcall(function()
    import "android.content.res.ColorStateList"
    -- Ripple
    ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0, 0)
    ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0, 0)

    for index,content in pairs(id) do
      if lx=="圆白" or lx=="circular_white" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="方白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆黑"or lx=="circular_black_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="方黑" or lx=="square_black_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="圆主题" or lx=="circular_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="方主题" or lx=="square_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="圆自适应" then
        if theme_value=="day_time" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="方自适应" then
        if theme_value=="day_time" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="square_adaptive" then
        if theme_value=="day_time" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
    end
  end,function(e)end)
end

function setImage(id,src)
  if Glide then
    Glide.with(activity).load(src).into(id)
   else
    id.setImageBitmap(loadbitmap(src))
  end
end


function dp2int(dpValue)
  import "android.util.TypedValue"
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, activity.getResources().getDisplayMetrics())
end
-- dp2px
function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
--dp转px
function dp2px2(sdp)
  dm=this.getResources().getDisplayMetrics()
  types={px=0,dp=1,sp=2,pt=3,["in"]=4,mm=5}
  n,ty=sdp:match("^(%-?[%.%d]+)(%a%a)$")
  return TypedValue.applyDimension(types[ty],tonumber(n),dm)
end
-- px2dp
function px2dp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return pxValue / scale + 0.5
end
-- px2sp
function px2sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end
-- sp2px
function sp2px(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return spValue * scale + 0.5
end

function skipLSActivity(name,value,use_activity)
  if all_activities_info then
    if all_activities_info[name] then
      local tool_info=all_activities_info[name]
      local tool_home_path=tool_info["tool_home_path"]
      if value then
        if use_activity then
          if use_activity=="LuaAppCompatActivity" then
            activity.newAppCompatActivity(tool_home_path,value)
           else
            system_print(gets("cannot_operate_tips"))
          end
         else
          activity.newLSActivity(tool_home_path,value)
        end
       else
        if use_activity then
          if use_activity=="LuaAppCompatActivity" then
            activity.newAppCompatActivity(tool_home_path)
           else
            system_print(gets("cannot_operate_tips"))
          end
         else
          activity.newLSActivity(tool_home_path)
        end
      end
     else
      system_print(gets("cannot_operate_tips"))
    end
   else
    if File(activity.getLuaDir().."/memory_file/all_activities_info.conf").exists() then
      if pcall(dofile,activity.getLuaDir().."/memory_file/all_activities_info.conf") then
        if all_activities_info then
          if all_activities_info[name] then
           else
            system_print(gets("cannot_operate_tips"))
          end
        end
      end
     else
      all_activities_info=(load_activities(activities_dir,all_activities_info))
      if all_activities_info then
        io.open(activity.getLuaDir().."/memory_file/all_activities_info.conf","w"):write("all_activities_info="..dump(all_activities_info)):close()
        if all_activities_info[name] then
         else
          system_print(gets("cannot_operate_tips"))
        end
      end
    end
  end
end


function delete_webdav_local_file(name,path)
  deleting_proj_dialog2.show()
  task(200,function()
    local save_proj_file_path=tostring(activity.getLuaExtDir("download")).."/"..name
    local backup_proj_file_path=tostring(webdav_deleted_backup_path).."/"..name
    LuaUtil.copyDir(save_proj_file_path,backup_proj_file_path)
    LuaUtil.rmDir(File(save_proj_file_path))
    system_print(gets("delete_succeed_tips"))
    deleting_proj_dialog2.hide()
  end)
end

--工程信息对话框
function project_info(proj_path,item_value,operator)
  --[[function pidga_add(click,icon,text,type)
  if type=="title" then
    while #project_info_dialog_gridview_data%pidgv_numColumns~=0 do
      project_info_dialog_gridview_adp.add{__type=4,{}}
    end
    project_info_dialog_gridview_adp.add({__type=5,title=text})
    while #project_info_dialog_gridview_data%pidgv_numColumns~=0 do
      project_info_dialog_gridview_adp.add{__type=3,{}}
    end
   elseif type=="item" or type==nil then
    project_info_dialog_gridview_adp.add({__type=1,item_img={src=load_icon_path(icon)},item_text={text=text},item_incident={text=click}})
  end
end]]
  function pidga_add(click,icon,text)
    project_info_dialog_gridview_adp.add({item_img={src=load_icon_path(icon)},item_text={text=text},item_incident={text=click}})
  end

  function pila_add(tip_text,content_text)
    project_info_listview_adp.add({tip_text=tip_text,content_text=content_text})
  end

  project_info_dialog_layout = import "layout.layout_dialogs.project_info_dialog_layout"
  project_info_dialog=AlertDialog.Builder(this)
  project_info_dialog.setView(loadlayout(project_info_dialog_layout))
  project_info_dialog2=project_info_dialog.show()
  local params = project_info_dialog2.getWindow().getAttributes();
  params.width = activity.width*8/9;
  --project_info_dialog2.setCanceledOnTouchOutside(false);
  project_info_dialog2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(pc(background_color)))
  project_info_dialog2.getWindow().setAttributes(params);

  local function read_project_info(path)
    local project_information={}
    local build_information_file=path.."/build.lsinfo"
    local init_information_file=path.."/app/src/main/assets/init.lua"
    local status_1=pcall(loadfile(build_information_file))
    local status_2=pcall(loadfile(init_information_file,"bt",project_information))
    local status_3=pcall(loadfile(build_information_file,"bt",project_information))

    if status_1 then
      --status_3 必为 true
      if build_info then
        local project_information=build_info
        build_info=nil
        return project_information
      end
    end
  end
  project_information=read_project_info(proj_path)
  local app_name=project_information["appname"]
  local app_packagename=project_information["packagename"]
  if project_information["template"] then
    app_type=project_information["template"]
    if project_type[app_type] then
      app_type=project_type[app_type]
     else
      app_type="unknown"
    end
   else
    app_type="unknown"
  end
  local app_version=project_information["appver"]
  setImage(project_info_dialog_icon_id,load_project_icon(proj_path))
  --  project_info_dialog_icon_id.setImageBitmap(loadbitmap(load_project_icon(proj_path)))
  project_info_dialog_name_id.setText(app_name)
  project_info_dialog_packagename_id.setText(app_packagename)
  --project_info_dialog_type_id.setText(app_type)
  --project_info_dialog_project_path.setText(project_path.."/")
  project_info_dialog_version_id.setText(app_version)

  --project_info_item=import "layout.layout_items.project_info_item"
  --project_info_listview_adp=LuaAdapter(activity,project_info_item)
  --project_info_listview.setAdapter(project_info_listview_adp)

  project_info_dialog_gridview_data={}
  project_info_dialog_gridview_item=import "layout.layout_items.project_info_dialog_gridview_item"
  --project_info_dialog_gridview_adp=LuaMultiAdapter(activity,project_info_dialog_gridview_data,project_info_dialog_gridview_item)
  project_info_dialog_gridview_adp=LuaAdapter(activity,project_info_dialog_gridview_data,project_info_dialog_gridview_item)
  project_info_dialog_gridview.setAdapter(project_info_dialog_gridview_adp)

  --pila_add(gets("app_type"),app_type)
  --pila_add(gets("app_path"),project_path.."/")

  --pidga_add("","",gets("project_operation"),"title")
  pidga_add("open_newwindow","photo_library","窗口打开")
  pidga_add("bin_project","adb",gets("bin_project"))
  pidga_add("clone_project","file_copy",gets("clone_project"))
  pidga_add("project_info_editor","settings",gets("project_info_editor"))
  -- pidga_add("project_permission_editor","https",gets("project_permission_editor"))
  pidga_add("fix_project","build",gets("fix_project"))
  pidga_add("save_project","save",gets("save_project"))
  pidga_add("share_project","open_in_new",gets("share_project"))
  pidga_add("delete_project","delete",gets("delete"))

  local function adapter_ripple(data,adapter)
    for index,content in pairs(data) do
      if content.item_text then
        if content.itemParent==nil then
          content.itemParent={}
        end
        if content.item==nil then
          content.item={}
        end
        content.item_text.textColor=pc(text_color)
        content.itemParent.backgroundColor=pc(gray_color)
        content.item.background=Ripple(nil,0x22000000)
      end
    end
    adapter.notifyDataSetChanged()
  end
  adapter_ripple(project_info_dialog_gridview_data,project_info_dialog_gridview_adp)

  --[[project_info_listview.onItemClick=function(p,v,i,s)
    system_incident["view_copy"](v.Tag.content_text)
  end]]
  project_info_dialog_gridview.onItemClick=function(p,v,i,s)
    local incident_name=v.Tag.item_incident.Text
    if system_incident[incident_name] then
      system_incident[incident_name](proj_path,project_information["template"],item_value["i"],operator)
     else
      system_print(gets("not_developed_yet"))
    end
    project_info_dialog2.dismiss()
  end
end

function read_project_info(path)
  local project_information={}
  local build_information_file=path.."/build.lsinfo"
  local init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file))
  local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  local status_3=pcall(loadfile(build_information_file,"bt",project_information))

  if status_1 then
    --status_3 必为 true
    if build_info then
      local project_information=build_info
      build_info=nil
      return project_information
    end
  end
end

function check_collect_status()
return false
end

function collect_project(proj_path)

end

function open_project_operations_dlg(project_path,position)
  project_operations_dlg=create_project_operations_dlg()
  --project_operation_collect_button
  project_operation_collect_button.onClick=function()
    collect_project(project_path)
  end

  if (check_collect_status()) then
    setImage(project_operation_collect_button_img,load_icon_path("star"))
  else
    setImage(project_operation_collect_button_img,load_icon_path("star_border"))
  end
  current_select_project_path=project_path
  current_select_project_position=position

  project_information=read_project_info(project_path)
  local app_name=project_information["appname"]
  local app_packagename=project_information["packagename"]
  if project_information["template"] then
    app_type=project_information["template"]
    app_type_table = {
      gets("lua_common_project"),
      gets("luajava_mix_project")
    }

    newapp_type_table = {
      [gets("lua_common_project")] = "common_lua",
      [gets("luajava_mix_project")] = "lua_java"
    }

    project_type = {
      common_lua = gets("lua_common_project"),
      lua_java = gets("luajava_mix_project")
    }
    if project_type[app_type] then
      app_type=project_type[app_type]
     else
      app_type="unknown"
    end
   else
    app_type="unknown"
  end
  local app_version=project_information["appver"]
  setImage(project_info_dialog_icon_id,load_project_icon(project_path))
  --  project_info_dialog_icon_id.setImageBitmap(loadbitmap(load_project_icon(proj_path)))
  project_info_dialog_name_id.setText(app_name)
  project_info_dialog_packagename_id.setText(app_packagename)
  --project_info_dialog_type_id.setText(app_type)
  --project_info_dialog_project_path.setText(project_path.."/")
  project_info_dialog_version_id.setText(project_path)

  current_select_project_template=app_type

  project_operations_dlg.show()
end

function clone_project(path,func)
  local output_path=path.."_clone"
  if not File(output_path).exists() then

    if pcall(function()LuaUtil.copyDir(File(path),File(path.."_clone"))end) then
      local mproject_path=path.."_clone"
      local build_information_file=mproject_path.."/build.lsinfo"
      local init_information_file=mproject_path.."/app/src/main/assets/init.lua"
      local function dump2(t)
        for k,v in ipairs(t) do
          t[k]=string.format("%q",v)
        end
        return table.concat(t,",\n ")
      end
      project_information={}
      local status_1=pcall(loadfile(build_information_file))
      local status_2=pcall(loadfile(init_information_file,"bt",project_information))
      if status_1 and status_2 then
        if build_info and user_permission then
          project_information=build_info
          pcall(loadfile(init_information_file,"bt",project_information))

          local info_debugmode=project_information["debugmode"]==nil or project_information["debugmode"]
          local build_content_template='build_info=%s\nuser_permission={\n\t%s\n}'
          local init_content_template='appname="%s"\ndebugmode=%s'
          build_info["appname"]=build_info["appname"].."_clone"

          local build_save_content=string.format(build_content_template,dump(build_info),dump2(user_permission))
          local init_save_content=string.format(init_content_template,build_info["appname"],info_debugmode)

          local mproject_path=path.."_clone"

          local build_information_file=mproject_path.."/build.lsinfo"
          local init_information_file=mproject_path.."/app/src/main/assets/init.lua"

          io.open(build_information_file,"w"):write(build_save_content):close()
          io.open(init_information_file,"w"):write(init_save_content):close()
          if func then
            pcall(func,true,mproject_path)
          end
        end
       else
        if func then
          pcall(func,false)
        end
      end
     else
      if func then
        pcall(func,false)
      end
    end
   else
    if func then
      pcall(func,false)
    end
  end
end
function mimport_alp_project(path)
  import_build_template=[[build_info={
 appname="%s",
 appver="%s",
 packagename="%s",
 appcode="%s",
 appsdk="%s",
 template="common_lua",
 developer="%s",
 description="%s",
}
user_permission={
 %s
}]]
  import_init_template=[[appname="%s"
debugmode=true]]
  app_name=read_alp_file(path)
  if app_name then
    local message=string.format(gets("name")..": %s\n"..gets("version")..": %s\n"..gets("packagename")..": %s\n"..gets("type")..": %s\n"..gets("developer")..": %s\n"..gets("explain")..": %s\n"..gets("path")..": %s",read_alp_file(path))
    system_dialog({title=gets("import_tip"),message=message,positive_button={button_name=gets("import_button"),func=function()
          if File(project_path.."/"..app_name).isDirectory() then
            local new_name=app_name.."_"..tostring(os.time())
            local new_path=activity.getLuaExtDir().."/projects/"..new_name.."/"
            ZipUtil.unzip(path,new_path.."app/src/main/assets/")

            local build_content=string.format(import_build_template,read_alp_file(path)):gsub(app_name,new_name)
            local init_content=string.format(import_init_template,new_name)
            io.open(new_path.."build.lsinfo","w"):write(build_content):close()
            io.open(new_path.."/app/src/main/assets/init.lua","w"):write(init_content):close()
            system_print(gets("import_succeed_tip"))

           else
            local new_path=activity.getLuaExtDir().."/projects/"..app_name.."/"
            ZipUtil.unzip(path,new_path.."app/src/main/assets/")
            local build_content=string.format(import_build_template,read_alp_file(path))
            local init_content=string.format(import_init_template,app_name)
            io.open(new_path.."build.lsinfo","w"):write(build_content):close()
            io.open(new_path.."/app/src/main/assets/init.lua","w"):write(init_content):close()
            system_print(gets("import_succeed_tip"))
          end
          --`load_projects()
        end},negative_button={button_name=gets("cancel_button")}})
   else
  end
end

function system_fix_project(path)
  fix_build_template=[[build_info={
 appname="%s",
 appver="%s",
 packagename="%s",
 appcode="%s",
 appsdk="%s",
 template="%s",
 developer="%s",
 description="%s",
}
user_permission={
 %s
}]]
  fix_init_template=[[appname="%s"
debugmode=true]]
  local project_information={}
  local build_information_file=path.."/build.lsinfo"
  local init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file,"bt",project_information))
  --local status_1=pcall(loadfile(build_information_file))
  local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  local status_3=pcall(loadfile(build_information_file))
  --print(dump(project_information))
  if status_3 then
    if build_info then
      project_information=build_info
    end
  end
  if status_1 or status_2 or status_3 then
    local app_name=project_information["appname"] or "demo_"..tostring(os.time())
    local app_packagename=project_information["packagename"] or "com.luastudio.demo"
    local app_code=project_information["appcode"] or "1"
    local app_sdk=project_information["appsdk"] or "15"
    local app_type=project_information["template"] or "common_lua"
    local app_ver=project_information["appver"] or "1.0"
    local app_developer=project_information["developer"] or ""
    local app_description=project_information["description"] or ""
    local up_tab={
      "ACCESS_COARSE_LOCATION",
      "ACCESS_FINE_LOCATION",
      "ACCESS_NETWORK_STATE",
      "ACCESS_WIFI_STATE",
      "INTERNET",
      "WRITE_EXTERNAL_STORAGE"
    }
    local app_userpermission=project_information["user_permission"] or up_tab
    local function dump2(t)
      for k,v in ipairs(t) do
        t[k]=string.format("%q",v)
      end
      return table.concat(t,",\n ")
    end
    --print(dump2(app_userpermission))
    local build_content=string.format(fix_build_template,app_name,app_ver,app_packagename,app_code,app_sdk,app_type,app_developer,app_description,dump2(app_userpermission))
    local init_content=string.format(fix_init_template,app_name)
    io.open(build_information_file,"w"):write(build_content):close()
    io.open(init_information_file,"w"):write(init_content):close()
    system_print(gets("repair_complete_tips"))
    --print(build_content)
  end
end

function import_alp_project(path)
  import_build_template=[[build_info={
 appname="%s",
 appver="%s",
 packagename="%s",
 appcode="%s",
 appsdk="%s",
 template="common_lua",
 developer="%s",
 description="%s",
}
user_permission={
 %s
}]]
  import_init_template=[[appname="%s"
debugmode=true]]
  app_name=read_alp_file(path)
  if app_name then
    local message=string.format(gets("name")..": %s\n"..gets("version")..": %s\n"..gets("packagename")..": %s\n"..gets("type")..": %s\n"..gets("developer")..": %s\n"..gets("explain")..": %s\n"..gets("path")..": %s",read_alp_file(path))
    system_dialog({title=gets("import_tip"),message=message,positive_button={button_name=gets("import_button"),func=function()
          if File(project_path.."/"..app_name).isDirectory() then
            local new_name=app_name.."_"..tostring(os.time())
            local new_path=activity.getLuaExtDir().."/projects/"..new_name.."/"
            ZipUtil.unzip(path,new_path.."app/src/main/assets/")

            local build_content=string.format(import_build_template,read_alp_file(path)):gsub(app_name,new_name)
            local init_content=string.format(import_init_template,new_name)
            io.open(new_path.."build.lsinfo","w"):write(build_content):close()
            io.open(new_path.."/app/src/main/assets/init.lua","w"):write(init_content):close()
            system_print(gets("import_succeed_tip"))

           else
            local new_path=activity.getLuaExtDir().."/projects/"..app_name.."/"
            ZipUtil.unzip(path,new_path.."app/src/main/assets/")
            local build_content=string.format(import_build_template,read_alp_file(path))
            local init_content=string.format(import_init_template,app_name)
            io.open(new_path.."build.lsinfo","w"):write(build_content):close()
            io.open(new_path.."/app/src/main/assets/init.lua","w"):write(init_content):close()
            system_print(gets("import_succeed_tip"))
          end
        end},negative_button={button_name=gets("cancel_button")}})
   else
  end
end

function check_project_file_info(path)
  local project_information={}
  local build_content=tostring(String(LuaUtil.readZip(path,"build.lsinfo")))
  local status_1=pcall(loadstring(build_content))
  project_information=build_info
  if status_1 then
    return true
   else
    return false
  end

end

function mimport_project(path)
  local app_name=read_lsinfo_file(path)
  --system_print(app_name)
  if app_name then
    function mimport_project_main()
      if File(project_path.."/"..app_name).isDirectory() then
        local new_name=app_name.."_"..tostring(os.time())
        local new_path=activity.getLuaExtDir().."/projects/"..new_name.."/"
        --print(new_path)
        ZipUtil.unzip(path,new_path)
        local build_content=io.open(new_path.."build.lsinfo"):read("*a")
        local new_build_content=build_content:gsub(app_name,new_name)
        io.open(new_path.."build.lsinfo","w"):write(new_build_content):close()
        system_print(gets("import_succeed_tip"))
       else
        ZipUtil.unzip(path,activity.getLuaExtDir().."/projects/"..app_name.."/")
        system_print(gets("import_succeed_tip"))
      end
      if project_open_file and project_open_file.Text=="/" then
        load_projects_list()
      end
    end

    local message=string.format(gets("name")..": %s\n"..gets("version")..": %s\n"..gets("packagename")..": %s\n"..gets("type")..": %s\n"..gets("developer")..": %s\n"..gets("explain")..": %s\n"..gets("path")..": %s",read_lsinfo_file(path))
    system_dialog({title=gets("import_tip"),message=message,positive_button={button_name=gets("import_button"),func=function()mimport_project_main()end},negative_button={button_name=gets("cancel_button")}})
   else
  end
end

function read_lsinfo_file(path)
  local project_information={}
  local build_content=tostring(String(LuaUtil.readZip(path,"build.lsinfo")))
  local init_content=tostring(String(LuaUtil.readZip(path,"app/src/main/assets/init.lua")))
  local status_1=pcall(loadstring(build_content))
  project_information=build_info
  local status_2=pcall(loadstring(init_content,"bt","bt",project_information))
  if status_1 then
    app_name=project_information["appname"]
    app_packagename=project_information["packagename"]
    app_type=project_information["template"]
    app_ver=project_information["appver"]
    app_developer=project_information["developer"]
    app_description=project_information["description"]
  end

  return app_name,app_ver,app_packagename,app_type,app_developer,app_description,path
end

function read_alp_file(path)
  local project_information={}
  local init_content=tostring(String(LuaUtil.readZip(path,"init.lua")))
  local status=pcall(loadstring(init_content,"bt","bt",project_information))
  if status then
    app_name=project_information["appname"]
    app_packagename=project_information["packagename"]
    app_code=project_information["appcode"]
    app_sdk=project_information["appsdk"]
    app_type=project_information["template"]
    app_ver=project_information["appver"]
    app_developer=project_information["developer"]
    app_description=project_information["description"]
    app_userpermission=project_information["user_permission"]
  end
  local function dump2(t)
    for k,v in ipairs(t) do
      t[k]=string.format("%q",v)
    end
    return table.concat(t,",\n ")
  end
  return app_name,app_ver,app_packagename,app_code,app_sdk,app_developer,app_description,dump2(app_userpermission),path
  --return app_name,app_ver,app_packagename,app_type,app_developer,app_description,path
end

function import_project(path)
  --print(check_project_file_info(path))

  if check_project_file_info(path) then
    local app_name=read_lsinfo_file(path)
    if app_name then
      local message=string.format(gets("name")..": %s\n"..gets("version")..": %s\n"..gets("packagename")..": %s\n"..gets("type")..": %s\n"..gets("developer")..": %s\n"..gets("explain")..": %s\n"..gets("path")..": %s",read_lsinfo_file(path))

      local import_project_dlg=MaterialAlertDialogBuilder(activity)
      import_project_dlg.setTitle(gets("import_tip"))
      import_project_dlg.setMessage(message)
      import_project_dlg.setPositiveButton(gets("import_button"),function()
        if File(project_path.."/"..app_name).isDirectory() then
          local new_name=app_name.."_"..tostring(os.time())
          local new_path=activity.getLuaExtDir().."/projects/"..new_name.."/"
          --print(new_path)
          ZipUtil.unzip(path,new_path)
          local build_content=io.open(new_path.."build.lsinfo"):read("*a")
          local new_build_content=build_content:gsub(app_name,new_name)
          io.open(new_path.."build.lsinfo","w"):write(new_build_content):close()
          system_print(gets("import_succeed_tip"))
         else
          ZipUtil.unzip(path,activity.getLuaExtDir().."/projects/"..app_name.."/")
          system_print(gets("import_succeed_tip"))
        end
      end)
      import_project_dlg.setNegativeButton(gets("cancel_button"),nil)
      import_project_dlg_2=import_project_dlg.show()
      set_dialog_style(import_project_dlg_2)
    end
  end
end



function NoScrollPageView()
  return luajava.override(PageView,{
    onInterceptTouchEvent=function(super,event)
      return false
    end,
    onTouchEvent=function(super,event)
      return false
    end
  })
end

function get_status_bar_height()
  --这个需要系统SDK19以上才能用
  if Build.VERSION.SDK_INT <21 then
    return status_bar_height
   elseif Build.VERSION.SDK_INT >= 21 then
    return ""
  end
end

function set_status_bar_color(value)
  value=parseColor(value)
  window=activity.getWindow()
  window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(value);
end

function set_navigation_bar_color(color)
  if type(color)=="string" then
    color=parseColor(color)
   else
    color=color
  end
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().setNavigationBarColor(color);
   else
  end
end

function system_import_resources()
  internal_storage=Environment.getExternalStorageDirectory().toString()
  if (opened_file.Text==gets("file_not_open")) then
    system_print(gets("file_not_open"))
    system_incident["close_drawer_layout"]()
   else
    system_incident["close_drawer_layout"]()

    items2={
      "导入图像",
      "导入Dex",
      "导入Lua",
      "导入其他文件"
    }

    import_res_dialog=AlertDialog.Builder(this)
    import_res_dialog.setTitle("导入资源")
    import_res_dialog.setItems(items2,{onClick=function(lll,vvv)
        if vvv==0 then
          choose_file(internal_storage,function(path,name)
            if initialization_dir_2 then
              LuaUtil.copyDir(path,initialization_dir_2.."/".. name)
              system_print(gets("import_succeed_tip"))
            end
          end,"image")
        end
        if vvv==1 then
          choose_file(internal_storage,function(path,name)
            if initialization_dir_2 then
              --提示(IDE_Storage.."project"..项目打开地址. Text.."/")
              LuaUtil.copyDir(path,initialization_dir_2.."/libs/".. name)
              system_print(gets("import_succeed_tip"))
            end
          end,"dex")
        end
        if vvv==2 then
          choose_file(internal_storage,function(path,name)
            --提示(IDE_Storage.."project"..项目打开地址. Text.."/")
            if initialization_dir_2 then
              LuaUtil.copyDir(path,initialization_dir_2.."/".. name)
              system_print(gets("import_succeed_tip"))
            end
          end,"lua")
        end
        if vvv==3 then
          choose_file(internal_storage,function(path,name)
            --提示(IDE_Storage.."project"..项目打开地址. Text.."/")
            if initialization_dir_2 then
              LuaUtil.copyDir(path,initialization_dir_2.."/".. name)
              system_print(gets("import_succeed_tip"))
            end
          end)
        end
      end})
    import_res_dialog2=import_res_dialog.show().hide()
    set_dialog_style(import_res_dialog2)
    import_res_dialog2.show()
  end
end


function backup_project(proj_path,output_path,skip_build)
  local trust_output_path
  --输出目录
  if type(output_path)=="string" then
    trust_output_path=output_path
   elseif output_path==false then
    trust_output_path=tostring(activity.getExternalFilesDir("projects_bin"))
   else
    trust_output_path=backup_path
  end
  import "com.luastudio.azure.system.SystemLibrary"
  if skip_build==true then
    return SystemLibrary.backupProject(proj_path,trust_output_path,true)
   else
    return SystemLibrary.backupProject(proj_path,trust_output_path)
  end
end

function delete_project(proj_path,backup_status,func)
  if backup_status==false then
    LuaUtil.rmDir(File(proj_path))
    if func then
      pcall(func,true)
    end
    return true
   else
    local input=backup_project(proj_path,false)
    if input then
      LuaUtil.rmDir(File(proj_path))
      if func then
        pcall(func,true)
      end
      return true
     else
      if func then
        pcall(func,false)
      end
      return false
    end
  end
end

function system_import_project()
  choose_file(Environment.getExternalStorageDirectory().toString(),function(path,name)
    if name:find("%.alp$") then
      import_alp_project(path)
     else
      import_project(path)
    end
    --load_projects_list()
  end,"project_backup_file")
end

function system_projectinfo_editor(path)
  skipLSActivity("project_info",{path})
end

function system_code_navigation()
  --创建对话框
  function create_navi_dlg()
    if navi_dlg then
      return
    end
    navi_dlg = Dialog(activity)
    navi_dlg.setTitle("代码导航")
    navi_list = ListView(activity)
    navi_list.onItemClick = function(parent, v, pos, id)
      editor.setSelection(indexs[pos + 1])
      navi_dlg.hide()
    end
    navi_dlg.setContentView(navi_list)
    navi_dlg2=navi_dlg.show().hide()
    set_dialog_style(navi_dlg2)

  end
  system_incident["close_drawer_layout"]()
  if (opened_file.Text==gets("file_not_open")) then
    system_print(gets("file_not_open"))
   else
    create_navi_dlg()
    local str = editor.getText().toString()
    local fs = {}
    indexs = {}
    for s, i in str:gmatch("([%w%._]* *=? *function *[%w%._]*%b())()") do
      i = utf8.len(str, 1, i) - 1
      s = s:gsub("^ +", "")
      table.insert(fs, s)
      table.insert(indexs, i)
      fs[s] = i
    end
    local adapter = ArrayAdapter(activity, android.R.layout.simple_list_item_1, String(fs))
    navi_list.setAdapter(adapter)
    navi_dlg2.show()
  end
end

function save_project(path,func)
  spopreations={
    [gets("local_backup_text")]=function(path)
      local input=backup_project(path,true)
      if input then
        if func then
          pcall(func)
        end
        system_print(gets("backup_succeed_tips"))
       else
        if func then
          pcall(func)
        end
        system_print(gets("backup_failed_tips"))
      end

    end,
    [gets("local_backup_skip_build_text")]=function(path)
      local input=backup_project(path,true,true)
      if input then
        if func then
          pcall(func)
        end
        system_print(gets("backup_succeed_tips"))
       else
        if func then
          pcall(func)
        end
        system_print(gets("backup_failed_tips"))
      end

    end,
    [gets("cloud_backup_text")]=function(path)
      if spo_progress_dlg_2 then
        spo_progress_dlg_2.dismiss()
      end
      if uploading_proj_dialog then
       else
        uploading_proj_dialog,uploading_proj_dialog2=create_progress_dlg(gets("uploading_tips"),gets("uploading_proj_message_tips"))
      end
      uploading_proj_dialog2.show()
      task(500,function()
        function read_project_name(path)
          local project_information={}
          build_information_file=path.."/build.lsinfo"
          init_information_file=path.."/app/src/main/assets/init.lua"
          local status_1=pcall(loadfile(init_information_file,"bt",project_information))
          local status_2=pcall(loadfile(build_information_file))
          project_information=build_info
          if status_1 and status_2 then
            return project_information["appname"]
           elseif not status_1 and status_2 then
            return project_information["appname"]
           elseif status_1 and not status_2 then
            return project_information["appname"]
          end
        end
        local cfile_name=read_project_name(path)
        local cbackup_path=activity.getLuaExtDir().."/cache/backup"
        local cbackup_file_path=cbackup_path.."/"..cfile_name..".zip"
        local cbackup_date=os.date("%y%m%d%H%M%S")
        local cnew_name=cfile_name.."_"..cbackup_date..".lsz"
        local cnew_file_path=cbackup_path.."/"..cnew_name
        local input = ZipUtil.zip(path,cbackup_path)
        if input then
          File(cbackup_file_path).renameTo(File(cnew_file_path))
          if func then
            pcall(func)
          end
          local file_path=cnew_file_path
          wdploupload(file_path)
         else
          if func then
            pcall(func)
          end
        end
      end)
    end
  }

  if project_webdav then
    save_project_operations={
      gets("local_backup_text"),
      gets("local_backup_skip_build_text"),
      gets("cloud_backup_text"),
    }

   else
    save_project_operations={
      gets("local_backup_text"),
      gets("local_backup_skip_build_text"),
    }
    --spopreations[gets("local_backup_text")](path)
  end
  save_project_operations_dlg=AlertDialog.Builder(this)
  save_project_operations_dlg.setTitle(gets("backup_tips"))
  save_project_operations_dlg.setItems(save_project_operations,{onClick=function(lll,vvv)
      if spo_progress_dlg then
        spo_progress_dlg.setMessage(gets("loading_text"))
       else
        spo_progress_dlg,spo_progress_dlg_2=create_progress_dlg()
      end
      spo_progress_dlg_2.show()
      task(250,function()
        spopreations[save_project_operations[vvv+1]](path)
      end)
    end})
  save_project_operations_dlg2=save_project_operations_dlg.show().hide()

  if func then
    pcall(func)
  end
  set_dialog_style(save_project_operations_dlg2)
  save_project_operations_dlg2.show()
end

--Dialog
function share_file(file_path)
  --[[import "android.webkit.MimeTypeMap"
  import "android.content.Intent"
  import "android.net.Uri"
  import "java.io.File"
  --FileName=tostring(File(file_path).Name)
  --ExtensionName=FileName:match("%.(.+)")
  local Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(file_type)
  intent = Intent()
  intent.setAction(Intent.ACTION_SEND)
  intent.setType(Mime)
  local file = File(file_path)
  local uri = Uri.fromFile(file)
  intent.putExtra(Intent.EXTRA_STREAM,uri)
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  activity.startActivity(Intent.createChooser(intent,dialog_tips))]]
  --缓存到cache
  local file_path_2 = activity.getLuaExtPath("cache/share_"..(os.time()), File(file_path).getName());
  LuaUtil.copyDir(file_path, file_path_2);
  AzureUtil.shareFile(activity, file_path_2);
end

--data_storage
function share_project(proj_path,func)
  local fileName = File(proj_path).getName()
  local share_file_name = fileName.."_"..tostring(os.time())..".lsz"
  local cache_dir=activity.getLuaExtDir().."/cache"
  local new_file_path = cache_dir.."/"..share_file_name
  local input = AzureLibrary.zip(proj_path,cache_dir,share_file_name)
  if input then
    if func then
      pcall(func)
    end
    share_file(new_file_path)
   else
    if func then
      pcall(func)
    end
    system_print(gets("shared_failed_tips"))
  end
end

--system EditText
function SystemEditText(t)
  local edit_layout=loadlayout({
    RelativeLayout;
    focusable=true;
    layout_width="fill";
    layout_height="-2";
    focusableInTouchMode=true;
    paddingLeft="64dp";
    paddingRight="64dp";
    {
      TextView;
      layout_width="fill";
      layout_height="48dp";
      --backgroundDrawable=edrawable;
      layout_marginTop="8dp";
    };
    {
      EditText;
      textColor=get_theme_color("paratext_color");
      textSize="14sp";
      gravity="center|left";
      --Typeface=load_font("common");
      --layout_marginTop="12dp";
      SingleLine=true;
      layout_width="fill";
      layout_height="48dp";
      id=t.id.."_edittext";
      background="#00212121";
      layout_margin="8dp";
      padding="8dp";
      layout_marginTop="8dp";
    };

    {
      TextView;
      textColor=get_theme_color("paratext_color");
      text=t.text or "Hint";
      --text=gets("username_text");
      textSize="14sp";
      padding="8dp";
      paddingTop=0;
      paddingBottom=0;
      layout_margin="8dp";
      layout_width="-2";
      layout_height="-2";
      id=t.id.."_hint";
      background=background_color;
      layout_marginTop="8dp";
      layout_alignBaseline=t.id.."_edittext";
      Typeface=load_font("bold");
    };

  })

  local edit_text_id=edit_layout.getChildAt(1)
  local edit_hint_id=edit_layout.getChildAt(2)
  edit_text_id.setOnFocusChangeListener({
    onFocusChange=function(v,hasFocus)
      if hasFocus then
        --焦点在编辑框上
        edit_hint_id.setTextColor(parseColor(basic_color))
        if #edit_text_id.text==0 then
          edit_hint_id.startAnimation(TranslateAnimation(0,0,0,-dp2px(48/2)).setDuration(100).setFillAfter(true))
        end
       else
        --焦点离开编辑框
        edit_hint_id.setTextColor(parseColor(get_theme_color("paratext_color")))
        if #edit_text_id.text==0 then
          edit_hint_id.startAnimation(TranslateAnimation(0,0,-dp2px(48/2),0).setDuration(100).setFillAfter(true))
         else
          edit_hint_id.setTextColor(parseColor(basic_color))
        end
      end
    end
  })
  return function() return edit_layout end
end

function choose_file(path,callback,type)
  system_filechoose_types={
    all="*/*",
    image="image/*",
  }
  if (settings["choose_file_module"]=="ide") then
    inside_choose_file(path,callback,type)
   elseif (settings["choose_file_module"]=="system") then
    local type=system_filechoose_types[type] or "*/*"
    system_choose_file(type,callback)
   else
    local type=system_filechoose_types[type] or "*/*"
    system_choose_file(type,callback)
  end
end

function system_choose_file(type,callback)
  import "java.io.File"
  intent = Intent(Intent.ACTION_GET_CONTENT)
  intent.setType(type);
  intent.addCategory(Intent.CATEGORY_OPENABLE)
  activity.startActivityForResult(intent,1);
  function onActivityResult(requestCode,resultCode,data)
    if resultCode == Activity.RESULT_OK then
      local uri = data.getData()
      local file_path = AzureLibrary.UriToFilePath(activity,uri)
      local file_name = File(tostring(file_path)).getName()
      callback(file_path,file_name)
    end
  end
end

--choose file module
function inside_choose_file(path,callback,type)
  choose_file_dialog_layout=import "layout.layout_dialogs.choose_file_dialog_layout"

  choose_file_dialog=MyBottomDialog(activity)
  choose_file_dialog.setTitle(gets("choose_file"))
  choose_file_dialog.setView(loadlayout(choose_file_dialog_layout))
  choose_file_dialog.setGravity(Gravity.BOTTOM)
  choose_file_dialog.setHeight(activity.getHeight()*0.85)
  choose_file_dialog.setWidth(activity.getWidth())
  choose_file_dialog.setRadius(radiu,pc(background_color))
  choose_file_dialog.setCanceledOnTouchOutside(true);

  --file list
  local file_item={
    LinearLayoutCompat;
    layout_height="-2";
    layout_width="-1";
    Gravity="left|center";
    paddingTop="12dp";
    paddingLeft="24dp";
    paddingRight="24dp";
    paddingBottom="12dp";
    {
      ImageView;
      --src="res/file";
      layout_height="24dp";
      layout_width="24dp";
      colorFilter=pc(text_color);
      id="file_icon";
    };
    {
      TextView;
      layout_width="-1";
      layout_marginLeft="16dp";
      layout_height="-2";
      textSize="14sp";
      Text="sdcard";
      textColor=text_color;
      id="file_name";
    };
  };

  file_list_adp=LuaAdapter(activity,file_item)


  function close_progress()
    filedialog_progressbar.setVisibility(8)
  end

  function no_permission_tips()
    system_print(get_string("no_permission_tips"))
  end

  function read_data(path)
    require "import"
    local function read_data_filelist(path)
      import "java.io.File"
      import "android.provider.*"
      import "android.support.v4.provider.*"
      import "android.net.Uri"
      import "android.provider.DocumentsContract"
      --import "DataLibrary"

      --[[if DataLibrary.isGrant() then --该方法判断是否获取访问data权限
        ls=DataLibrary.getFileList(path)
        if ls~=nil then
          ls=luajava.astable(DataLibrary.getDoucmentFile(path).listFiles()) --全局文件列表变量
          table.sort(ls,function(a,b)
            return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and utf8.lower(a.Name)<utf8.lower(b.Name))
          end)
         else
          ls={}
        end
        for index,c in ipairs(ls) do
          call("add_filelist",c)
        end
       else
        call("no_permission_tips")
      end]]
    end

    local function read_common_filelist()
      import "java.io.File"
      ls=File(path).listFiles()
      if ls~=nil then
        ls=luajava.astable(File(path).listFiles()) --全局文件列表变量
        table.sort(ls,function(a,b)
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and utf8.lower(a.Name)<utf8.lower(b.Name))
        end)
       else
        ls={}
      end
      for index,c in ipairs(ls) do
        call("add_filelist",c)
      end
    end

    if path:find("Android/data") then
      import "android.os.Build"
      sdk_version=Build.VERSION.SDK_INT
      if sdk_version > 29 and sdk_version < 33 then
        read_data_filelist(path)
       else
        read_common_filelist(path)
      end
     else
      read_common_filelist(path)
    end
    call("close_progress")
  end

  function filelist_initialization(path)
    dlgfilelist_data={}
    filedialog_progressbar.setVisibility(0)

    path=tostring(path)
    file_list_adp.clear()--清空适配器
    now_file_path.Text=tostring(path)--设置当前路径

    if path~=Environment.getExternalStorageDirectory().toString() and path~="/sdcard" then--不是根目录则加上../
      file_list_adp.add{file_name=tostring(File(now_file_path.Text).getParentFile()),file_icon={src=load_icon_path("arrow_back")}}
      table.insert(dlgfilelist_data,file_name)
    end
    thread(read_data,path)


  end

  function add_filelist(file)

    import "java.io.File"
    if file.isDirectory() then
      file_list_adp.add{file_name=file.Name.."/",file_icon={src=load_icon_path("folder")}}
      table.insert(dlgfilelist_data,file)
     else
      if file.isFile() then
        if not type or type=="all" then
          if file.Name:find("%.lsz") or file.Name:find("%.alp") or file.Name:find("%.AL") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("inbox")}}
            table.insert(dlgfilelist_data,file)
           else
            if file.Name:find("%.apk$") then
              file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("adb")}}
              table.insert(dlgfilelist_data,file)
             else
              if file.Name:find("%.img$") or file.Name:find("%.png$") or file.Name:find("%.jpg$") or file.Name:find("%.aly$")then
                file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("photo")}}
                table.insert(dlgfilelist_data,file)
               else
                file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("insert_drive_file")}}
                table.insert(dlgfilelist_data,file)
              end
            end
          end
         elseif type=="keystore" then
          if file.Name:find("%.jks") or file.Name:find("%.keystore") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("insert_drive_file")}}
            table.insert(dlgfilelist_data,file)
          end
         elseif type=="lua" then
          if file.Name:find("%.lua") or file.Name:find("%.aly") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("insert_drive_file")}}
            table.insert(dlgfilelist_data,file)
          end
         elseif type=="project_backup_file" then
          if file.Name:find("%.lsz") or file.Name:find("%.alp") or file.Name:find("%.AL") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("inbox")}}
            table.insert(dlgfilelist_data,file)
          end
         elseif type=="update_file" then
          if file.Name:find("%.lsupdate") or file.Name:find("%.zip") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("inbox")}}
            table.insert(dlgfilelist_data,file)
          end
         elseif type=="image" then
          if file.Name:find("%.png") or file.Name:find("%.jpg") or file.Name:find("%.gif") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("photo")}}
            table.insert(dlgfilelist_data,file)
          end
         elseif type=="dex" then
          if file.Name:find("%.dex") then
            file_list_adp.add{file_name=file.Name,file_icon={src=load_icon_path("insert_drive_file")}}
            table.insert(dlgfilelist_data,file)
          end
        end
      end
    end
  end

  file_dialog_list.onItemClick=function(p,v,i,s)
    --print(dlgfilelist_data[i])
    file_name=tostring(v.Tag.file_name.Text)
    if now_file_path.text~=Environment.getExternalStorageDirectory().toString() and now_file_path.text~="/sdcard" then--不是根目录则加上../

      if file_name==tostring(File(now_file_path.Text).getParentFile()) then
        --thread(read_data,File(now_file_path.Text).getParentFile())
        filelist_initialization(File(now_file_path.Text).getParentFile())
        file_dialog_list.setSelection(tonumber(list_select_item.Text))
       elseif dlgfilelist_data[s].isDirectory() then
        local file_path=now_file_path.Text.."/"..dlgfilelist_data[s].Name
        list_select_item.setText(tostring(i))
        filelist_initialization(file_path)
       elseif dlgfilelist_data[s].isFile() then
        local file_name=v.Tag.file_name.Text
        local file_path=now_file_path.Text.."/"..dlgfilelist_data[s].Name
        callback(tostring(file_path),tostring(file_name))
        choose_file_dialog.dismiss()
      end
     else
      if file_name==tostring(File(now_file_path.Text).getParentFile()) then
        filelist_initialization(File(now_file_path.Text).getParentFile())
        file_dialog_list.setSelection(tonumber(list_select_item.Text))
       elseif dlgfilelist_data[s].isDirectory() then
        local file_path=now_file_path.Text.."/"..dlgfilelist_data[s].Name
        list_select_item.setText(tostring(i))
        filelist_initialization(file_path)
       elseif dlgfilelist_data[s].isFile() then
        local file_name=v.Tag.file_name.Text
        local file_path=now_file_path.Text.."/"..dlgfilelist_data[s].Name
        callback(tostring(file_path),tostring(file_name))
        choose_file_dialog.dismiss()
      end
    end
  end
  file_dialog_list.setAdapter(file_list_adp)
  --shortcutList
  shortcutList={
    LinearLayoutCompat;
    layout_height="-2";
    layout_width="-1";
    Gravity="left|center";
    paddingTop="12dp";
    paddingLeft="24dp";
    paddingRight="24dp";
    paddingBottom="12dp";
    {
      ImageView;
      layout_height="24dp";
      layout_width="24dp";
      layout_marginRight="16dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      colorFilter=pc(text_color);
      id="shortcutIcon";
    };
    {
      LinearLayoutCompat;
      orientation="vertical";
      layout_width="-1";
      layout_height="-1";
      gravity="center|left";
      {
        TextView;
        layout_width="fill";
        textSize="14sp";
        singleLine="true";
        textColor=pc(text_color);
        id="shortcutTitle";
      };
      {
        TextView;
        layout_width="fill";
        textSize="12sp";
        textColor=pc(text_color);
        singleLine="true";
        id="shortcutPath";
      };
    };
  };
  shortcutAdp=LuaAdapter(activity,shortcutList)
  shortcutListId.setAdapter(shortcutAdp)
  shortcutListId.onItemClick=function(l,v,p,s)
    local path=tostring(v.Tag.shortcutPath.Text)
    filelist_initialization(path)
    pageShow(0)
  end

  if File("/storage/emulated/0/Download").exists() then
    shortcutAdp.add{shortcutTitle=gets("download_title"),shortcutPath="/storage/emulated/0/download",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv").exists() then
    shortcutAdp.add{shortcutTitle=gets("qq_download_dir"),shortcutPath="/storage/emulated/0/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/Tencent/QQ_Images").exists() then
    shortcutAdp.add{shortcutTitle=gets("qq_download_pic_dir"),shortcutPath="/storage/emulated/0/tencent/QQ_Images",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/Android/data/com.tencent.tim/Tencent/TIMfile_recv").exists() then
    shortcutAdp.add{shortcutTitle=gets("tim_download_dir"),shortcutPath="/storage/emulated/0/Android/data/com.tencent.tim/Tencent/TIMfile_recv",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/Tencent/Tim_Images").exists() then
    shortcutAdp.add{shortcutTitle=gets("tim_download_pic_dir"),shortcutPath="/storage/emulated/0/tencent/Tim_Images",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/DCIM/").exists() then
    shortcutAdp.add{shortcutTitle=gets("camera_dir"),shortcutPath="/storage/emulated/0/DCIM",shortcutIcon={src=load_icon_path("folder")}}
  end
  if File("/storage/emulated/0/Pictures").exists() then
    shortcutAdp.add{shortcutTitle=gets("pictures_dir"),shortcutPath="/storage/emulated/0/Pictures",shortcutIcon={src=load_icon_path("folder")}}
  end


  function pageShow(number)
    pageview.showPage(number)
  end
  pageview.setOnPageChangeListener(PageView.OnPageChangeListener{
    onPageScrolled=function(a,b,c)
      local w=activity.getWidth()/2
      local wd=c/2
      if a==0 then
        psdm.setX(wd)
      end
      if a==1 then
        psdm.setX(wd+w)
      end
    end,
  })

  filelist_initialization(path)
  choose_file_dialog.show()
end

--arbg dialog module
function arbg_dialog_func(func,arbg_type,value)
  local radiu=100
  function seek_bar_color(seek_bar_id,color)
    import "android.graphics.PorterDuffColorFilter"
    import "android.graphics.PorterDuff"
    seek_bar_id.ProgressDrawable.setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
    seek_bar_id.Thumb.setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
  end

  function updateArgb()
    local a=seek_bar_1.getProgress()
    if tonumber(string.format('%#x', a)) == 0 then
      a=0x10
    end
    local r=seek_bar_2.getProgress()
    local g=seek_bar_3.getProgress()
    local b=seek_bar_4.getProgress()
    local argb_hex=(a<<24|r<<16|g<<8|b)
    color_text.setText(string.format('%#x', argb_hex))
    color_card.setBackgroundDrawable(GradientDrawable().setShape(GradientDrawable.RECTANGLE).setColor(argb_hex).setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}))
  end

  arbg_dialog_layout=import "layout.layout_dialogs.arbg_dialog_layout"
  local arbg_dialog_layout=loadlayout(arbg_dialog_layout)

  seek_bar_1.setProgress(int(0xff))
  seek_bar_2.setProgress(int(0x00))
  seek_bar_3.setProgress(int(0x00))
  seek_bar_4.setProgress(int(0x00))

  seek_bar_1.setOnSeekBarChangeListener{
    onProgressChanged=function(view, i)
      updateArgb()
    end}
  seek_bar_2.setOnSeekBarChangeListener{
    onProgressChanged=function(view, i)
      updateArgb()
    end}
  seek_bar_3.setOnSeekBarChangeListener{
    onProgressChanged=function(view, i)
      updateArgb()
    end}
  seek_bar_4.setOnSeekBarChangeListener{
    onProgressChanged=function(view, i)
      updateArgb()
    end}

  arbg_dialog = AlertDialog.Builder(this)
  arbg_dialog.setTitle(gets("arbg_dialog_title"))
  arbg_dialog.setView(arbg_dialog_layout)
  if arbg_type then

    if arbg_type=="editor" then
      arbg_dialog.setPositiveButton("#",function()
        local a=seek_bar_1.getProgress()
        if tonumber(string.format('%#x', a)) == 0 then
          a=0x10
        end
        local r=seek_bar_2.getProgress()
        local g=seek_bar_3.getProgress()
        local b=seek_bar_4.getProgress()
        local argb_hex=(a<<24|r<<16|g<<8|b)
        color4=string.format('%#x', argb_hex):gsub("0x","#")
        func(color4)
      end)
      arbg_dialog.setNeutralButton("0x",function()
        local a=seek_bar_1.getProgress()
        if tonumber(string.format('%#x', a)) == 0 then
          a=0x10
        end
        local r=seek_bar_2.getProgress()
        local g=seek_bar_3.getProgress()
        local b=seek_bar_4.getProgress()
        local argb_hex=(a<<24|r<<16|g<<8|b)
        color4=string.format('%#x', argb_hex)
        func(color4)
      end)
     elseif arbg_type=="settings" then
      arbg_dialog.setPositiveButton(gets("ok_button"),function()
        local a=seek_bar_1.getProgress()
        if tonumber(string.format('%#x', a)) == 0 then
          a=0x10
        end
        local r=seek_bar_2.getProgress()
        local g=seek_bar_3.getProgress()
        local b=seek_bar_4.getProgress()
        local argb_hex=(a<<24|r<<16|g<<8|b)
        color4=string.format('%#x', argb_hex):gsub("0x","#")
        func(color4)
      end)
      if value then
        local a=value["a"]
        local b=value["b"]
        local c=value["c"]
        local d=value["d"]
        seek_bar_1.setProgress(int(a))
        seek_bar_2.setProgress(int(b))
        seek_bar_3.setProgress(int(c))
        seek_bar_4.setProgress(int(d))
      end
     else
      func(color4)
    end
  end
  arbg_dialog.setNegativeButton(gets("cancel_button"),nil)
  arbg_dialog2 = arbg_dialog.show()
  local params = arbg_dialog2.getWindow().getAttributes();
  params.width = activity.width*7.5/9;
  arbg_dialog2.setCanceledOnTouchOutside(true);
  arbg_dialog2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radius,radius,radius,radius,radius,radius,radius,radius}).setColor(pc(background_color)))
  arbg_dialog2.getWindow().setAttributes(params);
  set_dialog_style(arbg_dialog2)
  function showArgbDialog()
    arbg_dialog2.show()
    updateArgb()
  end

  showArgbDialog()
  seek_bar_color(seek_bar_1,0xFF000000)
  seek_bar_color(seek_bar_2,0xFFFF0000)
  seek_bar_color(seek_bar_3,0xFF1DE9B6)
  seek_bar_color(seek_bar_4,0xFF6699FF)
end

--drawerlayout item light
function drawer_item_light(adp,table,item)
  adp.clear()
  for i,v in ipairs(ch_table) do
    if v=="divider"then
      adp.add{__type=4}
     elseif item==v[2] then
      adp.add{__type=3,iv={src=load_icon_path(v[2])},tv=v[1]}
     else
      adp.add{__type=2,iv={src=load_icon_path(v[2])},tv=v[1]}
    end
  end
end

--system print 系统打印
function system_print(content,view)
  local content = (gets(content) or content)
  if (view==false) then
    import "android.graphics.Typeface"
    local system_print_layout={
      LinearLayoutCompat;
      layout_width="-1";
      layout_height="-1";
      gravity="center";
      {
        CardView;
        layout_width="-1";
        layout_height="-2";
        Elevation="0";
        layout_marginBottom="12dp";
        layout_margin="8dp";
        radius="4dp";
        background="#FF202124";
        {
          LinearLayoutCompat;
          layout_width=activity.getWidth()-100;
          layout_height="-1";
          {
            TextView;
            layout_width="-1";
            layout_height="-1";
            textSize="14sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="12dp";
            Typeface=load_font("common");
            paddingBottom="12dp";
            gravity="center";
            Text=content;
            textColor="#ffffffff";
          };
        };
      };
    };
    Toast.makeText(activity,content,Toast.LENGTH_LONG).setGravity(Gravity.BOTTOM|Gravity.CENTER, 0, 0).setView(loadlayout(system_print_layout)).show()
   else
    local view = (view or home_framelayout or home_layout or current_show_view or activity.getDecorView())
    Snackbar.make(view,content,Snackbar.LENGTH_LONG)
  .setAnimationMode(Snackbar.ANIMATION_MODE_SLIDE)
    .show()
  end
end

--system popup 系统弹窗
function load_system_popup(item_click)
  local popup_layout={
    LinearLayoutCompat;
    {
      CardView;
      CardElevation="6dp";
      CardBackgroundColor=background_color;
      Radius="8dp";
      layout_width="-1";
      layout_height="-2";
      layout_margin="8dp";
      {
        GridView;
        layout_height="-1";
        layout_width="-1";
        NumColumns=1;
        id="popup_list";
      };
    };
  };

  --PopupWindow
  popup_window=PopupWindow(activity)
  popup_window.setContentView(loadlayout(popup_layout))
  popup_window.setWidth(dp2px(192))
  popup_window.setHeight(-2)
  popup_window.setOutsideTouchable(true)
  popup_window.setBackgroundDrawable(ColorDrawable(0x00000000))

  --PopupWindow列表项布局
  popup_list_item={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="48dp";
    {
      TextView;
      id="popadp_text";
      textColor=text_color;
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
      Typeface=load_font("common");
    };
  };
  popup_adp=LuaAdapter(activity,popup_list_item)
  popup_list.setAdapter(popup_adp)
  popup_list.setOnItemClickListener(AdapterView.OnItemClickListener{onItemClick=item_click})
  function add_popup_item(item_text)
    popup_adp.add{popadp_text=item_text}
  end
  function popup_dimiss()
    popup_window.dismiss()
  end
  function popup_show(id)
    popup_window.showAsDropDown(id)
  end
  return popup_window,popup_adp
end