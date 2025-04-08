set_style()
content_view={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  backgroundColor=gray_color;
  {
    ListView;
    layout_width="fill";
    layout_height="fill";
    backgroundColor=gray_color;
    layout_margin="10dp";
    id="clist";
    DividerHeight="0";
    FastScrollEnabled=false;
  };
};

java_api_item_layout={
  LinearLayoutCompat;
  layout_width='fill';
  layout_height='wrap';
  backgroundColor=gray_color;
  {
    CardView;
    layout_width="fill";
    backgroundColor=card_background_color;
    layout_height="wrap";
    layout_margin="5dp";
    Elevation='0';
    radius="8dp";
    {
      TextView,
      layout_height="fill";
      layout_margin="12dp";
      textSize="13sp",
      id="content";
      textColor=text_color;
    };
  };
};


--[[FileProviderRegistry.getInstance().tryGetInputStream("textmate/quietlight.json")
theme=ThemeModel(IThemeSource.fromInputStream(, "textmate/quietlight.json", null), "quietlight")
]]

function load_shared_codes()
  --2023-01-26
  classes=import("android_libs")

  --[[function adapter(t)
  local ls=ArrayList()
  for k,v in ipairs(t) do
    ls.add(v)
  end
  return ArrayAdapter(activity,android.R.layout.simple_list_item_1, ls)
end]]

  function java_api_adapter(t)
    local ls=LuaAdapter(activity,java_api_item_layout)
    for k,v in ipairs(t) do
      ls.add({content=v})
    end
    return ls
  end

  clist.setAdapter(java_api_adapter(classes))
  clist.onItemClick=function(p,v,i,s)
    SkipPage("java_api_sub_browser",{v.Tag.content.Text})
  end
  clist.onItemLongClick=function(p,v,i,s)
    local s=tostring(v.Tag.content.Text)
    activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(s)
    system_print(gets("copy_tip"))
    return true
  end

  --搜索栏
  search_bar_search_button.setVisibility(8)

  search_bar_edit.setHint(gets("search_api_tip"))
  search_bar_edit.addTextChangedListener{
    onTextChanged=function(text)
      local search_key=tostring(text)
      if #search_key==0 then
        clist.setAdapter(java_api_adapter(classes))
      end
      local t={}
      for k,v in ipairs(classes) do
        local search_key=output_search_key(search_key)
        local v2=output_search_key(v)
        if v2:find(search_key,1,true) then
          table.insert(t,v)
        end
      end
      clist.setAdapter(java_api_adapter(t))
    end
  }
end

if not dlg_mode then
  setCommonView(content_view,"java_api_title","back_with_search_mode")
  load_shared_codes()
end