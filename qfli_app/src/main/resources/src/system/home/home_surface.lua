--工程列表页面
function load_page_2()
  local main_viewpager_2 = import "layout.layout_pages.layout_main_viewpager_2"
  main_viewpager_background_2.addView(loadlayout(main_viewpager_2))
  mode_tab_layout.setupWithViewPager(mode_pageview);
  mode_system_components_list_background.addView(loadlayout("layout.layout_pages.layout_mode_system_components_list"))
  mode_plugins_list_background.addView(loadlayout("layout.layout_pages.layout_mode_plugins_list"))
  configuration_tools_list_background.addView(loadlayout("layout.layout_pages.layout_configuration_tools_list"))
  import "system.home.mode_system_component_list"
  import "system.home.mode_plugins_list"

  mode_pageview_click={
    function()
      if not sc_load_status then
        empty_tips_4.setVisibility(8)
        progress_bar_4_background.setVisibility(0)
        task(500,function()
          setSwipeRefreshLayout(pull_4,function()
            reload_activities(function()
              task(500,function()
                pull_4.setRefreshing(false);

              end)
            end)
          end)
          load_activities_list()
        end)
        sc_load_status=true
      end
    end,
    function()
      if not plugins_load_status then
        empty_tips_5.setVisibility(8)
        progress_bar_5_background.setVisibility(0)
        task(500,function()
          setSwipeRefreshLayout(pull_5,function()
            reload_plugins(function()

              progress_bar_5_background.setVisibility(8)
              task(500,function()
                pull_5.setRefreshing(false);
              end)
            end)
          end)
          load_plugins_list()
        end)
        plugins_load_status=true
      end
    end,
    function()
      if not configuration_tools_load_status then
        init_configuration_tools()
      end
    end
  }
  mode_pageview.addOnPageChangeListener{
    onPageSelected=function(page)
      local click=mode_pageview_click[page+1]
      if click then
        pcall(click)
      end
    end
  }
end

function load_page_3()
  local main_viewpager_3 = import "layout.layout_pages.layout_main_viewpager_3"
  main_viewpager_background_3.addView(loadlayout(main_viewpager_3))
  --绑定TabLayout和ViewPager
  recyclebin_tab_layout.setupWithViewPager(recyclebin_pageview);
  file_recycle_bin_list_background.addView(loadlayout("layout.layout_pages.layout_file_recycle_bin_list"))
  historical_file_backup_list_background.addView(loadlayout("layout.layout_pages.layout_historical_file_backup_list"))
  format_backup_list_background.addView(loadlayout("layout.layout_pages.layout_format_backup_list"))
end

