--顶部-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--operations_bar 操作栏--
function load_operations_bar()
  operations={
    "add_file","bin_project","insert_code","swtich_language","code_check","import_analysis",
    "code_navigation","search_code","global_search_code","jump_line",--"project_list",
    "project_import","project_recovery","project_info","import_resources",
    "create_project","compile_lua_file","lua_course","lua_explain","argb_tool",
    "java_api","color_reference","logcat"--"help_roster","layout_helper",
  }
  editor_opeartions_bar.setVisibility(0)
  for index,content in ipairs(operations) do
    local new_tab=editor_opeartions_bar.newTab().setText(gets(content)).setTag(tostring(content))
    editor_opeartions_bar.addTab(new_tab,false);
    new_tab.view.onClick=function()
      local tag_name=(new_tab.getTag())
      run_incident(tag_name)
    end
  end
  editor_opeartions_bar.setTabTextColors(pc(get_theme_color("paratext_color")),pc(get_theme_color("paratext_color")))
  editor_opeartions_bar.setSelectedTabIndicatorHeight(0);
  --[[editor_opeartions_bar.setOnTabSelectedListener({
    onTabSelected=function(tab)
      local text=(tab.getText())
      local tag_name=(tab.getTag())
      run_incident(tag_name)
      return true
    end
  })]]
end

--错误提示栏--
function check_code_main()
  if (check_file_opened_status() and check_is_lua_file(current_open_file_path) and realtime_check_error_status) then
    local src=current_editor.getText()
    local src=src.toString()
    local src=((check_is_aly_file(current_open_file_path) and "return "..src) or src)
    local _,data=loadstring(src)
    if data then
      local _,_,line,data=data:find(".(%d+).(.+)")
      error_bar.setVisibility(0)
      error_text_id.setText(line..":"..data)
      error_text_id.setTextColor(pc(0xffff0000))
      return true
     else
      error_bar.setVisibility(8)
      error_text_id.setTextColor(pc(text_color))
      error_text_id.setText("没有错误")
    end
  end
end

function set_error_info(value)
  error_text_id.setText(value)
end

function check_code_thread()
  require "import"
  local realtime_check_error_status=activity.get("realtime_check_error_status")
  while realtime_check_error_status do
    Thread.sleep(1000)
    call("check_code_main")
  end
end



--底部-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--symbol_bar 符号栏--
function load_symbols_bar()
  --插入符号
  function paste_symbol(view,editor)
    local symbol_text=view.text
    local function output_paste_content(symbol,text)
      if text and text~="" then
        if symbol=="Fun" or symbol=="FUN" then
          return("function()"),8
         elseif symbol=="→" then
          return(" ")
         elseif symbol=="↓" then
          return("\n")
         elseif symbol=='"' then
          return('"'..text..'"')
         elseif symbol=="'" then
          return("'"..text.."'")
         elseif symbol=='[' or symbol=="]" then
          return('['..text..']')
         elseif symbol=='{' or symbol=="}" then
          return('{'..text..'}')
         elseif symbol=='(' or symbol==')' then
          return("("..text..")")
         elseif symbol=='<' or symbol=='>' then
          return("<"..text..">")
         else
          return symbol
        end
       else
        if symbol=="Fun" or symbol=="FUN" then
          return("function()"),8
         elseif symbol=="→" then
          return(" ")
         elseif symbol=="↓" then
          return("\n")
         else
          return symbol
        end
      end
    end
    if current_open_project_path then
      if smybols_quick_codes[symbol_text] then
        pcall(smybols_quick_codes[symbol_text])
       else
        local selected_text=current_editor_lib["get_selected_text"](current_editor)
        local output_content,position=output_paste_content(symbol_text,selected_text)
        current_editor_lib["insert_text_3"](current_editor,output_content,position)
      end
    end
  end
  symbol_bar_background.setVisibility(0)
  for index,content in ipairs(editor_symbols) do
    button={
      TextView;
      text=tostring(content);
      singleLine="true";
      layout_height="fill";
      gravity="center";
      Typeface=load_font("common");
      textColor=symbol_bar_icon_color();
      paddingRight="15dp";
      paddingLeft="15dp";
      id="symbol_button";
    };
    m=loadlayout(button)
    editor_symbols_bar.addView(m)
    system_ripple({symbol_button},"circular_black_theme")
    m.onClick=function(v)
      paste_symbol(v,current_editor)
    end
  end
