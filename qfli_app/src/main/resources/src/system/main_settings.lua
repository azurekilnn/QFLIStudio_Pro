function load_config()
  import "system.system_funlibs"
  import "system.system_template"
  import "main_1"
  --释放 config.lua 文件
  if not File(extconfig_path).exists() then
    write_file(extconfig_path,"config="..dump(config))
  end
  load_activities_config(true)
  load_plugins_config(true)
  load_webdav_projects_config()
end

function reload_activity()
  activity.newLSActivity("main")
  activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
  activity.finish()
end

function load_incidents()
  main_more_button.onClick=function()
    main_more_popupMenu.show()
  end
  main_header_button.onClick=function()
    pageview_id.setCurrentItem(4)
  end
  --[[main_search_button.onClick=function()
    --main_tool_bar_id.setVisibility(8)
    -- main_search_bar_id.setVisibility(0)
  end]]

  home_button.onClick=function()
    create_project_dlg()
    create_project_dialog.show()
    create_project_dialog_ok_button.onClick=function()
      create_newproject(new_app_name.Text,new_app_packagename.Text,function(status,info)
        if status then
          local position=#projects_data+1
          table.insert(projects_data,position,info)
          projects_rv_adapter.notifyDataSetChanged()
          projects_recyclerview.getLayoutManager().scrollToPositionWithOffset(position-1,0);
          empty_tips.setVisibility(8)
          project_list_background.setVisibility(0)
          progress_bar_background.setVisibility(8)
        end
      end)
    end
  end
  import "com.luastudio.azure.viewpager.*"

  pageview_id.setPageTransformer(true,ZoomOutPageTransformer());
end

function load_listeners()
  projects_pageview_click={
    function()
      current_projects_adapter=projects_rv_adapter
    end,
    function()
      if error_projects_load_status then
      else
        error_projects_load_status=true
      end
    end,
    function()
    end,
    function()
      if get_webdav_list_first then
       else
        if not wpls then
          init_main_webdav_projects_list()
        end
        empty_tips_3.setVisibility(8)
        progress_bar_3_background.setVisibility(0)
        task(500,function()
          load_webdav_projects(function(status,content)
            if status and content and #content~=0 then
              empty_tips_3.setVisibility(8)
              webdav_project_list_background.setVisibility(0)
              progress_bar_3_background.setVisibility(8)
             else
              empty_tips_3.setVisibility(0)
              webdav_project_list_background.setVisibility(0)
              progress_bar_3_background.setVisibility(8)
            end
            pull_3.setRefreshing(false);
            get_webdav_list_first=true
          end)
        end)
      end
    end
  }
  home_pageview.addOnPageChangeListener{
    onPageSelected=function(page)
      local click=projects_pageview_click[page+1]
      if click then
        pcall(click)
      end
    end
  }



end





function load_surface()
  --main_search_bar_edit.setHint(gets("search_tips"))
  --main_search_button.setVisibility(0)

  --控件波纹
  system_ripple({main_header_button},"circular_theme")
  system_ripple({main_more_img},"circular_theme")
  system_ripple({home_button_background},"circular_white")


  item_click=function(a)
    system_incident[item_incident[tostring(a)]]()
  end

  --更多菜单
  main_more_popupMenu=PopupMenu(activity,main_more_lay)
  more_popup_menu=main_more_popupMenu.Menu
  more_popup_menu.add(gets("donation_text")).onMenuItemClick=item_click
  more_popup_menu.add(gets("create_project")).onMenuItemClick=item_click
  more_popup_menu.add(gets("import_project")).onMenuItemClick=item_click
  more_popup_menu.add(gets("night_mode_text")).onMenuItemClick=item_click
  more_popup_menu.add(gets("contact_dev")).onMenuItemClick=item_click
  more_popup_menu.add(gets("join_qqgroup")).onMenuItemClick=item_click
  more_popup_menu.add(gets("project_url_text")).onMenuItemClick=function()
    open_url("https://gitcode.net/azurekiln/luastudio_pro")
  end
  more_popup_menu.add("本地更新").onMenuItemClick=function()
    import "system.system_update"
    local_update_incident()
  end
  more_popup_menu.add(gets("settings")).onMenuItemClick=item_click

  home_projects_collection_list_background.addView(loadlayout("layout.layout_pages.layout_home_viewpage_1.layout_main_collection_projects_list"))
  home_cloud_projects_list_background.addView(loadlayout("layout.layout_pages.layout_home_viewpage_1.layout_main_cloud_projects_list"))
  home_error_projects_list_background.addView(loadlayout("layout.layout_pages.layout_home_viewpage_1.layout_main_error_projects_list"))
  home_apk_list_background.addView(loadlayout("layout.layout_pages.layout_home_viewpage_1.layout_main_apks_list"))
  import "system.home.main_webdav_projects_list"

