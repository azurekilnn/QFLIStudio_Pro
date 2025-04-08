set_style()
require "system_actionbar"
import "system.system_dialogs"
import "com.androlua.*"
import "layout_helper_config"
require "layout_helper_funlib"
import "loadlayout2"
--print(dump(relative))
load_settings()
layout={
  main={
    LinearLayoutCompat;
    orientation="vertical",
  },
  ck={
    LinearLayoutCompat;
    {
      RadioGroup;
      layout_weight="1";
      id="ck_rg";
    };
    {
      Button;
      text=gets("ok_button");
      layout_gravity="right";
      id="ck_bt";
    };
    orientation="vertical";
  };
}

luadir,luapath=...
--luadir,luapath="/storage/emulated/0/LuaStudio_Pro/project/UpdateApp/app/src/main/assets/","/storage/emulated/0/LuaStudio_Pro/project/UpdateApp/app/src/main/assets/layout.aly"
luadir=luadir or luapath:gsub("/[^/]+$","")
package.path=package.path..";"..luadir.."/?.lua"
if luapath:find("%.aly$") then
  local f=io.open(luapath)
  local s=f:read("*a")
  f:close()
  xpcall(function()
    layout.main=assert(loadstring("return "..s))()
  end,
  function()
    --不支持编辑
    system_print(gets("editor_layout_error"))
    activity.finish()
  end)
  showsave=true
end

function onTouch(v,e)
  if e.getAction() == MotionEvent.ACTION_DOWN then
    getCurr(v)
    return true
  end
end

local TypedValue=luajava.bindClass("android.util.TypedValue")
local dm=activity.getResources().getDisplayMetrics()
function dp(n)
  return TypedValue.applyDimension(1,n,dm)
end

