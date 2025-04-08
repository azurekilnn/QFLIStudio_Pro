function load_shared_codes()
  read_log_table={
    All="",
    Lua="lua:* *:S",
    Test="test:* *:S",
    Tcc="tcc:* *:S",
    Error="*:E",
    Warning="*:W",
    Info="*:I",
    Debug="*:D",
    Verbose="*:V",
  }

  function read_log(s)
    require "import"
    import "system.system_strings"
    p=io.popen("logcat -d -v long "..s)
    local s=p:read("*a")
    p:close()
    s=s:gsub("%-+ beginning of[^\n]*\n","")
    if #s==0 then
      s="<"..gets("first_log")..">"
    end
    return s
  end

  function clear_log()
    require "import"
    import "system.system_strings"
    p=io.popen("logcat -c")
    local s=p:read("*a")
    p:close()
    s="<"..gets("first_log")..">"
    return s
  end

  logcat_r="%[ *%d+%-%d+ *%d+:%d+:%d+%.%d+ *%d+: *%d+ *%a/[^ ]+ *%]"

  showlayout={
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

  function show_log(s)
    local logcat_adapter=LuaAdapter(activity,showlayout)
    local l=1
    for i in s:gfind(logcat_r) do
      if l~=1 then
        logcat_adapter.add({content={text=s:sub(l,i-1),textIsSelectable=true}})
      end
      l=i
    end
    logcat_adapter.add({content={text=s:sub(l),textIsSelectable=true}})
    logcat_lv.setAdapter(logcat_adapter)
  end

  logcat_item_click=function(a)
    --popup_dimiss()
    local item_text=tostring(a)
    if item_text==gets("all") then
      task(read_log,read_log_table["All"],show_log)
      setWinTitle("LogCat - "..gets("all"))
     elseif item_text==gets("clear_all") then
      task(clear_log,show_log)
     else
      task(read_log,read_log_table[item_text],show_log)
      setWinTitle("LogCat - "..item_text)
    end
  end

  logcat_mode_popupMenu=PopupMenu(activity,more_lay)
  logcat_menu=logcat_mode_popupMenu.Menu
  logcat_menu.add(gets("all")).onMenuItemClick=logcat_item_click
  for index,content in pairs(read_log_table) do
    if index=="All" then
     else
      logcat_menu.add(index).onMenuItemClick=logcat_item_click
    end
  end
  logcat_menu.add(gets("clear_all")).onMenuItemClick=logcat_item_click

  more_button.onClick=function()
    logcat_mode_popupMenu.show()
  end

  setWinTitle("LogCat - Lua")
  task(read_log,"lua:* *:S",show_log)
end