--Only Method

--语言
function get_resources_strings(value)
  return activity.getResources().getString(value)
end

function read_resources_string(value)
  local r_string_key=R.string[value]
  local r_string=get_resources_strings(r_string_key)
  return r_string
end

function read_strings_table_old(value)
  if system_strings[value] then
    return system_strings[value]
   else
    --system_print("Cannot find String "..value)
    return value
  end
end

function check_strings_table(value)
  if system_strings[value] then
    return system_strings[value]
   else
    --system_print("Cannot find String "..value)
    return false
  end
end

function write_local_table(path,name,content)
  if content then
    local content=name.."="..dump(content)
    WriteFile(path,content)
  end
end

function get_string(value)
  if (check_strings_table(value)==false) then
    local status,str=pcall(read_resources_string,value)
    if status then
      --system_strings[value]=str
      --write_local_table(system_strings_memory_filepath,"system_strings",system_strings)
      return str
     else
      return value
    end
   else
    return check_strings_table(value)
  end
end

function gets(value)
  return get_string(value)
end

system_strings={}

system_strings["save_failed_tips"]="保存出错"
system_strings["add_symbol_dialog_title"]="添加符号"
system_strings["symbol"]="符号"