function to(n)
  return string.format("%ddp",n//dn)
end

dn=dp(1)
lastX=0
lastY=0
vx=0
vy=0
vw=0
vh=0
zoomX=false
zoomY=false
function move(v,e)
  curr=v.Tag
  currView=v
  ry=e.getRawY()--获取触摸绝对Y位置
  rx=e.getRawX()--获取触摸绝对X位置
  if e.getAction() == MotionEvent.ACTION_DOWN then
    lp=v.getLayoutParams()
    vy=v.getY()--获取视图的Y位置
    vx=v.getX()--获取视图的X位置
    lastY=ry--记录按下的Y位置
    lastX=rx--记录按下的X位置
    vw=v.getWidth()--记录控件宽度
    vh=v.getHeight()--记录控件高度
    if vw-e.getX()<20 then
      zoomX=true--如果触摸右边缘启动缩放宽度模式
     elseif vh-e.getY()<20 then
      zoomY=true--如果触摸下边缘启动缩放高度模式
    end

   elseif e.getAction() == MotionEvent.ACTION_MOVE then
    --lp.gravity=Gravity.LEFT|Gravity.TOP --调整控件至左上角
    if zoomX then
      lp.width=(vw+(rx-lastX))--调整控件宽度
     elseif zoomY then
      lp.height=(vh+(ry-lastY))--调整控件高度
     else
      lp.x=(vx+(rx-lastX))--移动的相对位置
      lp.y=(vy+(ry-lastY))--移动的相对位置
    end
    v.setLayoutParams(lp)--调整控件到指定的位置
    --v.Parent.invalidate()
   elseif e.getAction() == MotionEvent.ACTION_UP then
    if (rx-lastX)^2<100 and (ry-lastY)^2<100 then
      getCurr(v)
     else
      curr.layout_x=to(v.getX())
      curr.layout_y=to(v.getY())
      if zoomX then
        curr.layout_width=to(v.getWidth())
       elseif zoomY then
        curr.layout_height=to(v.getHeight())
      end
    end
    zoomX=false--初始化状态
    zoomY=false--初始化状态
  end
  return true
end

function getCurr(v)
  curr=v.Tag
  currView=v
  fd_dlg.setView(View(activity))
  fd_dlg.Title=tostring(v.Class.getSimpleName())
  if luajava.instanceof(v,GridLayout) then
    fd_dlg.setItems(fds_grid)
   elseif luajava.instanceof(v,CardView) then
    fd_dlg.setItems(fds_card)
   elseif luajava.instanceof(v,LinearLayout) then
    fd_dlg.setItems(fds_linear)
   elseif luajava.instanceof(v,ViewGroup) then
    fd_dlg.setItems(fds_group)
   elseif luajava.instanceof(v,TextView) then
    fd_dlg.setItems(fds_text)
   elseif luajava.instanceof(v,ImageView) then
    fd_dlg.setItems(fds_image)
   else
    fd_dlg.setItems(fds_view)
  end
  if luajava.instanceof(v.Parent,LinearLayout) then
    fd_list.getAdapter().add("layout_weight")
   elseif luajava.instanceof(v.Parent,AbsoluteLayout) then
    fd_list.getAdapter().insert(5,"layout_x")
    fd_list.getAdapter().insert(6,"layout_y")
   elseif luajava.instanceof(v.Parent,RelativeLayout) then
    local adp=fd_list.getAdapter()
    for k,v in ipairs(relative) do
      adp.add(v)
    end
  end
  fd_list.setDividerHeight(0)
  fd_dlg2=fd_dlg.show()
  set_dialog_style(fd_dlg2)
end

function adapter(t)
  local ls=ArrayList()
  for k,v in ipairs(t) do
    ls.add(v)
  end
  return ArrayAdapter(activity,android.R.layout.simple_list_item_1, ls)
end

--属性列表对话框
fd_dlg=AlertDialogBuilder(activity)
fd_list=fd_dlg.getListView()

import "android.graphics.drawable.*"
gd=GradientDrawable()
gd.setColor(0x00ffffff)
gd.setStroke(3,0x70000000,5,5)
gd.setGradientRadius(700)
gd.setGradientType(1)

curr=nil
activity.setTitle(gets("layout_helper"))

xpcall(function()
  activity.setContentView(loadlayout2(layout.main,{}))
end,
function()
  system_print(gets("editor_layout_error"))
  --system_print("不支持编辑该布局")
  activity.finish()
end)


rbs={"layout_alignParentBottom","layout_alignParentEnd","layout_alignParentLeft","layout_alignParentRight","layout_alignParentStart","layout_alignParentTop","layout_centerHorizontal","layout_centerInParent","layout_centerVertical"}
ris={"layout_above","layout_alignBaseline","layout_alignBottom","layout_alignEnd","layout_alignLeft","layout_alignRight","layout_alignStart","layout_alignTop","layout_alignWithParentIfMissing","layout_below","layout_toEndOf","layout_toLeftOf","layout_toRightOf","layout_toStartOf"}
for k,v in ipairs(rbs) do
  checks[v]={"true","false","none"}
end

for k,v in ipairs(ris) do
  checks[v]=checkid
end

function addDir(out,dir,f)
  local ls=f.listFiles()
  for n=0,#ls-1 do
    local name=ls[n].getName()
    if ls[n].isDirectory() then
      addDir(out,dir..name.."/",ls[n])
     elseif name:find("%.j?pn?g$") then
      table.insert(out,dir..name)
    end
  end
end

function checkid()
  local cs={}
  local parent=currView.Parent.Tag
  for k,v in ipairs(parent) do
    if v==curr then
      break
    end
    if type(v)=="table" and v.id then
      table.insert(cs,v.id)
    end
  end
  return cs
end



if luadir then
  checks.src=function()
    local src={}
    addDir(src,"",File(luadir))
    return src
  end
end


edit_dlg_layout={
  LinearLayoutCompat;
  layout_width="fill";
  layout_height="fill";
  orientation="vertical";
  {
    EditText;
    layout_width="fill";
    layout_height="fill";
    layout_margin="15dp";
    backgroundColor=gray_color;
    id="edit"
  };
};

fd_list.onItemClick=function(l,v,p,i)
  fd_dlg.hide()
  local fd=tostring(v.Text)
  if checks[fd] then
    if type(checks[fd])=="table" then
      check_dlg.Title=fd
      check_dlg.setItems(checks[fd])
      check_dlg2=check_dlg.show()
      set_dialog_style(check_dlg2)
     else
      if fd=="src" then
        check_dlg.Title=fd
        check_dlg.setItems(checks[fd](fd))
        check_dlg.setPositiveButton(gets("ok_button"),nil)
        check_dlg.setNeutralButton(gets("online_url"),function()
          check_dlg.hide()

          edit_dlg=AlertDialogBuilder(activity)
          edit_dlg.setTitle(gets("online_url"))
          edit_dlg.setView(loadlayout(edit_dlg_layout))
          edit_dlg.setPositiveButton(gets("ok_button"),{onClick=function()
              local old=curr["src"]
              curr["src"]=edit.text
              edit_dlg.dismiss()
              local s,l=pcall(loadlayout2,layout.main,{})
              if s then
                activity.setContentView(l)
               else
                curr["src"]=old
                system_print(tostring(l))
              end
            end})
          edit_dlg.setNegativeButton(gets("cancel_button"),nil)
          edit_dlg2=edit_dlg.show()
          set_dialog_style(edit_dlg2)
        end)

        check_dlg2=check_dlg.show()
        set_dialog_style(check_dlg2)
       else
        check_dlg.Title=fd
        check_dlg.setItems(checks[fd](fd))
        check_dlg2=check_dlg.show()
        set_dialog_style(check_dlg2)
      end
    end
   else
    func[fd]()
  end
end

--子视图列表对话框
cd_dlg=AlertDialogBuilder(activity)
cd_list=cd_dlg.getListView()
cd_list.setDividerHeight(0)
cd_list.onItemClick=function(l,v,p,i)
  getCurr(chids[p])
  cd_dlg.hide()
end

--可选属性对话框
check_dlg=AlertDialogBuilder(activity)
check_list=check_dlg.getListView()
check_list.onItemClick=function(l,v,p,i)
  local v=tostring(v.Text)
  if #v==0 or v=="none" then
    v=nil
  end
  local fld=check_dlg.Title
  local old=curr[tostring(fld)]
  curr[tostring(fld)]=v
  check_dlg.hide()
  local s,l=pcall(loadlayout2,layout.main,{})
  if s then
    activity.setContentView(l)
   else
    curr[tostring(fld)]=old
    system_print(tostring(l))

  end
end

func={}
setmetatable(func,{__index=function(t,k)
    return function()
      sfd_dlg.Title=k--tostring(currView.Class.getSimpleName())
      fld.Text=curr[k] or ""
      sfd_dlg2=sfd_dlg.show()

      (sfd_dlg2)
    end
  end
})
func[gets("add")]=function()
  add_dlg.Title=tostring(currView.Class.getSimpleName())
  for n=0,#ns-1 do
    if n~=i then
      el.collapseGroup(n)
    end
  end
  add_dlg2=add_dlg.show()

  set_dialog_style(add_dlg2)
end

func[gets("delete")]=function()
  delete_tip_dialog=AlertDialogBuilder(this)
  delete_tip_dialog.setTitle(gets("tip_text"))--提示
  delete_tip_dialog.setMessage(gets("layout_delete_tip"))--删除后无法恢复，是否删除此控件。
  delete_tip_dialog.setPositiveButton(gets("ok_button"),{onClick=function()
      local gp=currView.Parent.Tag
      if gp==nil then
        --不可以删除最底层控件
        system_print(gets("layout_delete_error_tip"))
        return
      end
      for k,v in ipairs(gp) do
        if v==curr then
          table.remove(gp,k)
          break
        end
      end
      activity.setContentView(loadlayout2(layout.main,{}))
    end})
  delete_tip_dialog.setNegativeButton(gets("cancel_button"),nil)
  delete_tip_dialog2=delete_tip_dialog.show()
  set_dialog_style(delete_tip_dialog2)
end

func[gets("parent_widget")]=function()
  local p=currView.Parent
  if p.Tag==nil then
    --已是最底层控件
    system_print(gets("parent_widget_click_error"))
   else
    getCurr(p)
  end
end

chids={}
func[gets("children_widget")]=function()
  chids={}
  local arr={}
  for n=0,currView.ChildCount-1 do
    local chid=currView.getChildAt(n)
    chids[n]=chid
    table.insert(arr,chid.Class.getSimpleName())
  end
  cd_dlg.Title=tostring(currView.Class.getSimpleName())
  cd_dlg.setItems(arr)
  cd_dlg2=cd_dlg.show()
  set_dialog_style(cd_dlg2)
end

--添加视图对话框
add_dlg=AlertDialogBuilder(this)
add_dlg.Title=gets("add")
wdt_list=ListView(activity)
wdt_list.setDividerHeight(0)
mAdapter=ArrayExpandableListAdapter(activity)
for k,v in ipairs(ns) do
  mAdapter.add(v,wds2[k])
end

el=ExpandableListView(activity)
el.setAdapter(mAdapter)
add_dlg.setView(el)

el.onChildClick=function(l,v,g,c)
  local w={_G[wds[g+1][c+1]]}
  table.insert(curr,w)
  local s,l=pcall(loadlayout2,layout.main,{})
  if s then
    activity.setContentView(l)
   else
    table.remove(curr)
    system_print(tostring(l))

  end
  add_dlg.hide()
end
function ok()
  local v=tostring(fld.Text)
  if #v==0 then
    v=nil
  end
  local fld=sfd_dlg.Title
  local old=curr[tostring(fld)]
  curr[tostring(fld)]=v
  --sfd_dlg.hide()
  local s,l=pcall(loadlayout2,layout.main,{})
  if s then
    activity.setContentView(l)
   else
    curr[tostring(fld)]=old
    system_print(tostring(l))

  end
end

function none()
  local old=curr[tostring(sfd_dlg.Title)]
  curr[tostring(sfd_dlg.Title)]=nil
  --sfd_dlg.hide()
  local s,l=pcall(loadlayout2,layout.main,{})
  if s then
    activity.setContentView(l)
   else
    curr[tostring(sfd_dlg.Title)]=old
    system_print(tostring(l))

  end
end

--输入属性对话框
sfd_dlg=AlertDialogBuilder(activity)
sfd_dlg_layout={
  LinearLayoutCompat;
  layout_width="fill";
  layout_height="fill";
  orientation="vertical";
  {
    EditText;
    layout_width="fill";
    layout_height="fill";
    layout_margin="15dp";
    backgroundColor=gray_color;
    id="fld"
  };
};
sfd_dlg.setView(loadlayout(sfd_dlg_layout))
sfd_dlg.setPositiveButton(gets("ok_button"),{onClick=ok})
sfd_dlg.setNegativeButton(gets("cancel_button"),nil)
sfd_dlg.setNeutralButton(gets("nothing"),{onClick=none})
function dumparray(arr)
  local ret={}
  table.insert(ret,"{\n")
  for k,v in ipairs(arr) do
    table.insert(ret,string.format("\"%s\";\n",v))
  end
  table.insert(ret,"};\n")
  return table.concat(ret)
end
function dumplayout(t)
  table.insert(ret,"{\n")
  table.insert(ret,tostring(t[1].getSimpleName()..";\n"))
  for k,v in pairs(t) do
    if type(k)=="number" then
      --do nothing
     elseif type(v)=="table" then
      table.insert(ret,k.."="..dumparray(v))
     elseif type(v)=="string" then
      if v:find("[\"\'\r\n]") then
        table.insert(ret,string.format("%s=[==[%s]==];\n",k,v))
       else
        table.insert(ret,string.format("%s=\"%s\";\n",k,v))
      end
     else
      table.insert(ret,string.format("%s=%s;\n",k,tostring(v)))
    end
  end
  for k,v in ipairs(t) do
    if type(v)=="table" then
      dumplayout(v)
    end
  end
  table.insert(ret,"};\n")
end

function dumplayout2(t)
  ret={}
  dumplayout(t)
  return table.concat(ret)
end

function onCreateOptionsMenu(menu)
  menu.add(gets("copy"))
  menu.add(gets("edit"))
  menu.add(gets("preview"))
  if showsave then
    menu.add(gets("save"))
  end
end

function get_file_last_time(path)
  f = File(path);
  time = f.lastModified()
  return time
end
function write_file(path,content)
  if (path and content) then
    File(tostring(File(tostring(path)).getParentFile())).mkdirs()
    io.open(path,"w"):write(content):close()
  end
end
function save(s)
  if get_editor_setting("old_file_backup") then
    local file_name=File(luapath)["name"]
    local file_path_2=tostring(activity.getExternalFilesDir("layout_helper_backup"))
    local backup_file_path=file_path_2.."/backup_"..get_file_last_time(luapath).."_"..file_name
    -- print(backup_file_path)
    local old_file_content=io.open(luapath):read("*a")
    write_file(backup_file_path,old_file_content)
  end
  local f=io.open(luapath,"w")
  f:write(s)
  f:close()
end

copy_board=activity.getSystemService(activity.CLIPBOARD_SERVICE)

function onMenuItemSelected(id,item)
  local item_text=item.getTitle()
  if item_text==(gets("copy")) then
    local cd = ClipData.newPlainText("label",dumplayout2(layout.main))
    copy_board.setPrimaryClip(cd)
    system_print(gets("copy_tip"))
    --system_print("已复制到剪切板")
    --[[elseif item_text==(gets("edit")) then
    --editlayout(dumplayout2(layout.main))
    SkipPage("layout_editor",{dumplayout2(layout.main)})]]
   elseif item_text==(gets("preview")) then
    show(dumplayout2(layout.main))
   elseif item_text==(gets("save")) then
    save(dumplayout2(layout.main))
    system_print(gets("save_succeed"))
    activity.setResult(10000,Intent());
    activity.result({"layout_save_result"})
  end
end

function onOptionsItemSelected(item)
  onMenuItemSelected(item.getItemId(), item)
end

function onStart()
  activity.setContentView(loadlayout2(layout.main,{}))
end

function onKeyDown(e)
  if e==4 then
    if showsave then
      local save_dialog=AlertDialog.Builder(this)
      save_dialog.setTitle(gets("tip_text"))--提示
      save_dialog.setMessage(gets("layout_save_tip"))--是否保存当前状态？
      save_dialog.setPositiveButton(gets("save"),{onClick=function()
          save(dumplayout2(layout.main))
          system_print(gets("save_succeed"))
          activity.setResult(10000,Intent());
          activity.result({"layout_save_result"})
        end})
      save_dialog.setNegativeButton(gets("exit"),{onClick=function()
          activity.finish()
        end})
      save_dialog2=save_dialog.show()
      set_dialog_style(save_dialog2)
      return true
    end
  end
end