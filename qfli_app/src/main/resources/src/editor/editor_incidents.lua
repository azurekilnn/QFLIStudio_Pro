function load_all_incidents()
  updateUI({progressbar_status=true})

  folder_button.onClick=function()
    drawer_layout.openDrawer(3)
  end

  --代码查错
  system_incident["code_check"]=function()
    system_incident["close_drawer_layout"]()
    if (check_is_lua_file(current_open_file_path)) then
      local src=current_editor.getText()
      local src=src.toString()
      local src=((check_is_aly_file(current_open_file_path) and "return "..src) or src)
      local _,data=loadstring(src)
      if data then
        local _,_,line,data=data:find(".(%d+).(.+)")
        system_print(tostring(line)..":"..tostring(data))
        current_editor_lib["goto_line"](current_editor,tonumber(line))
        --editor.gotoLine(tonumber(line))
        return true
       else
        system_print(gets("noerror_tips"))
      end
    end
  end
  --代码导航
  system_incident["code_navigation"]=function()
    system_incident["close_drawer_layout"]()
    if navi_dlg then
     else
      navi_list = ListView(activity)
      navi_dlg,navi_dlg_data=create_basic_dlg({title="代码导航",view=navi_list,type="no_button_dialog"})
    end

    local src = current_editor.getText().toString()
    local navigation_lines,fs=get_code_navigation(src)
    --[[local fs = {}
  indexs = {}
  for s, i in str:gmatch("([%w%._]* *=? *function *[%w%._]*%b())()") do
    i = utf8.len(str, 1, i) - 1
    s = s:gsub("^ +", "")
    table.insert(fs, s)
    table.insert(indexs, i)
    fs[s] = i
  end]]
    local adapter = ArrayAdapter(activity, android.R.layout.simple_list_item_1, String(fs))
    navi_list.setAdapter(adapter)
    navi_list.onItemClick = function(p,v,i,s)
      local line=navigation_lines[i+1]
      --current_editor.setSelection(position)
      current_editor_lib["goto_line"](current_editor,line)
      navi_dlg.dismiss()
    end
    navi_dlg.show()
  end
  system_incident["add_file"]=function(view)
    function create_swtich_new_file_types_dlg()
      items={}
      table.insert(items,"*.lua")
      table.insert(items,"*.aly")
      table.insert(items,"*.java")
      table.insert(items,"*.xml")
      table.insert(items,"*.html")
      table.insert(items,"*.css")
      table.insert(items,"*.txt")
      table.insert(items,gets("custom_suffix"))
      table.insert(items,gets("folder"))
      local swtich_new_file_types_dlg=MaterialAlertDialogBuilder(this)
      swtich_new_file_types_dlg.setTitle(gets("add_file"))
      swtich_new_file_types_dlg.setItems(items,{onClick=function(v,position)
          local new_file_type=items[position+1]
          --print(new_file_type)
          add_new_file_incident(new_file_type)
        end})
      local swtich_new_file_types_dlg_2=swtich_new_file_types_dlg.show().dismiss()
      set_dialog_style(swtich_new_file_types_dlg_2)

      return swtich_new_file_types_dlg,swtich_new_file_types_dlg_2
    end

    if swtich_new_file_types_dlg_2 then
     else
      swtich_new_file_types_dlg,swtich_new_file_types_dlg_2=create_swtich_new_file_types_dlg()
    end
    swtich_new_file_types_dlg_2.show()
  end
  system_incident.close_drawer_layout = function()
    drawer_layout.closeDrawer(5)
    drawer_layout.closeDrawer(3)
  end
  system_incident.import_analysis=function()
    system_incident["close_drawer_layout"]()
    if (current_open_file_path and check_is_lua_file(current_open_file_path)) then
      --导入分析
      skipLSActivity("import_analysis",{current_open_file_path})
    end
  end
  system_incident.project_info=function()
    skipLSActivity("project_info",{proj_path})
  end
  --Logcat
  system_incident.logcat=function(view)
    skipLSActivity("logcat")
  end

  --
  system_incident.code_format=function()
    if current_editor then
      current_editor_lib["format_code"](current_editor)

    end
  end

  system_incident.jump_line=function()
    system_incident["close_drawer_layout"]()
    if toline_bar_id.getVisibility()==8 then
      tool_bar_id.setVisibility(8)
      toline_bar_id.setVisibility(0)
      control_bar_id.setVisibility(8)
      editor_search_bar_id.setVisibility(8)
    end
  end

  system_incident["swtich_language"]=function()
    if (current_file_language and current_file_language=="images") then
     else
      function create_switch_language_dlg()
        local support_languages=current_editor_lib["get_support_languages"]()
        local switch_language_dlg=MaterialAlertDialogBuilder(this)
        switch_language_dlg.setTitle(gets("swtich_language"))
        local function dlg_check_language(file_name)
          for index,language in ipairs(support_languages) do
            if file_name:find("%"..language.."$") then
              return true,index
            end
          end
        end

        local check_status,this_num=dlg_check_language(current_file_name)
        local selection_num=((this_num-1) or 0)
        switch_language_dlg.setSingleChoiceItems(support_languages,selection_num,{onClick=function(view,position)
            local scope_name=(support_languages[support_languages[position+1]])
            local scope_name=((scope_name~="" or scope_name~=nil) and scope_name)
            current_editor_lib["swtich_language"](current_editor,scope_name)
            switch_language_dlg2.dismiss()
          end})
        local switch_language_dlg2=switch_language_dlg.show().dismiss()
        set_dialog_style(switch_language_dlg2)

        return switch_language_dlg,switch_language_dlg2
      end
      if switch_language_dlg then
       else
        switch_language_dlg,switch_language_dlg2=create_switch_language_dlg()
      end
      switch_language_dlg2.show()

    end
  end
  system_incident["file_tab_incident"]=function(tab)
    local file_name=(tab.getText())
    local tab_operations_pop=PopupMenu(activity,tab.view)
    tab_operations_pop_menu=tab_operations_pop.Menu
    tab_operations_pop_menu.add(gets("close_all_tab")).onMenuItemClick=function(a)
      --[[for index,content in pairs(open_files_info) do
        if (type(content)=="string" and content~="main.lua") then
          table.remove(open_files_info,index)
          --check_data_index(open_files,index)          
          open_files_info[content]=nil 
        end
      end]]
      table.clear(open_files_info)

      if main_file_info then
        current_editor=main_file_info["editor"]
        current_file_name=main_file_info["file_name"]
        current_file=main_file_info["file_object"]
        current_file_language=main_file_info["file_language"]
        open_files_info[current_file_name]={file_language=file_language,can_save=main_file_info["can_save"],file_object=main_file_info["file_object"],editor=main_file_info["editor"],editor_position=0}
        table.insert(open_files_info,current_file_name)
        local editor_position=#open_files_info
        local editor_position=((editor_position~=0 and (editor_position-1)) or editor_position)

        local first_editor=editors_adp_views.get(0)
        local first_title=editors_adp_titles.get(0)
        editors_adp_titles.clear()
        editors_adp_views.clear()
        editors_adp.add(first_editor,first_title)
        editors_adp.notifyDataSetChanged()
        editors_vp.setCurrentItem(0)
        update_current_file_info(main_file_info)

      end
    end

    if file_name~="main.lua" then
      tab_operations_pop_menu.add(gets("close_tab")).onMenuItemClick=function(a)
        if open_files_info[file_name] then
          local file_info=open_files_info[file_name]
          local editor_position=file_info["editor_position"]
          editors_adp.remove(editor_position)
          for index,tag_file_name in ipairs(open_files_info) do
            if tag_file_name==file_name then
              table.remove(open_files_info,index)
            end
          end
          open_files_info[file_name]=nil
          reload_tab_layout()
        end
      end

      --[[for index,content in ipairs(open_files) do
          if content==file_name then
            --check_data_index(open_files,index)
            table.remove(open_files,index)
          end
        end
        if open_files[file_name] then
          open_files[file_name]=nil
        end
        local editor_position_num=editors_position[file_name]
        if editor_position_num then
          editors_adp.remove(editor_position_num)
          check_data_index(editors_position,editor_position_num,file_name)
          editors_position[file_name]=nil
        end
        if open_files_editors[file_name] then
          open_files_editors[file_name]=nil
        end
        reload_tab_layout()
      end]]
    end
    tab_operations_pop_menu.add(gets("save")).onMenuItemClick=function(a)
      save_opened_file(file_name)
    end
    tab_operations_pop_menu.add(gets("copy_filename")).onMenuItemClick=function(a)
      copy_text(file_name)
    end
    tab_operations_pop_menu.add(gets("copy_filepath")).onMenuItemClick=function(a)
      local file_info=open_files[file_name]
      if file_info then
        local file_object=(file_info["file_object"] or {})
        local file_path=file_object["path"]
        copy_text(file_path)
      end
    end
    tab_operations_pop.show()--显示
  end

  system_incident.search_code=function(project_path,text)
    system_incident["close_drawer_layout"]()
    if editor_search_bar_id.getVisibility()==8 then
      tool_bar_id.setVisibility(8)
      editor_search_bar_id.setVisibility(0)
      toline_bar_id.setVisibility(8)
      control_bar_id.setVisibility(8)
    end
    if text then
      editor_search_bar_edit.setText(text)
     else
      editor_search_bar_edit.setText(current_editor_lib["get_selected_text"](current_editor))
    end
  end
  updateUI({progressbar_status=false})

