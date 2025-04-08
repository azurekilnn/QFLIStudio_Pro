set_style()
load_system_incidents()
lua_editor=custom_editor("editor","SoraEditor",nil)
function load_shared_codes(values)
  if values then
    title=values[1]
    content=values[2]
  end

  main_title_id.setText(gets("lua_course"))
  if title and content then
    main_title_id.setText(title)
    editor.setText(content)
  end
  system_ripple({menu_button,redo_button,menu_back_button,back_button},"circular_theme")
  system_ripple({menu_button,layout_helper_button,play_button,more_button,undo_button},"circular_theme")
  system_ripple({cancel_button,select_all_button,cut_button,copy_button,paste_button,preview_button},"circular_theme")
  control_bar_title.setText(gets("choose_text"))
  func={}
  func.redo = function()
    editor.redo()
  end
  func.undo = function()
    editor.undo()
  end
  func.selectAll = function()
    editor.selectAll()
  end
  func.cut = function()
    editor.cut()
  end
  func.copy = function()
    editor.copy()
  end
  func.paste = function()
    editor.paste()
  end

  cut_button.onClick=func.cut
  select_all_button.onClick=func.selectAll
  undo_button.onClick=func.undo
  redo_button.onClick=func.redo
  copy_button.onClick=func.copy
  paste_button.onClick=func.paste
  cancel_button.onClick=function()
    tool_bar_id.setVisibility(0)
    control_bar_id.setVisibility(8)
  end

editor.getTextActionWindow().setEnabled(true)

  --[[editor选中监听事件
  editor.OnSelectionChangedListener=function(status,Start,End)
    if status == true then
      tool_bar_id.setVisibility(8)
      control_bar_id.setVisibility(0)
     else
      tool_bar_id.setVisibility(0)
      control_bar_id.setVisibility(8)
    end
  end]]

  --返回按钮
  menu_button.setVisibility(0)
  redo_button.setVisibility(0)
  undo_button.setVisibility(0)
  opened_file.setVisibility(8)
  layout_helper_button.setVisibility(8)
  folder_button.setVisibility(8)
  menu_img.setVisibility(8)
  menu_back_button.setVisibility(0)
  --搜索按钮
  play_button.setVisibility(8)

  more_button.setVisibility(8)

end
--editor_assembly
if not dlg_mode then
  title,content=...
  content_view={
    LinearLayoutCompat;
    orientation='vertical';
    layout_width='fill';
    layout_height='fill';
    backgroundColor=get_theme_color("background_color");
    {
      LinearLayoutCompat;
      layout_width='fill';
      layout_height='fill';
      lua_editor;
    };
  };

  setCommonView(content_view,title,"editor_top_bar")
  load_shared_codes()
  --pcall(load_shared_codes)
 else
  current_dialog_type="white_dialog"
  content_view2={
    LinearLayoutCompat;
    orientation='vertical';
    layout_width='fill';
    layout_height='fill';
    backgroundColor=get_theme_color("background_color");
    {
      LinearLayoutCompat;
      layout_width='fill';
      layout_height='fill';
      lua_editor;
    };
  };

  content_view={
    LinearLayoutCompat;
    layout_height="fill";
    layout_width="fill";
    orientation="vertical";
    backgroundColor=get_theme_color("background_color");
  };
  import "layout.layout_table.layout_assembly"
  content_view = loadlayout(content_view)
  local editor_control_bar = layout_assembly["editor_control_bar"]
  local editor_top_bar = layout_assembly["editor_top_bar"]
  local editor_top_bar=loadlayout(editor_top_bar)
  local editor_control_bar=loadlayout(editor_control_bar)
  content_view.addView(editor_top_bar)
  content_view.addView(editor_control_bar)
  content_view.addView(loadlayout(content_view2))
end