init_main_error_projects_list()
load_error_projects_list()
batch_repair_button.onClick=function()

  local fix_error_project_dlg,fix_error_project_dlg_2=create_fix_error_project_dlg_2(function()
    batch_repair_button.setEnabled(false)
    batch_repair_pg_card.setVisibility(View.VISIBLE)
    home_progressbar.setVisibility(View.VISIBLE)
    batch_repair_pg_card_tv.setText(gets("start_repair_tips"))
    task(500,function()
      batch_repair()
    end)
  end)
end
end


function load_other_pages()
  load_page_2()
  load_page_3()
  load_page_4()
  load_page_5()
end

function load_swiperefreshlayout()
  setSwipeRefreshLayout(home_pull,function()
    load_local_projects_list(function()
      task(500,function()
        home_pull.setRefreshing(false);
      end)
    end,true)
  end)

  setSwipeRefreshLayout(error_projects_list_pull,function()
    load_error_projects_list(function()
      task(500,function()
        error_projects_list_pull.setRefreshing(false);
      end)
    end,true)
  end)

  setSwipeRefreshLayout(pull_3,function()
    load_webdav_projects(function(status,content)
      if status and content and #content~=0 then
        empty_tips_3.setVisibility(8)
        webdav_project_list_background.setVisibility(0)
        progress_bar_3_background.setVisibility(8)
       else
        empty_tips_3.setVisibility(0)
        webdav_project_list_background.setVisibility(0)
        progress_bar_3_background.setVisibility(8)
      end
      pull_3.setRefreshing(false);
    end,true)
  end)

end
function load_main_incidents()
  function onNewIntent(intent)
    local uri=intent.getData()
    if uri then
      local data=intent.getData();
      if (data ~= nil) then
        local path=data.getPath();
        if (path ~= null) then
          if ("content"==(data.getScheme())) then
            local ins=activity.getContentResolver().openInputStream(data);
            local path2=activity.getLuaExtPath("cache", File(data.getPath()).getName());
            local out=FileOutputStream(path2);
            LuaUtil.copyFile(ins, out);
            out.close();
            if uri.getPath():find("%.alp$") then
              mimport_alp_project(path2)
             elseif uri.getPath():find("%.lsz$") then
              mimport_project(path2)
             else
              import "EditorUtil"
              if EditorUtil.checkEncryptFile(path2) then
                        skipLSActivity("fast_editor",{path2})
              end
            end
            return ;
          end
          if uri.getPath():find("%.alp$") then
            mimport_alp_project(path)
           elseif uri.getPath():find("%.lsz$") then
            mimport_project(path)
          else
            import "EditorUtil"
  if EditorUtil.checkEncryptFile(path) then
            skipLSActivity("fast_editor",{path})
  end
          end
        end
      end
    end
  end

end
  
function onVersionChanged(n, o)
  local user_agreement_dialog_title
  import "update_log"
  if o then
    user_agreement_dialog_title = "Updated：" .. o .. ">" .. n
   else
    user_agreement_dialog_title = "欢迎使用"
  end
  if about_dialog then
   else
    create_about_dlg()
  end
  about_dialog_title.setText(user_agreement_dialog_title)
  about_dialog.show()
end

function onActivityResult(a,b,c)
  if a==11 then--是请求权限返回的值
    if not DataLibrary.savePermission(a,b,c) then
      local authorization_dlg=AlertDialog.Builder(this)
      authorization_dlg.setTitle(gets("tip_text"))
      authorization_dlg.setMessage(gets("authorization_failed_tips"))
      authorization_dlg.setPositiveButton(gets("go_to_authorization_button"),{onClick=function(v)
          DataLibrary.requestPermission()
        end})
      authorization_dlg.setNegativeButton(gets("cancel_button"),nil)
      authorization_dlg.show()
    end
  end
end