function load_page_4()
  main_viewpager_background_4.addView(loadlayout("layout.layout_pages.layout_main_viewpager_4"))
  system_ripple({ap_button_background},"circular_white")
  article_post_button.onClick=function()
    local get_user_info_status,user_info=get_saved_user_info()
    if (get_user_info_status and user_info["cookies"]) then
      activity.newLSActivity("activity/post_article_activity")
     else
      system_print(gets("login_status_has_expired"))
    end
  end
  --articles_srl
  --articles_recyclerview
  import "android.text.*"
  articles_rv_item={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="-2";
    backgroundColor=get_theme_color("background_color");
    {
      MaterialCardView;
      layout_margin="8dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      layout_width="-1";
      layout_height="-1";
      CardBackgroundColor=get_theme_color("background_color");
      id="cardView";
      {
        LinearLayoutCompat;
        layout_width="-1";
        layout_height="-1";
        padding="8dp";
        id="cardViewChild";
        {
          LinearLayoutCompat;
          layout_height="fill";
          layout_width="fill";
          layout_margin="8dp";
          orientation="vertical";
          {
            AppCompatTextView;
            textSize="16sp";
            id="title";
            layout_marginBottom="8dp";
            textColor=basic_color_num;
            Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
          };
          {
            AppCompatTextView;
            textColor=text_color;
            id="sub_title";
            textSize="14sp";
            singleLine=true;
          };
          {
            TextView;
            id="message";
            textSize="14sp";
            singleLine=true;
          };
        };
      };
    };
  };
  articles_rv_adapter_data={}
  articles_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #articles_rv_adapter_data
    end,
    getItemViewType=function(position)
      return 0
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local view=loadlayout(articles_rv_item,views)
      local holder=LuaRecyclerHolder(view)
      view.setTag(views)
      views.cardViewChild.setBackground(Ripple(nil,0x22000000))
      views.cardViewChild.onClick=function()
        local data=views["tag_data"]
        local url=data["url"]
        --print(dump(data))
        if url then
          open_url(url)
        end
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      local views=holder.view.getTag()
      local data=articles_rv_adapter_data[position+1]
      views["tag_data"]=data
      views["tag_data"]["position"]=position+1

      local title=data["title"]
      local description=data["description"]
      local author_name=data["author_name"]
      local description=Html.fromHtml(description)

      views.title.setText(title)
      views.sub_title.setText(description)
      views.message.setText(author_name)
      --markwon.setMarkdown(views.sub_title, description);
    end,
  }))
  articles_recyclerview.setAdapter(articles_rv_adapter)
  ar_layoutManager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
  articles_recyclerview.setLayoutManager(ar_layoutManager)

  function load_article_list(reload)
    if reload then
      table.clear(articles_rv_adapter_data)
    end
    articles_srl.setRefreshing(true);
    get_article_list("7",function(status,msg,data,articles)
      if status then
        for index,content in ipairs(articles) do
          table.insert(articles_rv_adapter_data,content)
        end
        articles_rv_adapter.notifyDataSetChanged()
       else
        system_print("获取文章失败")
      end
      articles_srl.setRefreshing(false);
    end)
  end
  load_article_list()
  setSwipeRefreshLayout(articles_srl,function()
    load_article_list(true)
  end)

end

function load_page_5()
  main_viewpager_background_5.addView(loadlayout("layout.layout_member_center.layout"))
end

--配置工具页
function init_configuration_tools()
  function create_cache_delete_dlg(path,callback)
    local delete_tips_dialog,delete_tips_dialog_2=create_delete_tips_dlg(function()
      global_loading_dlg.setMessage(gets("deleting_tips"))
      global_loading_dlg.show()
      task(50,function()
        if (rmDir(path)) then
          system_print("delete_succeed_tips")
          callback(true)
         else
          system_print("delete_failed_tips")
          callback(false)
        end
        global_loading_dlg.dismiss()
      end)
    end)
    delete_tips_dialog.show()
  end

  reset_icons_file_dir.onClick=function()
    global_loading_dlg.show()
    task(50,function()
      if (rmDir(activity.getCustomDir("res"))) then
        AzureUtil.unZipIcons(activity);
        system_print("reset_icons_file_dir_successfully_tips")
       else
        system_print("reset_icons_file_dir_unsuccessfully_tips")
      end
      global_loading_dlg.dismiss()
    end)
  end
  reset_config_file.onClick=function()
    global_loading_dlg.show()
    task(50,function()
      import("config")
      local status,err=write_file(extconfig_path,"config="..dump(config))
      if status then
        system_print("reset_config_file_successfully_tips")
       else
        system_print("reset_config_file_unsuccessfully_tips")
      end
      global_loading_dlg.dismiss()
    end)
  end

  local cache_path=activity.getLuaExtDir("cache")
  local cache_path_2=tostring(activity.getExternalCacheDir())
  local files_path_2=tostring(activity.getExternalFilesDir(""))

  query_cache_button.onClick=function()
    home_cache_size_text.setVisibility(View.VISIBLE)
    get_home_file_list_total_method(home_cache_size_text,cache_path)
  end
  clear_cache_button.onClick=function()
    create_cache_delete_dlg(cache_path,function(status)
      if status then
        get_home_file_list_total_method(home_cache_size_text,cache_path)
      end
    end)
  end


  query_cache_2_button.onClick=function()
    home_cache_2_size_text.setVisibility(View.VISIBLE)
    get_home_file_list_total_method(home_cache_2_size_text,cache_path_2)
  end
  clear_cache_2_button.onClick=function()
    create_cache_delete_dlg(cache_path_2,function(status)
      if status then
        get_home_file_list_total_method(home_cache_2_size_text,cache_path_2)
      end
    end)
  end

  query_files_2_button.onClick=function()
    home_files_2_size_text.setVisibility(View.VISIBLE)
    get_home_file_list_total_method(home_files_2_size_text,files_path_2)
  end
  clear_files_2_button.onClick=function()
    create_cache_delete_dlg(files_path_2,function(status)
      if status then
        get_home_file_list_total_method(home_files_2_size_text,files_path_2)
      end
    end)
  end
  query_projects_button.onClick=function()
    home_projects_size_text.setVisibility(View.VISIBLE)
    get_home_file_list_total_method(home_projects_size_text,activity.getLuaExtDir("projects"))
  end
  clear_error_projects_button.onClick=function()
    create_cache_delete_dlg(activity.getLuaExtDir("project"),function(status)
      if status then
        get_home_file_list_total_method(home_error_projects_size_text,activity.getLuaExtDir("project"))
      end
    end)
   end
  query_error_projects_button.onClick=function()
    home_error_projects_size_text.setVisibility(View.VISIBLE)
    get_home_file_list_total_method(home_error_projects_size_text,activity.getLuaExtDir("project"))
  end
  configuration_tools_load_status=true
