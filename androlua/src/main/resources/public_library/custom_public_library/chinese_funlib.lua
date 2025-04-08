import {
  "android.app.*",
  "android.app.ActionBar$TabListener",
  "android.app.AlertDialog",
  "android.app.SearchManager",
  "android.animation.ObjectAnimator",
  "android.animation.ArgbEvaluator",
  "android.animation.ValueAnimator",
  "android.content.*",
  "android.content.DialogInterface",
  "android.content.Context",
  "android.content.Intent",
  "android.content.pm.PackageManager",
  "android.content.pm.ApplicationInfo",
  "android.content.res.*",
  "android.content.SharedPreferences",
  "android.graphics.*",
  "android.graphics.Bitmap",
  "android.graphics.Color",
  "android.graphics.drawable.*",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.graphics.drawable.GradientDrawable",
  "android.graphics.PorterDuff",
  "android.graphics.PorterDuffColorFilter",
  "android.graphics.Typeface",
  "android.graphics.Matrix",
  "android.graphics.Paint",
  "android.graphics.PorterDuffXfermode",
  "android.graphics.RectF",
  "android.graphics.PorterDuff$Mode",
  "android.graphics.Rect",
  "android.graphics.Canvas",
  "android.graphics.BitmapFactory",
  "android.media.MediaPlayer",
  "android.media.MediaMetadataRetriever",
  "android.net.*",
  "java.net.URLDecoder",
  "android.net.Uri",
  "android.net.TrafficStats",
  "android.os.*",
  "android.os.Build",
  "android.opengl.*",
  "android.provider.MediaStore",
  "android.provider.Settings",
  "android.provider.Settings$Secure",
  "android.telephony.*",
  "android.text.Html",
  "android.text.format.Formatter",
  "android.text.SpannableString",
  "android.text.style.ForegroundColorSpan",
  "android.text.Spannable",
  "android.util.Config",
  "android.util.DisplayMetrics",
  "android.view.*",
  "android.view.animation.*",
  "android.view.animation.Animation$AnimationListener",
  "android.view.animation.AnimationUtils",
  "android.view.animation.LayoutAnimationController",
  "android.view.inputmethod.InputMethodManager",
  "android.view.View$OnFocusChangeListener",
  "android.webkit.MimeTypeMap",
  "android.widget.*",
  "android.widget.ArrayAdapter",
  "android.widget.LinearLayout",
  "android.widget.EditText",
  "android.widget.ListView",
  "android.widget.PullingLayout",
  "android.widget.TextView",
  "android.widget.TimePicker$OnTimeChangedListener",
  "java.io.File",
  "java.io.FileOutputStream",
  "java.lang.String",
  "java.util.zip.ZipFile"
}
--intent类操作--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1.调用系统发送短信
function 调用系统发送短信(number,content)
  local uri = Uri.parse("smsto:"..number)
  local intent = Intent(Intent.ACTION_SENDTO, uri)
  intent.putExtra("sms_body",content)
  intent.setAction("android.intent.action.VIEW")
  activity.startActivity(intent)
end
--2.加QQ群
function 加QQ群(group_number)
  local url = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..group_number.."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end
--3.联系QQ
function 联系QQ(qq_number)
  local url = "mqqwpa://im/chat?chat_type=wpa&uin="..qq_number
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end
--4.分享文件
function 分享文件(path)
  local FileName = tostring(File(path).Name)
  local ExtensionName = FileName:match("%.(.+)")
  local Mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)

  local intent = Intent();
  intent.setAction(Intent.ACTION_SEND);
  intent.setType(Mime);

  local file = File(path);
  local uri = Uri.fromFile(file);
  intent.putExtra(Intent.EXTRA_STREAM,uri);
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  activity.startActivity(Intent.createChooser(intent, "分享到:"));
end
--5.分享文本
function 分享文本(test_content)
  local intent=Intent(Intent.ACTION_SEND);
  intent.setType("text/plain");
  intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
  intent.putExtra(Intent.EXTRA_TEXT,test_content);
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  activity.startActivity(Intent.createChooser(intent,"分享到:"));
end
--6.调用系统浏览器搜索
function 调用系统浏览器搜索(search_content)
  local intent = Intent()
  intent.setAction(Intent.ACTION_WEB_SEARCH)
  intent.putExtra(SearchManager.QUERY,search_content)
  activity.startActivity(intent)
