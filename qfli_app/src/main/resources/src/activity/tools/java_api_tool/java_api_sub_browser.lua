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
    id="mlist";
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

--2023-01-26
classes=import("android_libs")

function load_shared_codes(values)
  value=values[1]

  function java_api_sub_adapter(t)
    local ls=LuaAdapter(activity,java_api_item_layout)
    for k,v in ipairs(t) do
      ls.add({content=v})
    end
    return ls
  end

  if value then

    setWinTitle(value)

    local s=tostring(value)
    local class=luajava.bindClass(s)
    curr_class=class
    local t={}
    local fs={}
    local ms={}
    local es={}
    local ss={}
    local gs={}
    local super=class.getSuperclass()
    super=super and " extends "..tostring(super.getName()) or ""
    table.insert(t,tostring(class)..super)

    table.insert(t,gets("construction_method"))
    local cs=class.getConstructors()
    for n=0,#cs-1 do
      table.insert(t,tostring(cs[n]))
    end

    curr_ms=class.getMethods()
    for n=0,#curr_ms-1 do
      local str=tostring(curr_ms[n])
      table.insert(ms,str)
      local e1=str:match("%.setOn(%a+)Listener")
      local s1,s2=str:match("%.set(%a+)(%([%a$%.]+%))")
      local g1,g2=str:match("([%a$%.]+) [%a$%.]+%.get(%a+)%(%)")
      if e1 then
        table.insert(es,"on"..e1)
       elseif s1 then
        table.insert(ss,s1..s2)
      end
      if g1 then
        table.insert(gs,string.format("(%s)%s",g1,g2))
      end
    end
    table.insert(t,gets("public_incident"))
    for k,v in ipairs(es) do
      table.insert(t,v)
    end
    table.insert(t,gets("public_getter"))
    for k,v in ipairs(gs) do
      table.insert(t,v)
    end
    table.insert(t,gets("public_setter"))
    for k,v in ipairs(ss) do
      table.insert(t,v)
    end

    curr_fs=class.getFields()
    table.insert(t,gets("pubilc_field"))
    for n=0,#curr_fs-1 do
      table.insert(t,tostring(curr_fs[n]))
    end

    table.insert(t,gets("public_method"))
    for k,v in ipairs(ms) do
      table.insert(t,v)
    end
    curt_adapter=java_api_sub_adapter(t)
    mlist.setAdapter(curt_adapter)
  end

  mlist.onItemLongClick=function(l,v)
    local s=tostring(v.Tag.content.Text)
    if s:find("%w%(") then
      s=s:match("(%w+)%(")
     else
      s=s:match("(%w+)$")
    end
    activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(s)
    system_print(gets("copy_tip"))
    return true
  end
  --搜索栏
  search_bar_search_button.setVisibility(8)

  search_bar_edit.setHint(gets("search_api_tip"))
  search_bar_edit.addTextChangedListener{
    onTextChanged=function(c)
      local search_key=tostring(c)
      if #search_key==0 then
        mlist.setAdapter(curt_adapter)
        return true
      end
      local class=curr_class
      local t={}
      local fs=curr_fs
      table.insert(t,gets("pubilc_field"))

      local search_key=output_search_key(search_key)

      for n=0,#fs-1 do
        local v=output_search_key(fs[n]["Name"])
        if v:find(search_key,1,true) then
          table.insert(t,tostring(fs[n]))
        end
      end
      local ms=curr_ms
      table.insert(t,gets("public_method"))
      for n=0,#ms-1 do
        local v=output_search_key(ms[n]["Name"])
        if v:find(search_key,1,true) then
          table.insert(t,tostring(ms[n]))
        end
      end

      mlist.setAdapter(java_api_sub_adapter(t))
    end
  }
end

if not dlg_mode then
  function setWinTitle(title)
    setWindowTitle(title)
  end
  value=...
  values={value}
  setCommonView(content_view,"java_api_title","back_with_search_mode")
  pcall(load_shared_codes,values)
end

--[[function adapter(t)
  local ls=ArrayList()
  for k,v in ipairs(t) do
    ls.add(v)
  end
  return ArrayAdapter(activity,android.R.layout.simple_list_item_1, ls)
end]]