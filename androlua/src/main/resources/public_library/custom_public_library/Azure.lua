import "android.animation.*"
import "android.animation.AnimatorSet"

import "android.content.*"
import "android.content.Context"
import "android.content.Intent"

import "android.graphics.Color"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.drawable.ColorDrawable"
import "android.graphics.Typeface"

import "android.net.Uri"

import "android.view.*"
import "android.view.animation.*"
import "android.view.animation.Animation$AnimationListener"
import "android.view.animation.AccelerateDecelerateInterpolator"
import "android.view.inputmethod.InputMethodManager"
import "android.view.View$OnFocusChangeListener"

import "java.io.File"

LuaStudio1=import "themes.LuaStudio1"
LuaStudio2=import "themes.LuaStudio2"
Theme_LuaStudio=import "themes.Theme_LuaStudio"

-- parameter
status_bar_height = activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)

-- immersion_status_bar
function immersion_status_bar()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
end

--波纹
function 波纹(id,颜色)
  if Build.VERSION.SDK_INT <= 19 then
    local pressed = android.R.attr.state_pressed;
    local sd = StateListDrawable()
    id.setBackgroundDrawable(sd)
    sd.addState({ pressed }, ColorDrawable(颜色))
    --sd.addState({ 0 }, cd1)
   elseif Build.VERSION.SDK_INT > 19 then
    import "android.content.res.ColorStateList"
    local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
    local typedArray =activity.obtainStyledAttributes(attrsArray)
    ripple=typedArray.getResourceId(0,0)
    aoos=activity.Resources.getDrawable(ripple)
    aoos.setColor(ColorStateList(int[0].class{int{}},int{颜色}))
    id.setBackground(aoos.setColor(ColorStateList(int[0].class{int{}},int{颜色})))
  end
end
--控件圆角
function 控件圆角(id,颜色,圆角)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(颜色)
  drawable.setCornerRadii({圆角,圆角,圆角,圆角,圆角,圆角,圆角,圆角});
  id.setBackgroundDrawable(drawable)
end
--渐变
function ControlsGradient(left_jb,right_jb,id)
  drawable = GradientDrawable(GradientDrawable.Orientation.TR_BL,{
    right_jb,--右色
    left_jb,--左色
  });
  id.setBackgroundDrawable(drawable)
end

function get_status_bar_height()
  --这个需要系统SDK19以上才能用
  if Build.VERSION.SDK_INT <21 then
    return status_bar_height
   elseif Build.VERSION.SDK_INT >= 21 then
    return ""
  end
end

function set_status_bar_color(value)
  value=parseColor(value)
  window=activity.getWindow()
  window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(value);
end

function set_navigation_bar_color(color)
  if type(color)=="string" then
    color=parseColor(color)
   else
    color=color
  end
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().setNavigationBarColor(color);
   else
  end
end

-- parseColor
function parseColor(value)
  if type(value)=="string" then
    return Color.parseColor(value)
   else
    return value
  end
end

--修改颜色强度
function change_color_intensity(intensity,color)
  if type(color)=="string" then
    color=parseColor(color)
  end
  return (tonumber("0x"..intensity..string.sub(Integer.toHexString(color),3,8)))
end

function dp2int(dpValue)
  import "android.util.TypedValue"
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, activity.getResources().getDisplayMetrics())
end
-- dp2px
function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
--dp转px
function dp2px2(sdp)
  dm=this.getResources().getDisplayMetrics()
  types={px=0,dp=1,sp=2,pt=3,["in"]=4,mm=5}
  n,ty=sdp:match("^(%-?[%.%d]+)(%a%a)$")
  return TypedValue.applyDimension(types[ty],tonumber(n),dm)