end

--个人中心
function init_member_center()
  is_first_get_code=true

  import "system.account_funlib"
  system_ripple({logout_button,login_status_refresh_button},"square_black_theme")

  login_status_refresh_button.onClick=function()
    if (check_login_status()) then
      login_dialog.show()
      login(getSharedData("login_username"),getSharedData("login_password"))
     else
      register_panel.setVisibility(8)
      account_info_panel.setVisibility(8)
      login_panel.setVisibility(0)
      system_print(gets("cannot_find_account_info_tips"))
    end
  end

  login_password_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
  reg_pass_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
  reg_confirm_pass_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
  login_check_box.onClick=function()
    if login_check_box.isChecked() then
      login_password_edittext.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
     else
      login_password_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
    end
  end
  register_check_box.onClick=function()
    if register_check_box.isChecked() then
      reg_pass_edittext.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
      reg_confirm_pass_edittext.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
     else
      reg_pass_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
      reg_confirm_pass_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
    end
  end
  login_button.onClick=function()
    if (login_username_edittext.text~="" and login_password_edittext.text~="") then
      login_dialog.show()
      login(login_username_edittext.text,login_password_edittext.text)
     else
      system_print("input_nil")
    end
  end
  logout_button.onClick=function()
    logout()
  end
  show_register_button.onClick=function()
    task(50,function()
      register_panel.setVisibility(0)
      account_info_panel.setVisibility(8)
      login_panel.setVisibility(8)
    end)
  end

  show_login_button.onClick=function()
    task(50,function()
      register_panel.setVisibility(8)
      account_info_panel.setVisibility(8)
      login_panel.setVisibility(0)
    end)
  end

  send_mail_button.onClick=function()
    local email=register_email_edittext.text
    if (email~="") then
      send_mail_code(email)
     else
      system_print("check_input_info_tip")
    end
  end

  register_button.onClick=function()
    local email=register_email_edittext.text
    local password=reg_pass_edittext.text
    local email_code=register_email_code_edittext.text
    local image_code=reg_code_edittext.text
    if (password~="" and image_code~="" and reg_confirm_pass_edittext.text~="" and email~="" and email_code~="") then
      if ((reg_pass_edittext.text)==(reg_confirm_pass_edittext.text)) then
        emblog_register(email,password,email_code,image_code,send_mail_code_cookies,function(status,msg)
          if status then
            system_print("register_successfully_tip")
            login_username_edittext.setText(email)
            login_password_edittext.setText(password)
            register_panel.setVisibility(8)
            account_info_panel.setVisibility(8)
            login_panel.setVisibility(0)
            login_dialog.show()
            login(login_username_edittext.text,login_password_edittext.text)
           else
            system_print(gets("register_unsuccessfully_tip")..msg)
          end
        end)
       else
        system_print("confirm_pass_error_tips")
      end
     else
      system_print("check_input_info_tip")
    end
  end
  if getSharedData("login_username") then
    login_username_edittext.setText(tostring(getSharedData("login_username")))
  end
  if getSharedData("login_password") then
    login_password_edittext.setText(tostring(getSharedData("login_password")))
    login_password_edittext.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
  end

  if is_first_get_code then
    --获取验证码
    okhttp_request(code_check_url,{},function(code,content,cookies)
      local code_bitmap=get_code_bitmap(code_check_url,cookies)
      login_code_imgv.setImageBitmap(code_bitmap)
      reg_code_imgv.setImageBitmap(code_bitmap)

      login_code_imgv.onClick=function()
      local code_bitmap=get_code_bitmap(code_check_url,cookies)
      login_code_imgv.setImageBitmap(code_bitmap)
      end

      reg_code_imgv.onClick=function()
      local code_bitmap=get_code_bitmap(code_check_url,cookies)
      reg_code_imgv.setImageBitmap(code_bitmap)
      end
    end)
    --login_code_imgv
    --reg_code_imgv
    is_first_get_code=false
  end

  if check_login_status() then

    --[[自动登录
    if (getSharedData("account_info")) then
      local account_info_json=getSharedData("account_info")
      local status,json_data=JsonUtil.parseJson(account_info_json)
      if status then
        local user_info=json_data["user_info"]
        if user_info then
          update_member_info(user_info)
          login_panel.setVisibility(8)
          account_info_panel.setVisibility(0)
         else
          local cookies=json_data["cookies"]
          if auto_login then
            login(getSharedData("login_username"),getSharedData("login_password"),cookies)
          end
        end
       else
        if auto_login then
          login(getSharedData("login_username"),getSharedData("login_password"))
        end
      end
     else
      if auto_login then
        login(getSharedData("login_username"),getSharedData("login_password"))
      end
    end]]
  end
  member_center_load_first=true
