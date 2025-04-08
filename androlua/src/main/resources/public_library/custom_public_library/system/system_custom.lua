import {
  "android.graphics.Typeface",
  "java.io.File"
}
--个性化库（图标/字体）
--检查资源路径
local function check_res_path(data)
  for index,content in pairs(data) do
    if (File(content).exists()) then
      return true,content
    end
  end
end

-- font --
-- load_font_path
function load_font_path(value)
  if fonts_data[value .. "_font"] then
    local fonts_path=activity.getCustomDir()..fonts_data[value .. "_font"]
    if File(fonts_path).exists() then
      return fonts_path
     else
      return false
    end
   else
    return false
  end
end
-- load_font_file
function load_font_file(path)
  if path==false then
    return Typeface.DEFAULT
   else
    return Typeface.createFromFile(File(path))
  end
end
-- load font res
local function load_font_res(value)
  local font_path=fonts_data[value .. "_font"] or nil
  if font_path and type(font_path)=="string" then
    local font_paths={
      font_path,
      activity.getCustomDir()..font_path
    }
    local status,path=check_res_path(font_paths)
    return Typeface.createFromFile(File(path))
   else
    return Typeface.DEFAULT
  end
end

-- load_font
function load_font(value)
  if value and custom_mode then
    return load_font_res(value)
   else
    if value=="editor" then
      return Typeface.MONOSPACE
     elseif value=="bold" then
      return Typeface.DEFAULT_BOLD
     else
      return Typeface.DEFAULT
    end
  end
end

function load_textsize(value)
  local function textsize_mode()
    if layout_textsize_focus then
      return "dp"
     else
      return "sp"
    end
  end
  if type(value)=="string" then
    if value:find("sp") or value:find("dp") then
      local value=value:gsub("sp",""):gsub("dp","")..textsize_mode()
      return (value)
     else
      return value
    end
   elseif type(value)=="number" then
    local value=tostring(value)..textsize_mode()
    return (value)
   else
    return ""
  end
end

-- system_icon
function load_icon_path(value)
  local luaCustomDir=activity.getCustomDir()
  local luaDir=activity.getLuaDir()
  local situations_path
  if icons_data[value .. "_icon"] then
    situations_path={
      icons_data[value .. "_icon"],
      icons_data[value .. "_icon"]:gsub(".png",".lsicon");
      luaCustomDir..icons_data[value .. "_icon"],
      luaCustomDir..icons_data[value .. "_icon"]:gsub(".png",".lsicon");
      luaCustomDir.."/res/icons/twotone_"..value.."_black_24dp.png",
      luaCustomDir.."/res/icons/twotone_"..value.."_black_24dp.lsicon",
      luaDir.."/res/icons/twotone_"..value.."_black_24dp.png",
      luaDir.."/res/icons/twotone_"..value.."_black_24dp.lsicon",
      luaDir.."/res/unknown.png",
    }
   else
    situations_path={
      luaCustomDir .. "/res/icons/twotone_"..value.."_black_24dp.png",
      luaCustomDir .. "/res/icons/twotone_"..value.."_black_24dp.lsicon",
      luaDir .. "/res/icons/twotone_"..value.."_black_24dp.png",
      luaDir .. "/res/icons/twotone_"..value.."_black_24dp.lsicon",
      luaDir.."/res/unknown.png"
    }
  end
  local status,path=check_res_path(situations_path)
  if status then
    return path
   else
    return ""
  end
end

function editor_icons(value)
  local luaCustomDir=activity.getCustomDir()
  local luaDir=activity.getLuaDir()
  local situations_path

  if editor_icons_data and editor_icons_data[value] then
    situations_path={
      editor_icons_data[value],
      editor_icons_data[value]:gsub(".png",".lsicon");
      luaCustomDir..editor_icons_data[value],
      luaCustomDir..editor_icons_data[value]:gsub(".png",".lsicon");
      luaCustomDir.."/res/editor_icons/ic_"..value..".png",
      luaCustomDir.."/res/editor_icons/ic_"..value..".lsicon",
      luaDir.."/res/editor_icons/ic_"..value..".png",
      luaDir.."/res/editor_icons/ic_"..value..".lsicon",
      luaDir.."/res/unknown.png",
    }
   else
    situations_path={
      luaCustomDir.."/res/editor_icons/ic_"..value..".png",
      luaCustomDir.."/res/editor_icons/ic_"..value..".lsicon",
      luaDir.."/res/editor_icons/ic_"..value..".png",
      luaDir.."/res/editor_icons/ic_"..value..".lsicon",
      luaDir.."/res/unknown.png",
    }
  end
  local status,path=check_res_path(situations_path)
  if status then
    return path
   else
    return ""
  end
end