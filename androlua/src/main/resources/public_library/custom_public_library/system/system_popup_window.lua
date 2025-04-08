popup_layout={
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
pop_adp=LuaAdapter(activity,popup_list_item)
popup_list.setAdapter(pop_adp)
popup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    popup_window.dismiss()
    local item_text=(v.Tag.popadp_text.Text)
    system_incident[item_incident[item_text]]()
  end
})
function add_popup_item(item_text)
  popup_adp.add{popadp_text=item_text}
end
function popup_dimiss()
  popup_window.dismiss()
end
function popup_show(id)
  popup_window.showAsDropDown(id)
end