end
--7.调用系统浏览器打开链接
function 调用系统浏览器打开链接(网页链接)
  local viewIntent = Intent("android.intent.action.VIEW",Uri.parse(网页链接))
  activity.startActivity(viewIntent)
end
--8.打开程序
function 打开程序(程序包名)
  local manager = activity.getPackageManager()
  local open = manager.getLaunchIntentForPackage(程序包名)
  activity.startActivity(open)
end
--9.安装程序
function 安装程序(安装包路径)
  local intent = Intent(Intent.ACTION_VIEW)
  intent.setDataAndType(Uri.parse("file://"..安装包路径), "application/vnd.android.package-archive")
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  activity.startActivity(intent)
end
--10.卸载程序
function 卸载程序(包名)
  local uri = Uri.parse("package:"..包名)
  local intent = Intent(Intent.ACTION_DELETE,uri)
  activity.startActivity(intent)
end
--11.播放MP4
function 播放MP4(视频路径)
  local intent = Intent(Intent.ACTION_VIEW)
  local uri = Uri.parse("file://"..视频路径)
  intent.setDataAndType(uri,"video/mp4")
  activity.startActivity(intent)
end
--12.播放MP3
function 播放MP3(音乐路径)
  local intent = Intent(Intent.ACTION_VIEW)
  local uri = Uri.parse("file://"..音乐路径)
  intent.setDataAndType(uri,"audio/mp3")
  this.startActivity(intent)
end
--13.拨号
function 拨号(电话号码)
  local uri = Uri.parse("tel:"..电话号码);
  local intent = Intent(Intent.ACTION_CALL,uri);
  intent.setAction("android.intent.action.VIEW");
  activity.startActivity(intent);
end
--14.搜索应用
function 搜索应用(包名)
  local intent = Intent("android.intent.action.VIEW")
  intent .setData(Uri.parse( "market://details?id="..包名))
  activity.startActivity(intent)
end
--14.调用系统打开文件
function 调用系统打开文件(path)
  local FileName=tostring(File(path).Name)
  local ExtensionName=FileName:match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  if Mime then
    intent = Intent()
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.setAction(Intent.ACTION_VIEW);
    intent.setDataAndType(Uri.fromFile(File(path)), Mime);
    activity.startActivity(intent)
    return true
   else
    return false
  end
end
--16.发送彩信
function 发送彩信(图片路径,邮件地址,邮件内容,类型)
  local uri=Uri.parse("file://"..图片路径) --图片路径
  local intent = Intent();
  intent.setAction(Intent.ACTION_SEND);
  intent.putExtra("address",邮件地址) --邮件地址
  intent.putExtra("sms_body",邮件内容) --邮件内容
  intent.putExtra(Intent.EXTRA_STREAM,uri)
  intent.setType(类型) --设置类型
  activity.startActivity(intent)
end
--17.调用系统设置
function 打开系统设置(value)
  local operation_table={
    系统设置=Settings.ACTION_SETTINGS,
    APN设置=Settings.ACTION_APN_SETTINGS,
    位置和访问信息设置=Settings.ACTION_LOCATION_SOURCE_SETTINGS,
    网络设置=Settings.ACTION_WIRELESS_SETTINGS,
    无线和网络热点设置=Settings.ACTION_AIRPLANE_MODE_SETTINGS,
    位置和安全设置=Settings.ACTION_SECURITY_SETTINGS,
    WIFI设置=Settings.ACTION_WIFI_SETTINGS,
    无线网IP设置=Settings.ACTION_WIFI_IP_SETTINGS,
    蓝牙设置=Settings.ACTION_BLUETOOTH_SETTINGS,
    时间和日期设置=Settings.ACTION_DATE_SETTINGS,
    声音设置=Settings.ACTION_SOUND_SETTINGS,
    显示设置=Settings.ACTION_DISPLAY_SETTINGS,
    语言设置=Settings.ACTION_LOCALE_SETTINGS,
    输入法设置=Settings.ACTION_INPUT_METHOD_SETTINGS,
    用户词典=Settings.ACTION_USER_DICTIONARY_SETTINGS,
    应用程序设置=Settings.ACTION_APPLICATION_SETTINGS,
    应用程序开发设置=Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS,
    快速启动设置=Settings.ACTION_QUICK_LAUNCH_SETTINGS,
    已下载软件列表=Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS,
    应用程序数据同步设置=Settings.ACTION_SYNC_SETTINGS,
    可用网络搜索=Settings.ACTION_NETWORK_OPERATOR_SETTINGS,
    移动网络设置=Settings.ACTION_DATA_ROAMING_SETTINGS,
    默认内部存储设置=Settings.ACTION_INTERNAL_STORAGE_SETTINGS,
    默认外部存储设置=Settings.ACTION_MEMORY_CARD_SETTINGS
  }
  if value then
    local intent = Intent(operation_table[value]);
    activity.startActivity(intent);
   else
    local intent = Intent(operation_table["系统设置"]);
    activity.startActivity(intent);
  end
