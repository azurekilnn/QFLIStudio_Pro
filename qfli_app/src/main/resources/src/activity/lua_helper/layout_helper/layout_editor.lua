import "loadlayout2"
import "loadlayout3"
require "layout_helper_funlib"
import "layout.layout_table.editor_assembly"

tool_bar=editor_assembly["tool_bar"]
control_bar=editor_assembly["control_bar"]

editor_layout={
  FrameLayout;
  layout_width="fill";
  layout_height="fill";
  {
    LinearLayoutCompat;
    orientation="vertical" ,
    tool_bar;
    control_bar;
    {
      LuaEditor,
      id="editor",
      layout_width="fill",
      textColor=text_color;
      layout_height="fill",
      backgroundColor=get_theme_color("background_color"),
      layout_weight=1,
    },
    {
      LinearLayoutCompat;
      layout_width="fill",
      Visibility="8";
      {
        Button,
        text=gets("convert_text"),
        textColor=basic_color_num;
        backgroundColor=get_theme_color("background_color"),
        layout_width="fill",
        layout_weight=1,
        onClick ="click",
      } ,
      {
        Button,
        text=gets("preview"),
        textColor=basic_color_num;
        backgroundColor=get_theme_color("background_color"),
        layout_width="fill",
        layout_weight=1,
        onClick ="click2",
      } ,
      {
        Button,
        text=gets("copy"),
        textColor=basic_color_num;
        backgroundColor=get_theme_color("background_color"),
        layout_width="fill",
        layout_weight=1,
        onClick ="click3",
      } ,
      {
        Button,
        text=gets("ok_button"),
        textColor=basic_color_num;
        backgroundColor=get_theme_color("background_color"),
        layout_width="fill",
        layout_weight=1,
        onClick ="click4",
      } ;
    };
  };
  {
    CardView;
    layout_gravity="bottom|right";
    layout_width="56dp";
    layout_margin="16dp";
    --layout_marginRight="104dp";
    layout_height="56dp";
    radius="28dp";
    {
      LinearLayoutCompat;
      layout_width="fill";
      gravity="center";
      layout_height="fill";
      id="preview_button";
      {
        ImageView;
        layout_width="24dp";
        colorFilter=basic_color_num;
        layout_height="24dp";
        src=editor_icons("play");
        --src="add.png";    
      };
    };
  };
};



activity.setContentView(loadlayout(editor_layout))
activity.setTitle(gets("layout_editor_title"))
main_title_id.setText("  "..gets("layout_editor_title"))
editor_setColor(editor)
content=...
if content then
  editor.setText(content)
end

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

--editor选中监听事件
editor.OnSelectionChangedListener=function(status,Start,End)
  if status == true then
    ed = End
    tool_bar_id.setVisibility(8)
    control_bar_id.setVisibility(0)
   else
    tool_bar_id.setVisibility(0)
    control_bar_id.setVisibility(8)
  end
end

system_ripple({menu_button,layout_helper_button,play_button,more_button,undo_button},"圆主题")
system_ripple({cancel_button,select_all_button,cut_button,copy_button,paste_button,preview_button},"圆主题")
menu_button.setVisibility(8)
opened_file.setVisibility(8)
layout_helper_button.setVisibility(8)

--play_img.setImageBitmap(loadbitmap(editor_icons("undo")))
--undo_img.setImageBitmap(loadbitmap(editor_icons("redo")))

setImage(play_img,editor_icons("undo"))
setImage(undo_img,editor_icons("redo"))


cut_button.onClick=system_incident.cut
select_all_button.onClick=system_incident.selectAll
play_button.onClick=system_incident.undo
undo_button.onClick=system_incident.redo
copy_button.onClick=system_incident.copy
paste_button.onClick=system_incident.paste
cancel_button.onClick=function()
  tool_bar_id.setVisibility(0)
  control_bar_id.setVisibility(8)
end
preview_button.onClick=function()
  click2()
end

more_button.onClick=function()
  popup_show(more_lay)
end


item_click=function(p,v,i,s)
  item_func={
    [gets("save")]=function()
      click4()
    end,
    [gets("xml_2_aly")]=function()
      click()
    end
  }
  popup_dimiss()
  local item_text=v.Tag.popup_item_text.Text
  item_func[item_text]()
end

load_system_popup(item_click)
add_popup_item(gets("xml_2_aly"))
add_popup_item(gets("save"))