end
-- px2dp
function px2dp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return pxValue / scale + 0.5
end
-- px2sp
function px2sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end
-- sp2px
function sp2px(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return spValue * scale + 0.5
end

-- Snakebar
SnackerBar = {
  shouldDismiss = true
}

function Snakebar(value)
  local w = activity.width

  local layout = {
    LinearLayoutCompat;
    Gravity = "bottom",
    paddingTop = activity.getResources().getDimensionPixelSize(
    luajava.bindClass("com.android.internal.R$dimen")().status_bar_height),
    {
      CardView,
      layout_height = -2,
      layout_width = -1,
      CardElevation = "0",
      CardBackgroundColor = "#FF202124",
      Radius = "4dp",
      layout_margin = "16dp",
      {
        LinearLayoutCompat;
        layout_height = -2,
        layout_width = -1,
        gravity = "left|center",
        padding = "16dp",
        -- paddingTop="12dp";
        -- paddingBottom="12dp";
        {
          TextView,
          textColor = "#ffffffff",
          textSize = "14sp",
          layout_height = -2,
          layout_width = -2,
          text = value,
          Typeface = load_font("tip")
        }
      }
    }
  }

  local function addView(view)
    local mLayoutParams = ViewGroup.LayoutParams(-1, -1)
    activity.Window.DecorView.addView(view, mLayoutParams)
  end

  local function removeView(view)
    activity.Window.DecorView.removeView(view)
  end

  function indefiniteDismiss(snackerBar)
    task(3000, function()
      if snackerBar.shouldDismiss == true then
        snackerBar:dismiss()
       else
        indefiniteDismiss(snackerBar)
      end
    end)
  end

  function SnackerBar:dismiss()
    local view = self.view
    view.animate().translationY(300).setDuration(400).setInterpolator(AccelerateDecelerateInterpolator())
    .setListener(Animator.AnimatorListener {
      onAnimationEnd = function()
        removeView(view)
      end
    }).start()
  end

  SnackerBar.__index = SnackerBar

  function SnackerBar.build()
    local mSnackerBar = {}
    setmetatable(mSnackerBar, SnackerBar)
    mSnackerBar.view = loadlayout(layout)
    mSnackerBar.bckView = mSnackerBar.view.getChildAt(0)
    mSnackerBar.textView = mSnackerBar.bckView.getChildAt(0)
    local function animate(v, tx, dura)
      ValueAnimator().ofFloat({v.translationX, tx}).setDuration(dura).addUpdateListener(
      ValueAnimator.AnimatorUpdateListener {
        onAnimationUpdate = function(p1)
          local f = p1.animatedValue
          v.translationX = f
          v.alpha = 1 - math.abs(v.translationX) / w
        end
      }).addListener(ValueAnimator.AnimatorListener {
        onAnimationEnd = function()
          if math.abs(tx) >= w then
            removeView(mSnackerBar.view)
          end
        end
      }).start()
    end
    local frx, p, v, fx = 0, 0, 0, 0
    mSnackerBar.bckView.setOnTouchListener(View.OnTouchListener {
      onTouch = function(view, event)
        if event.Action == event.ACTION_DOWN then
          mSnackerBar.shouldDismiss = false
          frx = event.x - dp2px(8)
          fx = event.x - dp2px(8)
         elseif event.Action == event.ACTION_MOVE then
          if math.abs(event.rawX - dp2px(8) - frx) >= 2 then
            v = math.abs((frx - event.rawX - dp2px(8)) / (os.clock() - p) / 1000)
          end
          p = os.clock()
          frx = event.rawX - dp2px(8)
          view.translationX = frx - fx
          view.alpha = 1 - math.abs(view.translationX) / w
         elseif event.Action == event.ACTION_UP then
          mSnackerBar.shouldDismiss = true
          local tx = view.translationX
          if tx >= w / 5 then
            animate(view, w, (w - tx) / v)
           elseif tx > 0 and tx < w / 5 then
            animate(view, 0, tx / v)
           elseif tx <= -w / 5 then
            animate(view, -w, (w + tx) / v)
           else
            animate(view, 0, -tx / v)
          end
          fx = 0
        end
        return true
      end
    })
    return mSnackerBar
  end

  function SnackerBar:show()
    local view = self.view
    addView(view)
    view.translationY = 300
    view.animate().translationY(0).setInterpolator(AccelerateDecelerateInterpolator()).setDuration(400).start()
    indefiniteDismiss(self)
  end

  SnackerBar.build():show()
end

--波纹
function Ripple(id,color,t)
  import "android.content.res.ColorStateList"
  local ripple
  if t=="圆" or t==nil then
    if not(RippleCircular) then
      RippleCircular=activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
    end
    ripple=RippleCircular
   elseif t=="方" then
    if not(RippleSquare) then
      RippleSquare=activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
    end
    ripple=RippleSquare
  end
  local Pretend=activity.Resources.getDrawable(ripple)
  if id then
    id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{color})))
   else
    return Pretend.setColor(ColorStateList(int[0].class{int{}},int{color}))
  end