end

function load_all_click_incidents()
  updateUI({progressbar_status=true})
  undo_button.onClick=function()
    if current_open_project_path then
      current_editor.undo()
    end
  end
  play_button.onClick=function()
    if current_open_project_path then
      current_editor.clearFocus()
      require 'import'
      if system_incident["code_check"](true) then
        return
      end
      DebugActivity(project_main_file_path)
    end
  end
  updateUI({progressbar_status=false})
end

function load_tool_bar_incidents()
  cancel_button.onClick=function()
    if search_mode then
      tool_bar_id.setVisibility(8)
      search_bar_id.setVisibility(0)
      toline_bar_id.setVisibility(8)
      control_bar_id.setVisibility(8)
     else
      tool_bar_id.setVisibility(0)
      search_bar_id.setVisibility(8)
      toline_bar_id.setVisibility(8)
      control_bar_id.setVisibility(8)
    end
  end

  editor_search_bar_cancel_button.onClick=function()
    search_mode=false
    local editor_searcher=current_editor.searcher
    current_search_key=""
    editor_search_bar_edit.setText(current_search_key)
    editor_searcher.stopSearch()
    current_editor.invalidate();
    tool_bar_id.setVisibility(0)
    editor_search_bar_id.setVisibility(8)
    toline_bar_id.setVisibility(8)
    control_bar_id.setVisibility(8)
  end


  layout_helper_button.onClick=function()
    run_incident("layout_helper")
  end


  toline_bar_cancel_button.onClick=function()
    tool_bar_id.setVisibility(0)
    editor_search_bar_id.setVisibility(8)
    toline_bar_id.setVisibility(8)
    control_bar_id.setVisibility(8)
  end

  toline_bar_search_button.onClick=function()
    local jump_line=tonumber(toline_bar_edit.text)
    current_editor_lib["goto_line"](current_editor,jump_line)
  end
  editor_search_bar_edit.addTextChangedListener{
    onTextChanged=function(text)
      local search_key=tostring(text)
      local editor_searcher=current_editor.searcher
      if #search_key==0 then
        search_mode=false
        current_editor_lib["stop_search"](current_editor)
       else
        search_mode=true
        editor_searcher.search(search_key,searchOptions)
      end
    end
  }
  editor_search_bar_search_button.onClick=function()
    search_mode=true
    local editor_searcher=current_editor.searcher
    if current_search_key==editor_search_bar_edit.text then
      editor_searcher.gotoNext()
     else
      current_search_key=editor_search_bar_edit.text
      editor_searcher.gotoNext()
    end
  end

  cut_button.onClick=function()
    current_editor_lib["cut_text"](current_editor)
  end
  select_all_button.onClick=function()
    current_editor_lib["selet_all_text"](current_editor)
  end


  copy_button.onClick=function()
    current_editor_lib["copy_text"](current_editor)
  end
  paste_button.onClick=function()
    current_editor_lib["paste_text"](current_editor)
  end
