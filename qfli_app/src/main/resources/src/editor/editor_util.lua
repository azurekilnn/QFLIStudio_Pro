--NoScrollViewPager
function NoScrollViewPager()
  return luajava.override(ViewPager,{
    onInterceptTouchEvent=function(super,event)
      return false
    end,
    onTouchEvent=function(super,event)
      return true
    end
  })
end

--AutoScrollViewPager
function AutoScrollViewPager()
  return luajava.override(ViewPager,{
    onInterceptTouchEvent=function(super,event)
      if editorSelectionChangeEventStatus then
        return false
       else
        return super(event)
      end
    end
  })
end

--EditorViewPager
function AutoEditorViewPager(values)
  if current_editor_name=="SoraEditor" or values["scroll"] then
    local layout_view_pager={
      LinearLayoutCompat;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {
        AutoScrollViewPager;
        layout_weight="1";
        layout_height="fill";
        layout_width="fill";
        id=values["id"] or "vp";
      };
    };
    local view_pager=loadlayout(layout_view_pager)
    return function() return view_pager end
   else
    local layout_view_pager={
      LinearLayoutCompat;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {
        NoScrollViewPager;
        layout_weight="1";
        layout_height="fill";
        layout_width="fill";
        id=values["id"] or "vp";
      };
    };
    local view_pager=loadlayout(layout_view_pager)
    return function() return view_pager end
  end
end

--custom editor
local function custom_editor(id,name,text)
  local editors={
    ["SoraEditor"]="io.github.rosemoe.sora.widget.CodeEditor",
    ["LuaEditor"]="com.androlua.LuaEditor",
    ["MyEditor"]="com.luastudio.azure.MyEditor"
  }
  local LuaStudioEditor=luajava.bindClass(editors[name])
  return {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    {
      LuaStudioEditor,
      layout_weight = "1",
      layout_width = "fill",
      --Typeface = load_font("editor"),
      id = id or "editor",
      text=text or "";
      layout_height="fill",
    };
  };
end


function create_editor(id,name,text)
  local editor_view=loadlayout(custom_editor(id,name,text))
  return editor_view
end

function create_editor_page(id,file_type)
  local file_types={
    lua="editor",
    aly="editor",
    java="editor",
    xml="editor",
    txt="editor",
    css="editor",
  }
  local page_type=file_types[file_type]
  local page_types={
    PhotoView=luajava.bindClass("com.luastudio.azure.widget.PhotoView"),

  }
  local page_layout={
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    {
      LuaStudioPhotoView,
      layout_weight="1",
      layout_width="fill",
      --Typeface=load_font("editor"),
      id=(id or "editor"),
      layout_height="fill",
    };
  };
  local page_view=loadlayout(page_layout)
end

--图片控件
function create_photoview(id,src)
  local LuaStudioPhotoView=luajava.bindClass("com.luastudio.azure.widget.PhotoView")
  local photo_view={
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    {
      LuaStudioPhotoView,
      layout_weight = "1",
      layout_width = "fill",
      --Typeface = load_font("editor"),
      scaleType="fitCenter",
      id = id or "photoview",
      layout_height = "fill",
    };
  };
  local photo_view=loadlayout(photo_view)
  local photoview=photo_view.getChildAt(0)
  setImage(photoview,src)
  photoview.enable()
  return photo_view
end

--右侧滑RecyclerView
function create_drawer_rv(values)
  local rotate_straight=RotateAnimation(0,180,Animation.RELATIVE_TO_SELF,0.5,Animation.RELATIVE_TO_SELF,0.5)
  rotate_straight.setDuration(256)
  rotate_straight.setFillAfter(true)

  local rotate_inverted=RotateAnimation(180,0,Animation.RELATIVE_TO_SELF,0.5,Animation.RELATIVE_TO_SELF,0.5)
  rotate_inverted.setDuration(256)
  rotate_inverted.setFillAfter(true)

  local drawer_rv={
    LinearLayoutCompat;
    orientation="vertical";
    layout_width="fill";
    {
      LinearLayoutCompat;
      layout_height="42dp";
      layout_width="80%w";
      gravity="left|center";
      layout_marginTop="8dp";
      {
        ImageView;
        ColorFilter=pc(text_color);
        src=load_icon_path("keyboard_arrow_down");
        layout_height="32dp";
        layout_width="32dp";
        layout_marginLeft="8dp";
        padding="4dp";
      };
      {
        TextView;
        text=values["title"] or "";
        Typeface=load_font("common");
        textSize="14sp";
        textColor=text_color;
        paddingLeft="8dp";
      };
    };
    {
      RecyclerView;
      layout_height="-2";
      Visibility="8";
      layout_margin="8dp";
      layout_width="-1";
      id=values["id"] or "drawer_rv";
    };
  }
  local drawer_rv_root=loadlayout(drawer_rv)
  local drawer_item=drawer_rv_root.getChildAt(0)
  local drawer_rv=drawer_rv_root.getChildAt(1)
  drawer_item.onClick=function()
    if drawer_rv.getVisibility()==0 then
      drawer_rv.setVisibility(8)
      drawer_item.getChildAt(0).startAnimation(rotate_inverted)
     else
      drawer_rv.setVisibility(0)
      drawer_item.getChildAt(0).startAnimation(rotate_straight)
    end
  end
  system_ripple({drawer_item},"square_adaptive")
  if values["show"] then
    drawer_item.getChildAt(0).startAnimation(rotate_straight)
    drawer_rv.setVisibility(0)
  end
  return function() return drawer_rv_root end
end