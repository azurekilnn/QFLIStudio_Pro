set_style()
content_view={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  backgroundColor=gray_color;
  {
    LinearLayoutCompat;
    layout_width="100%w";
    layout_height="50dp";
    layout_gravity="center";
    orientation="horizontal";
    {
      LinearLayoutCompat;
      layout_weight="1";
      layout_height="fill";
      backgroundColor=get_theme_color("tool_bar_color");
      {
        LinearLayoutCompat;
        id="pr_window1";
        gravity="center";
        layout_width="fill";
        layout_height="fill";
        {
          TextView;
          id="pr_title1";
          textSize="15sp";
          textColor=system_title_color();
        };
      };
    };
    {
      LinearLayoutCompat;
      layout_weight="1";
      layout_height="fill";
      backgroundColor=get_theme_color("tool_bar_color");
      {
        LinearLayoutCompat;
        id="pr_window2";
        gravity="center";
        layout_width="fill";
        layout_height="fill";
        {
          TextView;
          id="pr_title2";
          textSize="15sp";
          textColor=system_title_color();
        };
      };
    };
  };
  {
    LinearLayoutCompat;
    elevation="2dp";
    layout_height="2dp";
    layout_width="90%w";
    layout_gravity="center";
    layout_marginTop="-4dp";
    {
      LinearLayoutCompat;
      id="slide_bar";
      layout_height="1%h";
      layout_width="45%w";
      backgroundColor=basic_color;
    };
  };
  {
    PageView;
    layout_height="fill";
    layout_width="fill";
    layout_weight="1.0";
    id="pr_pageview_id";
    pages={
      {
        FrameLayout,
        backgroundColor=get_theme_color("background_color");
        layout_width="fill",
        layout_height="fill",
        {
          LinearLayoutCompat;
          orientation="vertical";
          gravity="center";
          layout_width="fill";
          layout_height="fill";
          id="background";
          {
            TextView;
            layout_width="fill";
            textSize="14sp";
            paddingTop="8dp";
            Visibility="8";
            paddingLeft="24dp";
            paddingRight="24dp";
            paddingBottom="8dp";
            Text="sdcard";
            textColor=text_color;
            id="path_textview";
          };
          {
            SwipeRefreshLayout,
            --layout_marginTop="15dp";
            id="srl",
            {
              ListView;
              DividerHeight="0";
              id="common_recovery_listview";
              layout_width="fill";
              layout_height="fill";
              layout_marign="10dp";
            };
          };
        };
      };
      {
        FrameLayout,
        layout_width="fill",
        layout_height="fill",
        backgroundColor=get_theme_color("background_color");
        {
          LinearLayoutCompat;
          orientation="vertical";
          gravity="center";
          layout_width="fill";
          layout_height="fill";
          id="background_2";
          {
            TextView;
            layout_width="fill";
            textSize="14sp";
            paddingTop="8dp";
            paddingLeft="24dp";
            paddingRight="24dp";
            paddingBottom="8dp";
            Text="sdcard";
            Visibility="8";
            textColor=text_color;
            id="path_textview2";
          };
          {
            SwipeRefreshLayout,
            --layout_marginTop="15dp";
            id="srl_2",
            {
              ListView;
              DividerHeight="0";
              id="deletebm_recovery_listview";
              layout_width="fill";
              layout_height="fill";
              layout_marign="10dp";
            }
          }
        }
      }
    }
  }
}