end
--以下函数必须依赖MyWebView--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--进入子页面
function 进入子页面(activity_file,value)
  if not value and activity_file then
    activity.newActivity(页面)
   elseif value and activity_file then
    if value["链接"] and not value["链接"] then
      activity.newActivity(activity_file,{value["链接"]})
     elseif value["链接"] and value["标题"] then
      activity.newActivity(activity_file,{value["链接"],value["标题"]})
    end
  end
end
--加载Js
function 加载Js(a)
  webView.loadJs(a)
end
function 删除网页元素(m)
  --网页加载完成
  webView.loadJs([[
  //创建广告类名字符串
  var classNames=new Array(]]..m..[[);
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
  },5000);
  //添加元素改变监听
  window.addEventListener('DOMSubtreeModified',removeAD)]])
end
--加载网页
function 加载网页(b)
  webView.loadUrl(b)
end
--刷新网页
function 刷新网页()
  webView.loadUrl(webView.getUrl())
end
--网页前进
function 网页前进()
  webView.goForward()
end
--网页后退
function 网页后退()
  webView.goBack()
end
--停止加载
function 停止加载()
  webView.stopLoading()
end
--退出程序
function 退出程序()
  os.exit()
end
--退出页面
function 退出页面()
  activity.finish()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--单位转换--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- dp2px
function dp转px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
-- px2dp
function px转dp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return pxValue / scale + 0.5
end
-- px2sp
function px转sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end
-- sp2px
function sp转px(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return spValue * scale + 0.5
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--文件操作--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--获取文件/文件夹大小
function 获取文件大小(path)
  size=File(tostring(path)).length()
  Sizes=Formatter.formatFileSize(activity, size)
  return Sizes
end
--文件是否存在
function 文件是否存在(id)
  return File(id).exists()
end
--文件夹是否存在
function 文件夹是否存在(id)
  return File(id).isDirectory()
end
--创建多级文件夹
function 创建多级文件夹(路径)
  File(路径).mkdirs()
end
--创建文件夹
function 创建文件夹(路径)
  File(路径).mkdir()
end
--创建文件
function 创建文件(id)
  return File(id).createNewFile()
end
--写入文件
function 写入文件(路径,内容)
  f=File(tostring(File(tostring(路径)).getParentFile())).mkdirs()
  io.open(tostring(路径),"w"):write(tostring(内容)):close()
end
--读取文件
function 读取文件(ml)
  return io.open(ml):read("*a")
end
--删除文件
function 删除文件(path)
  return LuaUtil.rmDir(File(tostring(path)))
end
--解压文件
function 解压文件(a,b)
  return ZipUtil.unzip(a,b)
end
--复制文件
function 复制文件(ak,ao)
  LuaUtil.copyDir(ak,ao)
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--实用函数-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--设备特征码/设备ID
function 获取设备ID()
  return Secure.getString(activity.getContentResolver(),Secure.ANDROID_ID)
end
--获取设备IMEI
function 获取设备IMEI()
  return activity.getSystemService(Context.TELEPHONY_SERVICE).getDeviceId()
end
--获取设备屏幕尺寸
function 获取设备屏幕尺寸(ctx)
  dm = DisplayMetrics();
  ctx.getWindowManager().getDefaultDisplay().getMetrics(dm);
  diagonalPixels = Math.sqrt(Math.pow(dm.widthPixels, 2) + Math.pow(dm.heightPixels, 2));
  return diagonalPixels / (160 * dm.density);
end
--后台发送短信
function 后台发送短信(号码,内容)
  SmsManager.getDefault().sendTextMessage(tostring(号码),nil,tostring(内容),nil,nil)
end
--获取剪切板内容
function 获取剪切板内容()
  return activity.getSystemService(Context.CLIPBOARD_SERVICE).getText()
end
--复制文本
function 复制文本(文本内容)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(文本内容)
end
--关闭WIFI
function 关闭WIFI()
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wifi.setWifiEnabled(false)
end
--打开WIFI
function 打开WIFI()
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wifi.setWifiEnabled(true)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--基础操作----------------------------------------------------------------------------------------------------------------------------------------------------------
--APPLUA内置提示
function APPLUA内置提示(str,a,b,c)
  toasts={
    CardView;
    id="toastb",
    CardElevation=c;
    radius="1dp";
    layout_width="fill";
    background=a;
    {
      TextView;
      layout_marginTop="12dp";
      layout_marginBottom="12dp";
      textSize="13sp";
      TextColor=b,
      layout_gravity="center";
      text="Hello Ori";
      id="mess",
    };
  };
  message=tostring(str)
  local toast=Toast.makeText(activity,"内容",Toast.LENGTH_SHORT);
  toast.setGravity(Gravity.BOTTOM|Gravity.FILL_HORIZONTAL, 0, 0)
  toast.setView(loadlayout(toasts))
  mess.Text=message
  toast.show()
end
--删除浏览器进度条
function 删除浏览器进度条()
  webView.removeView(webView.getChildAt(0))
end
--设置图片src
function 设置图片src(id,id2)
  id.setImageBitmap(loadbitmap(id2))
end
--关闭弹窗
function 关闭弹窗(id)
  id.hide()
end
--跳转页面2
function 跳转页面2(id,id2)
  id.onClick=function()
    activity.newActivity(id2,android.R.anim.fade_in,android.R.anim.fade_out)
  end
end
--弹出菜单
function 弹出菜单(id)
  id.onClick=function()
    pop.show()
  end
end
--设置文本
function 设置文本(a,b)
  a.setText(b)
end
--获取屏幕宽
function 获取屏幕宽度()
  return activity.getWidth()
end
--获取屏幕高
function 获取屏幕高度()
  return activity.getHeight()
end
--获取文本
function 获取文本(id)
  return id.text
end
--编辑框颜色
function 编辑框颜色(id,cc)
  id.getBackground().setColorFilter(PorterDuffColorFilter(cc,PorterDuff.Mode.SRC_ATOP));
end
--进度条颜色
function 进度条颜色(id,cc)
  id.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(cc,PorterDuff.Mode.SRC_ATOP))
