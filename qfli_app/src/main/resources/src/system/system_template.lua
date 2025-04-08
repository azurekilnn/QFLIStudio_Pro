import "TemplateManager"

template_manager=TemplateManager()

templates={
  strings_template=[[<?xml version="1.0" encoding="utf-8"?>
  <resources>
      <string name="app_name">%s</string>
  </resources>]],
  mainjava_template=[[package %s;
import android.app.*;
import android.os.*;
public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);      
    }
}]],
  main_content=[[require "import"
require "Azure"  
--require "chinese_funlib"--中文函数库，如需要使用请去除该行注释
import "androidx.appcompat.widget.*"
import "androidx.appcompat.app.*"
import "androidx.appcompat.view.*"
activity.setTitle("LuaStudio+")
activity.setTheme(Theme_LuaStudio)
activity.setContentView(loadlayout("layout"))
%s]],
  main_content=[[require "import"
require "Azure"  
--require "chinese_funlib"--中文函数库，如需要使用请去除该行注释
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
activity.setTitle("LuaStudio+")
activity.setTheme(R.style.Theme_LuaStudio)
%s]],
  newmain_content=[[require "system"
activity.setTitle("LuaStudio+")
activity.setTheme(R.style.Theme_LuaStudio)
%s]],
  aly_content=[[{
  LinearLayoutCompat;
  orientation="vertical";
  layout_height="fill";
  layout_width="fill";
  {
    AppCompatTextView;
    layout_height="fill";
    gravity="center";
    layout_gravity="center";
    text="LuaStudio+";
    textSize="18sp";
    layout_width="fill";
  };
};]],
  aly_content=[[{
  LinearLayout;
  orientation="vertical";
  layout_height="fill";
  layout_width="fill";
  {
    TextView;
    layout_height="fill";
    gravity="center";
    layout_gravity="center";
    text="LuaStudio+";
    textSize="18sp";
    layout_width="fill";
  };
};]],

  build_lsinfo_template=[[build_info={
 appname="%s",
 appver="1.0",
 appcode="1",
 appsdk="21",
 template="%s",
 packagename="%s",
}
user_permission={
 "INTERNET",
 "WRITE_EXTERNAL_STORAGE"
}]],
  init_lua_template=[[appname="%s"
debugmode=true]],
  setlayout_code=[[activity.setContentView(loadlayout("layout"))]]
}

main_content=templates["main_content"]
aly_content=templates["aly_content"]
build_lsinfo_template=templates["build_lsinfo_template"]
init_lua_template=templates["init_lua_template"]
setlayout_code=templates["setlayout_code"]
newmain_content=templates["newmain_content"]