function load_shared_codes()

  --load_recovery_list
  function load_recovery_list(title_id,adapter,path,key_word)
    adapter.clear()
    title_id.setText(path)
    ls=File(path).listFiles()
    if ls~=nil then
      ls=luajava.astable(File(path).listFiles())
      table.sort(ls,function(a,b)
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and ul(a.Name)<ul(b.Name))
      end)
     else
      ls={}
    end
    for index,c in ipairs(ls) do
      if c.isFile() then
        if not c.Name:find("%.bak") then
          if c.Name:find("%.lsz") then
            if key_word then
              local key_word=output_search_key(key_word)
              local file_name=c.Name
              local file_name_1=output_search_key(file_name)
              if file_name_1:find(key_word) then
                adapter.add{text=file_name,time={text=get_file_changed_time(c.path)},img={src=load_icon_path("inbox")}}
              end
             else
              adapter.add{text=c.Name,time={text=get_file_changed_time(c.path)},img={src=load_icon_path("inbox")}}
            end
          end
        end
      end
    end
  end

  common_recovery_listview.onItemClick=function(p,v,i,s)
    local file_path=backup_path.."/"..tostring(v.Tag.text.Text)
    --system_print(file_path)
    import_project(file_path)
    return true
  end

  deletebm_recovery_listview.onItemClick=function(p,v,i,s)
    local file_path=projects_bin_path.."/"..tostring(v.Tag.text.Text)
    import_project(file_path)
    return true
  end


  local item={
    LinearLayoutCompat;
    layout_height="wrap";
    layout_width="fill";
    Gravity="left|center";
    paddingTop="12dp";
    paddingLeft="24dp";
    paddingRight="24dp";
    paddingBottom="12dp";
    {
      ImageView;
      layout_height="24dp";
      layout_width="24dp";
      colorFilter=basic_color_num;
      id="img";
    };
    {
      LinearLayoutCompat;
      gravity="center";
      layout_height="wrap";
      layout_width="fill";
      orientation="vertical";
      layout_marginLeft="10dp";
      {
        TextView;
        id="text";
        layout_gravity="left";
        gravity="bottom";
        textSize="15sp";
        layout_marginRight="16dp";
        textColor=text_color;
        singleLine=true;
      };
      {
        TextView;
        id="time";
        layout_gravity="left";
        textSize="12sp";
        gravity="left";
        layout_marginRight="16dp";
        textColor=get_theme_color("paratext_color");
        singleLine=true;
      };
    };
  };

  common_recovery_listview_adp=LuaAdapter(activity,item)
  deletebm_recovery_listview_adp=LuaAdapter(activity,item)

  common_recovery_listview.setAdapter(common_recovery_listview_adp)
  deletebm_recovery_listview.setAdapter(deletebm_recovery_listview_adp)

  backup_path=activity.getLuaExtDir().."/backup"
  projects_bin_path=tostring(activity.getExternalFilesDir("projects_bin"))

  --设置滑动条&字体颜色
  appp=activity.getWidth()
  local kuan=appp*0.9/2
  pr_pageview_id.setOnPageChangeListener(PageView.OnPageChangeListener{
    onPageScrolled=function(a,b,c)
      page=a+1
      slide_bar.setX(kuan*(b+a))
      if c==0 then
        if a==0 then
          pr_title1.setTextColor(pc(system_title_color()))
          pr_title2.setTextColor(change_color_strength("AA",pc(system_title_color())))
         elseif a==1 then
          pr_title1.setTextColor(change_color_strength("AA",pc(system_title_color())))
          pr_title2.setTextColor(pc(system_title_color()))
        end
      end
    end
  })

  pr_window1.onClick=function()
    pr_pageview_id.showPage(0)
  end
  pr_window2.onClick=function()
    pr_pageview_id.showPage(1)
  end

  srl.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
      load_recovery_list(path_textview,common_recovery_listview_adp,backup_path)
      srl.setRefreshing(false);
    end})

  srl_2.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
      load_recovery_list(path_textview2,deletebm_recovery_listview_adp,projects_bin_path)
      srl_2.setRefreshing(false);
    end})

  srl.setColorSchemeColors({basic_color_num});
  srl_2.setColorSchemeColors({basic_color_num});


  if main_handler then
   else
    main_handler=Handler()
  end
  main_handler.postDelayed(Runnable{
    run=function()
      load_all_paths()
      load_recovery_list(path_textview,common_recovery_listview_adp,backup_path)
      load_recovery_list(path_textview2,deletebm_recovery_listview_adp,projects_bin_path)
    end
  },0)

  function delete_dlg(path,adapter,i)
    local delete_tip_dialog=MaterialAlertDialogBuilder(activity)
    delete_tip_dialog.setTitle(gets("tip_text"))
    delete_tip_dialog.setMessage(gets("delete_tips"))
    delete_tip_dialog.setPositiveButton(gets("ok_button"),function()
      if File(path).exists() then
        LuaUtil.rmDir(File(path))
        adapter.remove(i)
        system_print(gets("delete_succeed_tips"))
      end
    end)
    delete_tip_dialog.setNegativeButton(gets("cancel_button"),nil)
    delete_tip_dialog.show()
  end

  common_recovery_listview.onItemLongClick=function(p,v,i,s)
    local file_path=backup_path.."/"..tostring(v.Tag.text.Text)
    delete_dlg(file_path,common_recovery_listview_adp,i)
    return true
  end

  deletebm_recovery_listview.onItemLongClick=function(p,v,i,s)
    local file_path=projects_bin_path.."/"..tostring(v.Tag.text.Text)
    delete_dlg(file_path,deletebm_recovery_listview_adp,i)
    return true
  end

  function auto_load(key_word)
    if page==1 then
      load_recovery_list(path_textview,common_recovery_listview_adp,backup_path,key_word)
     elseif page==2 then
      load_recovery_list(path_textview2,deletebm_recovery_listview_adp,projects_bin_path,key_word)
    end
  end

  search_bar_edit.setHint(gets("search_tip"))
  search_bar_edit.setOnEditorActionListener(TextView.OnEditorActionListener{
    onEditorAction=function(view,actionId,event)
      local s=tostring(view.text)
      auto_load(s)
      return false
    end})

  search_bar_search_button.onClick=function()
    local s=tostring(search_bar_edit.text)
    auto_load(s)
  end
  pr_title1.setText(gets("common_recovery"))
  pr_title2.setText(gets("deletebm_recovery"))
  system_ripple({pr_window1,pr_window2},"circular_theme")

end



if not dlg_mode then
  import "system.system_dialogs"

  setCommonView(content_view,"project_recovery","back_with_search_mode")

  setImage(search_bar_cancel_button_img,load_icon_path("close"))

  pcall(load_shared_codes)
  --返回键控制
  function onKeyDown(e)
    if e==4 then
      system_print(gets("loading_tip"))
      activity.result({"project_info_changed"})
    end
    return true
  end
end
