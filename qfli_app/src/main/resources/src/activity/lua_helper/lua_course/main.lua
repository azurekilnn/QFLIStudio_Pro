set_style()
content_view={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  backgroundColor=get_theme_color("background_color");
  {
    FrameLayout;
    layout_width="fill";
    backgroundColor=get_theme_color("tool_bar_color");
  };
  {
    PageView,
    layout_height="fill",
    layout_width="fill",
    layout_weight="1",
    id="course_pageview_id",
    pages={
      {
        LinearLayoutCompat;
        orientation = "vertical",
        gravity = "center",
        layout_height="fill",
        layout_width="fill",
        {
          GridView,
          layout_height="fill",
          layout_width="fill",
          layout_margin = "10dp",
          id = "course_gridview_1",
          NumColumns = '2',
          horizontalSpacing = "2dp",
          verticalSpacing = "2dp",
          ScrollBarStyle = ScrollView.SCROLLBARS_OUTSIDE_OVERLAY,
        }
      },
      {
        LinearLayoutCompat;
        orientation = "vertical",
        gravity = "center",
        layout_height="fill",
        layout_width="fill",
        {
          ListView,
          layout_height="fill",
          layout_width="fill",
          layout_margin = "4dp",
          id = "course_listview_2",
          DividerHeight=0;
        }
      }
    }
  }
}

function load_shared_codes()
  --ripple setting
  function ripple_setting(data,adapter,value)
    for index,content in pairs(data) do
      if content.content then
        if content.itemParent==nil then
          content.itemParent={}
        end
        if content.item==nil then
          content.item={}
        end
        content.content.textColor=pc(text_color)
        content.itemParent.backgroundColor=pc(get_theme_color("background_color"))
        content.item.background=Ripple(nil,0x22000000)
       elseif content.item_text then
        if content.itemParent==nil then
          content.itemParent={}
        end
        if content.item==nil then
          content.item={}
        end

        content.item_text.textColor=pc(text_color)
        content.itemParent.backgroundColor=pc(gray_color)
        content.item.background=Ripple(nil,0x22000000)
      end
    end
    adapter.notifyDataSetChanged()
  end

  教程分类={
    gets("all"),
    "AndroLua帮助",
    "实用代码",
    "用户界面",
    "笔记",
    "基础代码",
    "网络操作",
    "文件操作",
    "Intent类",
  }

  provider_table={
    "",
    "--nirenr提供",
    "--寒歌提供",
    "--寒歌提供",
    "--烧风提供",
    "--寒歌提供",
    "--寒歌提供",
    "--寒歌提供",
    "--寒歌提供",
  }

  gridview_item=import "layout.layout_items.layout_list_item_textview_3"
  listview_item=import "layout.layout_items.layout_list_item_textview_2"

  type_table={}
  course_table={}

  course_adp1=LuaAdapter(activity,type_table,gridview_item)
  course_gridview_1.setAdapter(course_adp1)
  for index,content in ipairs(教程分类) do
    local provider=provider_table[index]
    course_adp1.add{content={text=content},sub_content={text=provider}}
  end
  ripple_setting(type_table,course_adp1)

  course_adp2=LuaAdapter(activity,course_table,listview_item)
  course_listview_2.setAdapter(course_adp2)

  function search_content()
    if key then
      local search_key=output_search_key(key)
      local search_title=output_search_key(title)
      local search_content=output_search_key(content)
      if search_title:find(search_key) or search_content:find(search_key) then
        course_adp2.add{content={text=title},sub_content={text=content}}
      end
     else
      course_adp2.add{content={text=title},sub_content={text=content}}
    end
  end

  function get_content(name,key)
    import "course"
    local name=tostring(name)
    local title_table=course["title"][name]
    local content_table=course["content"][name]
    local endnum=#title_table
    if list_inverted_order then
      --倒序
      while endnum>0 do
        local title=title_table[endnum]
        local content=content_table[endnum]
        if key then
          local search_key=output_search_key(key)
          local search_title=output_search_key(title)
          local search_content=output_search_key(content)
          if search_title:find(search_key) or search_content:find(search_key) then
            course_adp2.add{content={text=title},sub_content={text=content}}
          end
         else
          course_adp2.add{content={text=title},sub_content={text=content}}
        end
        endnum=endnum-1
      end
     else
      --正序
      local num=1
      while endnum>num do
        local title=title_table[num]
        local content=content_table[num]
        if key then
          local search_key=output_search_key(key)
          local search_title=output_search_key(title)
          local search_content=output_search_key(content)
          if search_title:find(search_key) or search_content:find(search_key) then
            course_adp2.add{content={text=title},sub_content={text=content}}
          end
         else
          course_adp2.add{content={text=title},sub_content={text=content}}
        end
        num=num+1
      end
    end
  end

  function load_content(keys)
    --print(keys)
    get_content("Lua教程",keys)
    get_content("AndroLua帮助",keys)
    get_content("实用代码",keys)
    get_content("用户界面",keys)
    get_content("笔记",keys)
    get_content("基础代码",keys)
    get_content("网络操作",keys)
    get_content("文件操作",keys)
    get_content("Intent类",keys)
  end

  main_handler.postDelayed(Runnable{
    run=function()
      get_content("Lua教程",keys)
      ripple_setting(course_table,course_adp2)
    end},1000)

  --列表点击事件
  course_listview_2.onItemClick=function(p,v,i,s)
    local title=v.Tag.content.Text
    local content=v.Tag.sub_content.Text
    SkipPage("lua_course_preview",{title,content})
    return true
  end

  course_gridview_1.onItemClick=function(p,v,i,s)
    local type=v.Tag.content.Text
    if type==gets("all") then
      course_adp2.clear()
      load_content()
     else
      course_adp2.clear()
      get_content(type,keys)
    end
    course_pageview_id.showPage(1)
    return true
  end

  function search_incident()
    course_adp2.clear()
    load_content(search_bar_edit.Text)
    course_pageview_id.showPage(1)
  end
  --发起搜索按钮事件
  search_bar_search_button.onClick=function()
    search_incident()
  end
  --搜索框,输入法右下角搜索监听
  search_bar_edit.setOnEditorActionListener(TextView.OnEditorActionListener{
    onEditorAction=function(view,actionId,event)
      search_incident()
      return false
    end})
end

if not dlg_mode then
  setCommonView(content_view,"lua_course","back_with_search_mode")
  load_shared_codes()
end