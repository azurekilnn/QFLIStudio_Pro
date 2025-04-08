content_view={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  backgroundColor=get_theme_color("background_color");
  {
    FrameLayout;
    layout_width="fill";
    backgroundColor = get_theme_color("tool_bar_color");
  };
  {
    PageView,
    layout_height = "fill",
    layout_width = "fill",
    layout_weight = "1",
    id = "pageview_id",
    pages = {
      {
        LinearLayoutCompat;
        orientation = "vertical",
        gravity = "center",
        layout_width = "fill",
        layout_height = "fill",
        id = "background",
        {
          GridView,
          layout_width = "fill",
          layout_height = "fill",
          layout_margin = "10dp",
          id = "gridview_1",
          NumColumns = '2',
          horizontalSpacing = "5dp",
          verticalSpacing = "5dp",
          ScrollBarStyle = ScrollView.SCROLLBARS_OUTSIDE_OVERLAY,
        }
      },
      {
        LinearLayoutCompat;
        orientation = "vertical",
        gravity = "center",
        layout_width = "fill",
        layout_height = "fill",
        id = "background_2",
        {
          ListView,
          layout_width = "fill",
          layout_height = "fill",
          layout_margin = "4dp",
          id = "listview_2",
          DividerHeight=0;
        }
      }
    }
  }
}

if not dlg_mode then
  setCommonView(content_view,"lua_course","back_with_search_mode")

  --按返回键两次退出
  parameter=0
  function onKeyDown(code,event)
    if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
      if parameter+2 > tonumber(os.time()) then
        activity.finish()
       else
        if search_bar_id.getVisibility()==0 then
          if Build.VERSION.SDK_INT >= 21 then
            circleopen(search_bar_id,H*0.6,W*0.2,W,0,500)
            task(500,function()
              search_bar_id.setVisibility(8)
            end)
           else
            search_bar_id.setVisibility(8)
          end
         else
          system_print(gets("back_tip"))
        end
        parameter=tonumber(os.time())
      end
      return true
    end
  end
end

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
--定时器
function stop(time,fun)
  t=Ticker()
  t.Period=time
  t.start()
  t.onTick=fun
end


--[[search_bar_cancel_button.onClick=function()
  if Build.VERSION.SDK_INT >= 21 then
    circleopen(search_bar_id,H*0.6,W*0.2,W,0,500)
    task(500,function()
      search_bar_id.setVisibility(8)
    end)
   else
    search_bar_id.setVisibility(8)
  end
end]]


import "android.view.animation.AccelerateInterpolator"
W=activity.width
H=activity.height
import "android.view.ViewAnimationUtils"
--揭开动画
function circleopen(v,centerX,centerY,startRadius,endRadius,time)
  animator = ViewAnimationUtils.createCircularReveal(v,centerX,centerY,startRadius,endRadius);
  animator.setInterpolator(AccelerateInterpolator());
  animator.setDuration(time);
  animator.start();
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


adp1=LuaAdapter(activity,type_table,gridview_item)
gridview_1.setAdapter(adp1)
for index,content in ipairs(教程分类) do
  local provider=provider_table[index]
  adp1.add{content={text=content},sub_content={text=provider}}
end
ripple_setting(type_table,adp1)


adp2=LuaAdapter(activity,course_table,listview_item)
listview_2.setAdapter(adp2)