end

function system_ripple(id, lx)
  xpcall(function()
    import "android.content.res.ColorStateList"
    -- Ripple
    ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0, 0)
    ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0, 0)

    for index,content in pairs(id) do
      if lx=="圆白" or lx=="circular_white" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="方白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆黑"or lx=="circular_black_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="方黑" or lx=="square_black_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="圆主题" or lx=="circular_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="方主题" or lx=="square_theme" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="圆自适应" then
        if theme_value=="day_time" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="方自适应" then
        if theme_value=="day_time" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="square_adaptive" then
        if theme_value=="day_time" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
    end
  end,function(e)end)
end

function GetFileMime(name)
  import "android.webkit.MimeTypeMap"
  ExtensionName=tostring(name):match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  return tostring(Mime)
end

function getUriForFile(file)
  uri=FileProvider.getUriForFile(activity,activity.getPackageName(),file);
  return uri
end

function installApk(path)
  import "android.content.*"
  import "android.net.*"
  import "java.io.File"
  file=File(path)
  intent = Intent(Intent.ACTION_VIEW);
  intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
  intent.setDataAndType(getUriForFile(file), GetFileMime(file.getName()));
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  activity.startActivity(Intent.createChooser(intent,file.getName()));
end

function write_file(file_path,content)
  import "java.io.File"
  --f=File(tostring(File(tostring(file_path)).getParentFile())).mkdirs()
  io.open(tostring(file_path),"w"):write(tostring(content)):close()
end
function WriteFile(file_path,content)
  import "java.io.File"
  f=File(tostring(File(tostring(file_path)).getParentFile())).mkdirs()
  io.open(tostring(file_path),"w"):write(tostring(content)):close()
end
function ReadFile(file_path)
  import "java.io.File"
  return io.open(tostring(file_path)):read("*a")
end


function get_file_size(path)
  import "java.io.File"
  import "android.text.format.Formatter"
  size=File(tostring(path)).length()
  Sizes=Formatter.formatFileSize(activity, size)
  return Sizes
end

function size_conversion(a)
  if a>=1024 then
    local b=tonumber(string.format("%.2f",a/1024))
    if b>=1024 then
      return string.format("%.2fMB",b/1024)
     else
      return b.."KB"
    end
   else
    return a.."B"
  end
end

function webview_removeAD(class_name)
  --网页加载完成
  webView.loadJs([[
//创建广告类名字符串
var classNames=new Array(]]..class_name..[[);
//主要拦截广告函数
function removeAD(){ 
  for(index=0;index<classNames.length;index++){  
    if (classNames[index].indexOf("@ID(")>=0){
     document.getElementById(classNames[index].substring(4,classNames[index].length-1)).style.display="none"      
      }else{
         var elements=document.getElementsByClassName(classNames[index])  
         for(i=0;i<elements.length;i++){ 
         elements[i].style.display="none"
        }                                                                                
     }                                          
   }                                           
}                   
//添加定时器
mInterval=window.setInterval(removeAD,0);
//添加一次性定时器
mTimeout=window.setTimeout(function(e){ 
  window.clearInterval(mInterval)
  window.clearTimeout(mTimeout) 
},50);
//添加元素改变监听
window.addEventListener('DOMSubtreeModified',removeAD)]])
end

function view_radius(view,radiu,InsideColor)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end

function setImage(id,src)
  if Glide then
    Glide.with(activity).load(src).into(id)
   else
    id.setImageBitmap(loadbitmap(src))
  end
end