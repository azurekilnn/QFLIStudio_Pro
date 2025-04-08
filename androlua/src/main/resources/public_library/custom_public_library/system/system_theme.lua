--Only Method

--editor data
function load_editor_color_data()
  --editor colors
  if theme_data and theme_data["editor"] then
    editor_colors_data = theme_data["editor"]
    baseword_color = editor_colors_data["baseword_color"]
    keyword_color = editor_colors_data["keyword_color"]
    comment_color = editor_colors_data["comment_color"]
    userword_color = editor_colors_data["userword_color"]
    string_color = editor_colors_data["string_color"]
    editor_text_color = editor_colors_data["editor_text_color"]
  end
end

function load_theme_data(value)
  theme_style=value
  theme_setting="defalut"

  --[[edrawable = GradientDrawable()
  edrawable.setShape(GradientDrawable.RECTANGLE)
  edrawable.setColor(0xffffffff)
  edrawable.setCornerRadii({dp2px(8),dp2px(8),dp2px(8),dp2px(8),dp2px(8),dp2px(8),dp2px(8),dp2px(8)});]]

  if value=="night_time" then
    --edrawable.setStroke(2, 0xffffffff,0,0)
   elseif value=="day_time" then
    --edrawable.setStroke(2, 0x21212121,0,0)
   else
    theme_style="day_time"
    theme_setting="custom"
    --edrawable.setStroke(2, 0x21212121,0,0)
  end

  quiet_light_path=activity.getLuaDir().."/system/editor/quiet_light.json"
  quiet_dark_path=activity.getLuaDir().."/system/editor/quiet_dark.json"
  if (theme_value and theme_value=="night_time") then
    editor_theme_file_path=quiet_dark_path
   else
    editor_theme_file_path=quiet_light_path
  end

  if colors_data then
   else
    colors_data = config["colors"]
  end

  theme_data = colors_data[theme_style]

  function get_theme_color(color_key)
    if color_key=="white_color" then
      return "#ffffffff"
  else
    return (theme_data[color_key] or "")
  end
  end

  background_color = theme_data["background_color"]
  theme_manager = activity.getThemeManager()
  basic_color = theme_data["basic_color"]
  basic_color_num=theme_manager.getColorPrimary()
  --status_bar_color=background_color
  status_bar_color=theme_data["tool_bar_color"]
  navigation_bar_color=background_color

  text_color = theme_data["text_color"]
  paratext_color_num=pc(theme_data["paratext_color"])
  gray_color = theme_data["gray_color"]
  card_background_color = theme_data["card_background_color"]
  viewshader_color = theme_data["viewshader_color"]

  white_color="#ffffffff"
  error_tips_text_color="#ffff0000"

  light_basic_color_num=change_color_strength(44,basic_color_num)
  search_results_background_color=light_basic_color_num

  translucent_background_color=change_color_strength("EE",pc(background_color))
  drawer_item_checked_background = GradientDrawable().setShape(GradientDrawable.RECTANGLE).setColor(parseColor(basic_color)-0xde000000).setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});
end

local new_themes={
  "Theme_LuaStudio",
  "Theme_LuaStudio_Red",
  "Theme_LuaStudio_Pink",
  "Theme_LuaStudio_Purple",
  "Theme_LuaStudio_Indigo",
  "Theme_LuaStudio_LightBlue",
  "Theme_LuaStudio_Cyan",
  "Theme_LuaStudio_Teal",
  "Theme_LuaStudio_Green",
  "Theme_LuaStudio_LightGreen",
  "Theme_LuaStudio_Lime",
  "Theme_LuaStudio_Yellow",
  "Theme_LuaStudio_Amber",
  "Theme_LuaStudio_Orange",
  "Theme_LuaStudio_DeepOrange",
  "Theme_LuaStudio_Brown",
  "Theme_LuaStudio_Grey",
  "Theme_LuaStudio_BlueGrey",
  "Theme_LuaStudio_White"
}

function set_theme(value)
  --local theme_selected=(getSharedData("theme_selected") or 1)
  --activity.setTheme(R.style[new_themes[theme_selected]])
  --白色状态栏高亮
  -- if ((value=="day_time") and (sdk_version>=23) and (status_bar_color) and (tostring(pc(status_bar_color))=="-1")) then
  --   activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
  -- end
  --隐藏标题栏
  -- pcall(function()activity.getActionBar().hide()end)
  -- pcall(function()activity.getSupportActionBar().hide()end)
  --get_theme_color()

  -- local array = activity.getTheme().obtainStyledAttributes({
  --   android.R.attr.colorPrimary,
  -- });

  theme_manager = activity.getThemeManager()
  basic_color_num=theme_manager.getColorPrimary()
  set_status_bar_color(status_bar_color)
  set_navigation_bar_color(navigation_bar_color)
end