function search_content()
  if get_setting("case_sensitive") then

    local key=(key)
    local to_be_searched_title=(title)
    local to_be_searched_content=(content)
    if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
      adp2.add{content={text=title},sub_content={text=content}}
    end
   else

    local key=utf8.lower(key)
    local to_be_searched_title=utf8.lower(title)
    local to_be_searched_content=utf8.lower(content)
    if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
      adp2.add{content={text=title},sub_content={text=content}}
    end
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

        if get_setting("case_sensitive") then

          local key=(key)
          local to_be_searched_title=(title)
          local to_be_searched_content=(content)
          if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
            adp2.add{content={text=title},sub_content={text=content}}
          end
         else

          local key=utf8.lower(key)
          local to_be_searched_title=utf8.lower(title)
          local to_be_searched_content=utf8.lower(content)
          if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
            adp2.add{content={text=title},sub_content={text=content}}
          end
        end
       else
        adp2.add{content={text=title},sub_content={text=content}}
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

        if get_setting("case_sensitive") then

          local key=(key)
          local to_be_searched_title=(title)
          local to_be_searched_content=(content)
          if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
            adp2.add{content={text=title},sub_content={text=content}}
          end
         else

          local key=utf8.lower(key)
          local to_be_searched_title=utf8.lower(title)
          local to_be_searched_content=utf8.lower(content)
          if to_be_searched_title:find(key) or to_be_searched_content:find(key) then
            adp2.add{content={text=title},sub_content={text=content}}
          end
        end
       else
        adp2.add{content={text=title},sub_content={text=content}}
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
    load_content()
    ripple_setting(course_table,adp2)

  end
},500)

--[[获取内容
function 获取内容(地址)
apo=io.open(地址):read("*a")
adp1=LuaAdapter(activity,列表布局)
listlb.setAdapter(adp1)
cit=apo:gmatch('》》\n《《(.-)》》')
for v2 in apo:gmatch('《《(.-)》》\n《《') do
  cit2=cit()
  adp1.add{bty=v2,nry=cit2}
end
end
if File(IDE_Data_Storage.."book.txt").exists() then
if io.open(IDE_Data_Storage.."book.txt"):read("*a")=="false" then
  手册内容储存文件路径=luajava.luadir.."/res/jcall"
 elseif io.open(IDE_Data_Storage.."book.txt"):read("*a")=="true" then
  手册内容储存文件路径=luajava.luadir.."/res/jcnotimport"
end
else
io.open(IDE_Data_Storage.."book.txt","w"):write("true"):close()
手册内容储存文件路径=luajava.luadir.."/res/jcall"
end
获取内容(手册内容储存文件路径)

function 搜索内容(地址)
apo=io.open(地址):read("*a")
adp1=LuaAdapter(activity,列表布局)
listlb.setAdapter(adp1)
cit=apo:gmatch('》》\n《《(.-)》》')
for v2 in apo:gmatch('《《(.-)》》\n《《') do
  cit22=utf8.lower(cit2)
  v22=utf8.lower(v2)
  cit2=cit()
  if cit22:find(bjkk.Text) or v22:find(bjkk.Text) then
    adp1.add{bty=v2,nry=cit2}
  end
end
end]]

--按钮事件
search_button.onClick=function()
  if Build.VERSION.SDK_INT >= 21 then
    stop(0,function()
      t.stop()
      circleopen(search_bar_id,H*0.6,W*0.2,0,H,500)
      search_bar_id.setVisibility(0)
    end)
   else
    search_bar_id.setVisibility(0)
  end
end
--列表点击事件
listview_2.onItemClick=function(p,v,i,s)
  local title=v.Tag.content.Text
  local content=v.Tag.sub_content.Text
  SkipPage("lua_course_preview",{title,content})
  return true
end

gridview_1.onItemClick=function(p,v,i,s)
  local type=v.Tag.content.Text
  if type==gets("all") then
    adp2.clear()
    load_content()
   else
    adp2.clear()
    get_content(type,keys)
  end
  pageview_id.showPage(1)
  return true
end


function search_incident()
  adp2.clear()
  load_content(search_bar_edit.Text)
  pageview_id.showPage(1)
  --[[if Build.VERSION.SDK_INT >= 21 then
    circleopen(search_bar_id,H*0.6,W*0.2,W,0,500)
    task(500,function()
      search_bar_id.setVisibility(8)
    end)
   else
    search_bar_id.setVisibility(8)
  end]]
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