end
--控件颜色
function 控件颜色(id,cc)
  id.setBackgroundColor(cc)
end
--获取手机存储路径
function 获取手机存储路径()
  return Environment.getExternalStorageDirectory().toString()
end
--打印
function 打印(id)
  print(id)
end
--提示
function 提示(id)
  Toast.makeText(activity,id,Toast.LENGTH_SHORT).show()
end
--自定义位置提示
function 自定义位置提示(nr,a,b,c)
  Toast.makeText(activity,nr, Toast.LENGTH_LONG).setGravity(a, b, c).show()
end
--带图片的提示
function 带图片的提示(id,oe)
  图片=loadbitmap(oe)
  toast = Toast.makeText(activity,id, Toast.LENGTH_LONG)
  toastView = toast.getView()
  imageCodeProject = ImageView(activity)
  imageCodeProject.setImageBitmap(图片)
  toastView.addView(imageCodeProject, 0)
  toast.show()
end
--自定义提示
function 自定义提示(nr,id)
  import (id)
  布局=loadlayout(id)
  local toast=Toast.makeText(activity,nr,Toast.LENGTH_SHORT).setView(布局).show()
end
--控件高
function 控件高(id,id2)
  id.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,id2))
end
--控件宽
function 控件宽(id,id2)
  id.setWidth(id2)
end
--文本颜色
function 文本颜色(id,id2)
  id.setTextColor(id2)
end
--导入包类
function 导入包类(a)
  return import(a)
end
--点击事件
function 点击事件(a,ok)
  a.onClick=ok
end
--长按事件
function 长按事件(a,ok)
  a.onLongClick=ok
end
--列表项目被单击
function 列表项目被单击(a,ok)
  a.onItemClick=ok
end
--列表项目被长按
function 列表项目被长按(a,ok)
  a.onItemLongClick=ok
end
--控件可视
function 控件可视(id)
  id.setVisibility(0)
end
--控件不可视
function 控件不可视(id)
  id.setVisibility(8)
end
--关闭侧滑
function 关闭侧滑(ch)
  ch.closeDrawer(3)