end

function load_sidebar_incidents()
  --文件列表下拉刷新
  left_sidebar_refresh_layout.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
      reload_files_list()
      left_sidebar_refresh_layout.setRefreshing(false);
    end})
  ch_filelist_back_button.onClick=function()
    back_last_dir()
  end

  --设置进度条颜色
  left_sidebar_refresh_layout.setColorSchemeColors({basic_color_num})
  ch_add_file.onClick=function()
    if file_list_checkbox_status then
      filelist_batch_delete()
     else
      popup_incidents=function(text)
        local text=tostring(text)
        add_new_file_incident(text)
        --[[if text:find("*") then
          local file_suffix=(text:match("*.(.+)"))
          create_file(file_suffix)
        else
  
        end]]
      end
      pop=PopupMenu(activity,ch_menu_lay)
      menu=pop.Menu
      menu.add("*.lua").onMenuItemClick=popup_incidents
      menu.add("*.aly").onMenuItemClick=popup_incidents
      menu.add("*.java").onMenuItemClick=popup_incidents
      menu.add("*.xml").onMenuItemClick=popup_incidents
      menu.add("*.html").onMenuItemClick=popup_incidents
      menu.add("*.css").onMenuItemClick=popup_incidents
      menu.add("*.txt").onMenuItemClick=popup_incidents
      menu.add(gets("custom_suffix")).onMenuItemClick=popup_incidents
      menu.add(gets("folder")).onMenuItemClick=popup_incidents
      if (current_open_project_path and current_open_dir~=activity.getLuaExtDir()) then
        pop.show()
      end
    end
  end

  proj_list_button.onClick=function()
    if current_initialization_dir then
      load_files_list(current_initialization_dir,false)
     else
      load_projects_list()
    end
  end
end