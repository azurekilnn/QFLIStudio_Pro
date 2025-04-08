-- load all projects method
--检测 main.lua是否存在
local function check_main_file_exists(path)
  if (File(path.."/build.lsinfo").exists() and File(path.."/app/src/main/assets/main.lua").exists()) then
    return true
   else
    return false
  end
end
local function check_error_proj_exists(path)
  if (File(path.."/build.lsinfo").exists() and File(path.."/src/assets/main.lua").exists()) then
    return true
   else
    return false
  end
end

--读取工程信息
local function read_project_info(path)
  local project_information={}
  local build_information_file=path.."/build.lsinfo"
  --local init_information_file=path.."/app/src/main/assets/init.lua"
  local status_1=pcall(loadfile(build_information_file))
  --local status_2=pcall(loadfile(init_information_file,"bt",project_information))
  --local status_3=pcall(loadfile(build_information_file,"bt",project_information))

  --if status_1 and status_2 and status_3 then
  if status_1 then
    --status_3 必为 true
    if build_info then
      local project_information=build_info
      build_info=nil
      return project_information
    end
  end
end
local function check_icon_path(paths)
  for index,content in ipairs(paths) do
    if File(content).exists() then
      return content
    end
  end
end

--load project icon
function load_project_icon(path)
  local icon_paths={
    path.."/app/src/main/assets/icon.png",
    activity.getLuaDir() .. "/icon.png",
    --activity.getCustomDir() .. "/res/icons/icon.png",
    --activity.getCustomDir() .. "/res/icons/icon.lsicon",
    --activity.getLuaDir() .. "/res/icons/icon.png"
  }
  return check_icon_path(icon_paths)
end

--添加项目
function add_project_item(data,path)--(adapter,path,name)
  if path and check_main_file_exists(path) then
    local project_information=read_project_info(path)
    local app_name=project_information["appname"]
    local app_packagename=project_information["packagename"]
    local app_type=project_information["template"]
    table.insert(data,{project_icon=load_project_icon(path),project_name=app_name,project_packagename=app_packagename,project_type=app_type,project_path=path})
  end
end
--添加项目
function add_error_project_item(data,path)--(adapter,path,name)
  if path and check_error_proj_exists(path) then
    local project_information=read_project_info(path)
    local app_name=project_information["appname"]
    local app_packagename=project_information["packagename"]
    local app_type=project_information["template"]
    table.insert(data,{project_icon=load_project_icon(path),project_name=app_name,project_packagename=app_packagename,project_type=app_type,project_path=path})
  end
end

--遍历所有工程信息
function load_all_projects_info(reload)
  if reload then
    if projects_info_table then
      table.clear(projects_info_table)
     else
      projects_info_table={}
    end
    --遍历所有工程
    local project_dir=File(project_path)
    if project_dir.exists() then
      local lf=project_dir.listFiles()
      local project_dir_table=luajava.astable(lf)
      local item_num=#project_dir_table
      if item_num==0 then
       else
        table.sort(project_dir_table,function(a2,b2)
          return (a2.isDirectory()~=b2.isDirectory() and a2.isDirectory()) or ((a2.isDirectory()==b2.isDirectory()) and a2.Name<b2.Name)
        end)
        for n=1,#project_dir_table do
          if project_dir_table[n].isDirectory() then
            local load_project_path=project_dir_table[n].path
            add_project_item(projects_info_table,load_project_path)
          end
        end
        write_local_table(projects_memory_filepath,"projects_info_table",projects_info_table)
      end
    end
   else
    if pcall(dofile,projects_memory_filepath) then
      local project_dir=File(project_path)
      if project_dir.exists() then
        local lf=project_dir.listFiles()
        local project_dir_table=luajava.astable(lf)
        local item_num=#project_dir_table
        if projects_info_table and #projects_info_table==#project_dir_table then
         else
          load_all_projects_info(true)
        end
      end
     else
      load_all_projects_info(true)
    end
  end
end
--遍历所有工程信息
function load_all_error_projects_info(reload)
  if reload then
    if error_projects_info_table then
      table.clear(error_projects_info_table)
     else
      error_projects_info_table={}
    end
    --遍历所有工程
    local project_dir=File(activity.getLuaExtDir("project"))
    if project_dir.exists() then
      local lf=project_dir.listFiles()
      local project_dir_table=luajava.astable(lf)
      local item_num=#project_dir_table
      if item_num==0 then
       else
        table.sort(project_dir_table,function(a2,b2)
          return (a2.isDirectory()~=b2.isDirectory() and a2.isDirectory()) or ((a2.isDirectory()==b2.isDirectory()) and a2.Name<b2.Name)
        end)
        for n=1,#project_dir_table do
          if project_dir_table[n].isDirectory() then
            local load_project_path=project_dir_table[n].path
            add_error_project_item(error_projects_info_table,load_project_path)
          end
        end
        write_local_table(error_projects_memory_filepath,"error_projects_info_table",error_projects_info_table)
      end
    end
   else
    if pcall(dofile,error_projects_memory_filepath) then
      local project_dir=File(activity.getLuaExtDir("project"))
      if project_dir.exists() then
        local lf=project_dir.listFiles()
        local project_dir_table=luajava.astable(lf)
        local item_num=#project_dir_table
        if error_projects_info_table and #error_projects_info_table==#project_dir_table then
         else
          load_all_error_projects_info(true)
        end
      end
     else
      load_all_error_projects_info(true)
    end
  end
end

function reload_all_error_projects_info()
  load_all_error_projects_info(function()end,true)

end

function load_local_projects_list(func,reload)
  projects_info_table={}
  table.clear(projects_data)
  load_all_projects_info(reload)

  if projects_info_table and #projects_info_table~=0 then
    for index,content in ipairs(projects_info_table) do
      table.insert(projects_data,content)
    end
    projects_rv_adapter.notifyDataSetChanged()
    empty_tips.setVisibility(8)
    project_list_background.setVisibility(0)
    progress_bar_background.setVisibility(8)
    if func then
      pcall(func)
    end
   else
    empty_tips.setVisibility(0)
    project_list_background.setVisibility(8)
    progress_bar_background.setVisibility(8)
  end
end

function reload_project_list()
  load_local_projects_list(function()end,true)
end

function load_error_projects_list(func,reload)
  error_projects_info_table={}
  table.clear(error_projects_data)
  load_all_error_projects_info(reload)

  if error_projects_info_table and #error_projects_info_table~=0 then
    for index,content in ipairs(error_projects_info_table) do
      table.insert(error_projects_data,content)
    end
    error_projects_rv_adapter.notifyDataSetChanged()
    projects_empty_2.setVisibility(8)
    error_projects_list_background.setVisibility(0)
    projects_pg_2_background.setVisibility(8)
    if func then
      pcall(func)
    end
   else
    projects_empty_2.setVisibility(0)
    error_projects_list_background.setVisibility(8)
    projects_pg_2_background.setVisibility(8)
  end
end