end
--打开侧滑
function 打开侧滑(ch)
  ch.openDrawer(3)
end
--关闭右侧滑
function 关闭右侧滑(ch)
  ch.closeDrawer(5)
end
--打开右侧滑
function 打开右侧滑(ch)
  ch.openDrawer(5)
end
--关闭左侧滑
function 关闭左侧滑(ch)
  ch.closeDrawer(3)
end
--打开左侧滑
function 打开左侧滑(ch)
  ch.openDrawer(3)
end
--设置主题
function 设置主题(theme)
  activity.setTheme(theme)
end
--设置标题栏标题
function 设置标题(标题)
  activity.setTitle(标题)
end
--隐藏标题栏
function 隐藏标题栏()
  activity.ActionBar.hide()
end
--设置布局
function 设置布局(a)
  activity.setContentView(loadlayout(a))
end
--布局内插入布局
function 布局内插入布局(控件,布局)
  控件.addView(loadlayout(布局))
end
--使弹出的输入法不影响布局
function 使弹出的输入法不影响布局()
  activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)
end

function 取消标题栏阴影()
  activity.ActionBar.setElevation(0)
end
function 编辑框光标颜色修改函数(id,Color)
  import 'android.graphics.Color'
  import 'android.graphics.PorterDuff'
  import 'android.graphics.PorterDuffColorFilter'
  local mEditorField = TextView.getDeclaredField('mEditor')
  mEditorField.setAccessible(true)
  local mEditor = mEditorField.get(id)
  local field = Editor.getDeclaredField('mCursorDrawable')
  field.setAccessible(true)
  local mCursorDrawable = field.get(mEditor)
  local mccdf = TextView.getDeclaredField('mCursorDrawableRes')
  mccdf.setAccessible(true)
  local mccd = activity.getResources().getDrawable(mccdf.getInt(id))
  mccd.setColorFilter(PorterDuffColorFilter(Color,PorterDuff.Mode.SRC_ATOP))
  mCursorDrawable[0] = mccd
  mCursorDrawable[1] = mccd
end
--使弹出的输入法影响布局
function 使弹出的输入法影响布局()
  activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
end
--重置当前页面
function 重置当前页面()
  activity.recreate()
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
--设置按钮颜色
function 设置按钮颜色(aa,id)
  aa.getBackground().setColorFilter(PorterDuffColorFilter(id,PorterDuff.Mode.SRC_ATOP))
end
--两角圆弧
function 两角圆弧(id,颜色,角度)
  drawable = GradientDrawable()
  drawable.setColor(颜色)
  drawable.setCornerRadii({角度,角度,角度,角度,0,0,0,0});
  id.setBackgroundDrawable(drawable)
end
--渐变
function 渐变(left_jb,right_jb,id)
  drawable = GradientDrawable(GradientDrawable.Orientation.TR_BL,{
    right_jb,--右色
    left_jb,--左色
  });
  id.setBackgroundDrawable(drawable)
end
---------------------------------------------------------------------------------------

--导航栏，状态栏操作----------------------------------------------------------------------
--导航栏颜色
function 设置导航栏颜色(color)
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
--通知栏颜色
function 设置通知栏颜色(id)
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(id);
  end
end
--状态栏颜色
function 设置状态栏颜色(id)
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(id);
  end
end
--沉浸状态栏
function 开启沉浸状态栏()
  if Build.VERSION.SDK_INT >= 19 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  end
end
--状态栏亮色
function 开启状态栏高亮()
  if Build.VERSION.SDK_INT >= 23 then
    activity.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
    --activity.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
  end
end
--状态栏暗色
function 关闭状态栏高亮()
  if Build.VERSION.SDK_INT >= 23 then
    --activity.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
    activity.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
  end
end
--获取状态栏高度
function 获取状态栏高度()
  if Build.VERSION.SDK_INT >= 19 then
    resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android")
    return activity.getResources().getDimensionPixelSize(resourceId)
   else
    return 0
  end
end
--隐藏状态栏
function 隐藏状态栏()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
end
---------------------------------------------------------------------------------------

function 大小转换(a)
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

function 转0x(j)
  if #j==7 then
    jj=j:match("#(.+)")
    jjj=tonumber("0xff"..jj)
   else
    jj=j:match("#(.+)")
    jjj=tonumber("0x"..jj)
  end
  return jjj
end