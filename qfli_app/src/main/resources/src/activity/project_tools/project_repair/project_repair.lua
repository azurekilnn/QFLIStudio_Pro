set_style()
import "system.system_funlib"

project_dir=...
if project_dir then
  activity.setContentView(loadlayout('layout.layout_project_repair'))
 else
  activity.setContentView(loadlayout('layout.layout_project_repair_list'))
end

main_title_id.setText(gets("layout_project_repair"))
menu_img.setVisibility(8)
more_button.setVisibility(8)
back_img.setVisibility(0)
system_ripple({menu_button},"圆主题")

local init_template=[[
appname="%s"
appver="1.0 repaired"
appcode="1"
packagename="%s"
user_permission={
  "INTERNET",
  "WRITE_EXTERNAL_STORAGE",
}
]]

local build_template=[[appname="%s"
packagename="%s"
template="%s"]]

--添加工程
function add_project_item(adapter,path,name)
  local project_information={}
  build_information_file=path.."/build.lsinfo"
  init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file,"bt",project_information))
  local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  if not status_1 and status_2 then
    local app_name=project_information["appname"]
    local app_packagename=project_information["packagename"]
    local app_type=project_information["template"]
    error_information="build.lsinfo 工程配置文件缺失"
    adapter.add({app_icon_id=load_project_icon(path),app_name_id={text=app_name},app_packagename_id={text=app_packagename},app_type_id=app_type,project_path=path,project_abnormal_information_id=error_information})
   elseif status_1 and not status_2 then
    local app_name=project_information["appname"]
    local app_packagename=gets("unknown_packagename")
    local app_type=project_information["template"]
    adapter.add({app_icon_id=load_project_icon(path),app_name_id={text=app_name},app_packagename_id={text=app_packagename},app_type_id=app_type,project_path=path})
   elseif not status_1 and not status_2 then
    local app_name=gets("unknown_appname")
    local app_packagename=gets("unknown_packagename")
    local app_type=gets("unknown_template")
    if File(path.."/app/src/main/assets/main.lua").exists() then
      adapter.add({app_icon_id=load_project_icon(path),app_name_id={text=app_name},app_packagename_id={text=app_packagename},app_type_id=app_type,project_path=path})
    end
  end

end



--加载异常工程列表
local function load_abnormal_project_list(project_name)
  task(500,function()
    swipe_refresh_layout.setRefreshing(true);
  end)
  project_data={}
  project_list_item=import "layout.layout_items.layout_abnormal_project_list_item"
  project_list_adp=LuaAdapter(activity,project_data,project_list_item)
  project_repair_list.setAdapter(project_list_adp)

  project_dir=File(project_path)

  if project_dir.exists() then
    local lf=project_dir.listFiles()
    project_dir_table=luajava.astable(lf)
    --sort
    table.sort(project_dir_table,function(a2,b2)
      return (a2.isDirectory()~=b2.isDirectory() and a2.isDirectory()) or ((a2.isDirectory()==b2.isDirectory()) and a2.Name<b2.Name)
    end)

    for n=1,#project_dir_table do
      local load_project_path=project_path.."/"..project_dir_table[n].Name
      if File(load_project_path).isDirectory() then
        add_project_item(project_list_adp,load_project_path,project_name)
      end
    end
  end

  task(1000,function()
    swipe_refresh_layout.setRefreshing(false);
  end)
end

load_abnormal_project_list()

local function setting_common(content)
  content.app_name_id.textColor=pc(text_color)
  content.app_packagename_id.textColor=pc(get_theme_color("paratext_color"))
  content.itemParent.backgroundColor=pc(get_theme_color("background_color"))
  content.item.background=Ripple(nil,0x22000000)
end

local function search_item(content,text)
  if content.itemParent==nil then
    content.itemParent={}
  end
  if content.item==nil then
    content.item={}
  end
  setting_common(content)
end

local function ripple_setting(data,adapter)
  for index,content in pairs(data) do
    if content.app_name_id then
      search_item(content)
    end
  end
  adapter.notifyDataSetChanged()
end

ripple_setting(project_data,project_list_adp)

swipe_refresh_layout.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    ls = File(internal_storage).listFiles()
    if ls ~= nil then
      load_abnormal_project_list()
      ripple_setting(project_data,project_list_adp)
    end
  end})
swipe_refresh_layout.setColorSchemeColors({basic_color_num});

--工程信息对话框
function project_info(project_path)
  project_info_dialog_layout = import "layout.layout_dialogs.project_fix_dialog_layout"
  project_info_dialog=AlertDialog.Builder(this)
  project_info_dialog.setView(loadlayout(project_info_dialog_layout))
  project_info_dialog2=project_info_dialog.show()
  local params = project_info_dialog2.getWindow().getAttributes();
  params.width = activity.width*8/9;
  project_info_dialog2.setCanceledOnTouchOutside(false);
  project_info_dialog2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(pc(get_theme_color("background_color"))))
  project_info_dialog2.getWindow().setAttributes(params);

  project_information=read_project_info2(project_path)
  local app_name=project_information["appname"]
  local app_packagename=project_information["packagename"]
  local app_type=project_information["template"]
  local app_type=project_type[app_type]
  local app_version=project_information["appver"]

  project_info_dialog_icon_id.setImageBitmap(loadbitmap(load_project_icon(project_path)))
  project_info_dialog_name_id.setText(app_name)
  project_info_dialog_packagename_id.setText(app_packagename)
  --project_info_dialog_type_id.setText(app_type)
  --project_info_dialog_project_path.setText(project_path.."/")
  project_info_dialog_version_id.setText(app_version)

  local app_type_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(app_type_table))
  app_type_list.setAdapter(app_type_adp)

end

project_repair_list.onItemClick=function(p,v,i,s)
  local project_path=(v.Tag.project_path.Text)
  project_info(project_path)
end