end

--底栏
function load_bottombar()
  home_nav.inflateMenu(R.menu.menu_main_bottom_nav)
  home_nav_menu = home_nav.getMenu()
  home_nav.setOnNavigationItemSelectedListener({
    onNavigationItemSelected=function(item)
      local position=0
      local itemId=item.getItemId()
      if itemId==R.id.navigation_home then
        position=0
       elseif itemId==R.id.navigation_widgets then
        position=1
       elseif itemId==R.id.navigation_recycle_bin then
        position=2
       elseif itemId==R.id.navigation_cloud then
        position=3
       elseif itemId==R.id.navigation_account then
        position=4
        if member_center_load_first then
         else
          init_member_center()
        end
      end
      --setHomeTitle(position)
      pageview_id.setCurrentItem(position)
      return true
    end
  })
  pageview_id.addOnPageChangeListener({
    onPageSelected=function(position)
      local selectedItemId=R.id.navigation_home
      if position==0 then
        selectedItemId=R.id.navigation_home
        main_more_button.setVisibility(View.VISIBLE)
       elseif position==1 then
        selectedItemId=R.id.navigation_widgets
        if mode_pageview_click[1] then
          pcall(mode_pageview_click[1])
        end
       elseif position==2 then
        selectedItemId=R.id.navigation_recycle_bin
       elseif position==3 then
        selectedItemId=R.id.navigation_cloud
       elseif position==4 then
        selectedItemId=R.id.navigation_account
      end
      if position==4 then
        main_header_button.setVisibility(View.GONE)
       else
        main_header_button.setVisibility(View.VISIBLE)
      end
      if (position~=0) then
        main_more_button.setVisibility(View.GONE)
      end
      --setHomeTitle(position)
      home_nav.setSelectedItemId(selectedItemId)
    end
  })
end

--设置主页顶栏标题
function setHomeTitle(position)
  local menuItem = home_nav_menu.getItem(position);
  local title = menuItem.getTitle();
  setWindowTitle(title)
end

--初始化列表动画
function init_rv_anim(recycleview)
  import "android.view.animation.LayoutAnimationController"
  import "android.view.animation.AnimationUtils"
  local animation = AnimationUtils.loadAnimation(activity, R.anim.anim_recyclerview);
  local layoutAnimationController = LayoutAnimationController(animation);
  layoutAnimationController.setOrder(LayoutAnimationController.ORDER_NORMAL);
  layoutAnimationController.setDelay(0.2);
  recycleview.setLayoutAnimation(layoutAnimationController);
end