end

--快捷操作栏--
function load_fast_operations_bar()
  fast_code_operation_table={"choose_line_tab","copy_line_tab","cut_line_tab",
    "delete_line_tab","repeat_line_tab","clear_line_tab","comment_line_tab"}
  fast_code_operation_table["choose_line_tab"]=function()
    fast_code_operation_choose_tab=1
    current_editor_lib["select_line"](current_editor)
  end
  fast_code_operation_table["copy_line_tab"]=function()
    fast_code_operation_choose_tab=2
    current_editor_lib["copy_line"](current_editor)
  end
  fast_code_operation_table["cut_line_tab"]=function()
    fast_code_operation_choose_tab=3
    current_editor_lib["cut_line"](current_editor)
  end
  fast_code_operation_table["delete_line_tab"]=function()
    fast_code_operation_choose_tab=4
    current_editor_lib["delete_line"](current_editor)
  end
  fast_code_operation_table["repeat_line_tab"]=function()
    fast_code_operation_choose_tab=5
    current_editor_lib["repeat_line"](current_editor)
  end
  fast_code_operation_table["clear_line_tab"]=function()
    fast_code_operation_choose_tab=6
    current_editor_lib["clear_line"](current_editor)
  end
  fast_code_operation_table["comment_line_tab"]=function()
    fast_code_operation_choose_tab=7
    current_editor_lib["comment_line"](current_editor)
  end

  local swtich_record = activity.getLuaDir() .. "/memory_file/swtich_record/shortcut_function_button_opend.conf"--开关记录值
  pcall(dofile, swtich_record)
  fast_code_operation_choose_tab=nil
  fcode_operation_button_pop=PopupMenu(activity,fcode_operation_button)
  fcode_operation_button_pop_menu=fcode_operation_button_pop.Menu
  for v,k in pairs(fast_code_operation_table) do
    if type(v)=="number" then
      local tab_title=gets(fast_code_operation_table[v])
      local tab_func=fast_code_operation_table[fast_code_operation_table[v]]
      fcode_operation_button_pop_menu.add(tab_title).onMenuItemClick=function()tab_func()end
    end
  end

  --自动显示操作栏
  if shortcut_function_button_opend then
    fast_operation_bar.setVisibility(0)
    fast_button_close_b=true
    fast_button_close_icon.rotation=180
   else
    fast_operation_bar.setVisibility(8)
    fast_button_close_b=false
    fast_button_close_icon.rotation=0
  end

  fast_button_close.onClick=function()
    if fast_button_close_b then
      fast_button_close_b=false
      fast_operation_bar.setVisibility(8)
      fast_button_close_icon.rotation=0
     else
      fast_button_close_b=true
      fast_operation_bar.setVisibility(0)
      fast_button_close_icon.rotation=180
    end
    write_file(swtich_record,"shortcut_function_button_opend="..tostring(fast_button_close_b))
    return true
  end

  fast_button_close.onLongClick=function()
    if fast_button_close_b==false then
      current_editor_lib["goto_line"](current_editor,1)
    end
    return true
  end

  fredo_button.onClick=function()
    if current_editor then
      current_editor_lib["redo"](current_editor)
    end
  end

  finsert_code_button.onClick=function()
    if current_open_project_path then
      if insert_code_dialog then
        insert_code_dialog.show()
       else
        insert_code_dialog=create_insert_code_dlg()
        insert_code_dialog.show()
      end
    end
  end

  fformat_button.onClick=function()
    if current_editor then
      current_editor_lib["format_code"](current_editor)
    end
  end

  fpaste_button.onClick=function()
    if current_editor then
      current_editor_lib["paste_text"](current_editor)
    end
  end

  fcode_operation_button.onClick=function()
    if current_open_project_path then
      fcode_operation_button_pop.show()--显示
    end
  end

  fcode_operation_button.onLongClick=function()
    if fast_code_operation_choose_tab then
      fast_code_operation_table[fast_code_operation_table[fast_code_operation_choose_tab]]()
     else
      if current_editor then
        current_editor_lib["select_line"](current_editor)
      end
    end
    return true
  end
end