set_style()
setCommonView("layout","文件管理","back_with_more_mode")
import "android.text.format.Formatter"
import "android.text.format.DateUtils"

local AdapterCreator=luajava.bindClass("com.luastudio.azure.adapter.AdapterCreator")
local LuaRecyclerAdapter=luajava.bindClass("com.luastudio.azure.adapter.LuaRecyclerAdapter")
local LuaRecyclerHolder=luajava.bindClass("com.luastudio.azure.adapter.LuaRecyclerHolder")
local file_list_item=import("layout.layout_items.layout_filelist_item")

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
      local file_object=data["file"]
      local file_info=data["file_info"]
      local file_name=file_object["name"]

      if file_info then
        views.file_size.setText(file_info)
      end
      views.file_name.setText(file_name)
      views.file_img.setColorFilter(basic_color_num)
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
      system_ripple({views.root_file_item},"square_adaptive")
    end,
  }))

  return adapter,adapter_data
end


files_adapter,files_adapter_data=init_files_adpater()
local layout_manager = LinearLayoutManager(activity, RecyclerView.VERTICAL, false);
filelist_rv_1.setLayoutManager(layout_manager)
filelist_rv_1.setAdapter(files_adapter)
files_adapter_2,files_adapter_data_2=init_files_adpater()
local layout_manager_2 = LinearLayoutManager(activity, RecyclerView.VERTICAL, false);
filelist_rv_2.setLayoutManager(layout_manager_2)
filelist_rv_2.setAdapter(files_adapter_2)


function check_filelist_icon(icons,file)
  local file_is_directory=file.isDirectory()
  if file_is_directory then
    local file_icon=(file_is_directory and llfolder_img)
    return true,file_icon
   else
    for index,content in pairs(icons) do
      local file_name=file["name"]
      if file_name:find(index) then
        return true,content
      end
    end
  end
end
load_filelist_icons()
lfile_img=load_icon_path("description")
lpho_img=load_icon_path("photo")
lother_file_img=load_icon_path("insert_drive_file")
filelist_icons={}
filelist_icons["%.lua$"]=lllua_file_img
filelist_icons["%.aly$"]=llaly_file_img
filelist_icons["%.java$"]=lljava_file_img
filelist_icons["%.html$"]=llhtml_file_img
filelist_icons["%.css$"]=llcss_file_img


function sort_filelist(file_list,sort_method)
  SortFunctions={
    --名称（升序）
    function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
    end,
    --"名称（降序）
    function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name>b.Name)
    end,
    --时间（升序）
    function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.lastModified()<b.lastModified())
    end,
    --时间（降序）
    function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.lastModified()>b.lastModified())
    end,
  }
  table.sort(file_list,SortFunctions[sort_method])
end

function load_file_item(item)
  local file_name=item["name"]
  local sizes=Formatter.formatFileSize(activity,item.length())
  local last_modified=item.lastModified()
  local time=DateUtils.getRelativeTimeSpanString(last_modified,System.currentTimeMillis(),DateUtils.MINUTE_IN_MILLIS,DateUtils.FORMAT_SHOW_TIME|DateUtils.FORMAT_SHOW_DATE|DateUtils.FORMAT_ABBREV_ALL)

  local s2=time
  if item.isFile() then
    s2=s2.."  | "..sizes
  end
  return {file=item,file_name=file_name,file_info=s2}
end
sort_method=1

function load_file_list(adapter,data,dir,show_hidden,reload,srl)
  if reload then
    table.clear(data)
    srl.setRefreshing(true);
  end
  local this_list_files_data={}
  local list_files=File(dir).listFiles()
  if list_files~=nil then
    local list_files_data=luajava.astable(list_files)
    sort_filelist(list_files_data,sort_method)
    for k,v in pairs(list_files_data) do
      if (not(v.isHidden()) or show_hidden) then
        table.insert(this_list_files_data,v)
      end
    end
    for k,v in pairs(this_list_files_data) do
      table.insert(data,load_file_item(v))
    end
    adapter.notifyDataSetChanged()
  end
  if reload then
    srl.setRefreshing(false);
  end
end

file_list_1_path=internal_storage
file_list_2_path=internal_storage

main_handler_run(function()
  load_file_list(files_adapter,files_adapter_data,file_list_1_path,true)
  load_file_list(files_adapter_2,files_adapter_data_2,file_list_2_path,true)
end,50)

filelist_rv_1.onTouch=function()
  filelist_cardview_1.setCardElevation(10)
  filelist_cardview_2.setCardElevation(0)
end
filelist_rv_2.onTouch=function()
  filelist_cardview_1.setCardElevation(0)
  filelist_cardview_2.setCardElevation(10)
end

filelist_refresh_layout_1.setColorSchemeColors({basic_color_num});
filelist_refresh_layout_1.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    load_file_list(files_adapter,files_adapter_data,file_list_1_path,true,true,filelist_refresh_layout_1)
  end
})

filelist_refresh_layout_2.setColorSchemeColors({basic_color_num});
filelist_refresh_layout_2.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    load_file_list(files_adapter_2,files_adapter_data_2,file_list_2_path,true,true,filelist_refresh_layout_2)
  end
})
