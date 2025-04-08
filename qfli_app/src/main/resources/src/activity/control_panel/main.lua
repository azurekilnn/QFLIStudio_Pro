set_style()
--import "io.github.rosemoe.sora.widget.CodeEditor"
import "system_incident"
import "com.michael.*"
load_common_components()
activity.setContentView(loadlayout("layout.layout_main"))
main_title_id.setText(gets("control_panel"))
import "system.system_dialogs"

--返回按钮
back_button.setVisibility(0)
menu_img.setVisibility(8)
--setImage(more_img,load_icon_path("check"))
system_ripple({back_button,more_button},"circular_theme")

--day_time
daytime_config=config["colors"]["day_time"]
--night_time
nighttime_config=config["colors"]["night_time"]

editor_daytime_config=daytime_config["editor"]
editor_nighttime_config=nighttime_config["editor"]


local config_content="config="..dump(config)
settings_editor.setText(config_content)







item={
  LinearLayoutCompat;
  layout_height="wrap";
  layout_width="fill";
  gravity="center";
  orientation="vertical";
  {
    LinearLayoutCompat;
    layout_height="fill";
    layout_width="fill";
    layout_margin="6dp";
    orientation="horizontal";
    gravity="center";
    {
      LinearLayoutCompat;
      layout_height="fill";
      layout_width="wrap";
      orientation="vertical";
      gravity="center";
      layout_weight="1";
      {
        TextView;
        textColor=text_color;
        singleLine="true";
        id="item_text";
        layout_marginLeft="16dp";
        textSize=load_textsize("16sp");
        layout_gravity="left";
      };
      {
        TextView;
        textColor=get_theme_color("paratext_color");
        singleLine=false;
        layout_marginLeft="16dp";
        textSize=load_textsize("13sp");
        layout_gravity="left";
        id="item_subtext";
        Selected=true;--文本可选
        ellipsize='end';
      };
      {
        TextView;
        id="mv";
        Visibility="8";
      };
      {
        TextView;
        id="data_keytext";
        Visibility="8";
      };
    };
    {
      LinearLayoutCompat;
      layout_height="60dp";
      layout_width="60dp";
      id="color_card_back";
      gravity="center";
      {
        CardView;--卡片控件
        layout_margin='5dp';--卡片边距
        layout_gravity='center';--子控件在父布局中的对齐方式
        CardElevation='5dp';--卡片阴影
        layout_width='25dp';--卡片宽度
        layout_height='25dp';--卡片高度
        id="color_card";
        Visibility="8";
      };
    };
    {
      LinearLayoutCompat;
      layout_height="60dp";
      layout_width="wrap";
      gravity="center";
      id="switch_background";
      Visibility="8";
      {
        Switch;
        Focusable=false;
        clickable=false;
        id="switch2";
      };
    };
  };
};


function adapter_card_radius(color)
  local card_radius=dp2px(30)
  return GradientDrawable().setShape(GradientDrawable.RECTANGLE).setColor(pc(color)).setCornerRadii({card_radius,card_radius,card_radius,card_radius,card_radius,card_radius,card_radius,card_radius});
end

daytime_color_set_list_adp=LuaAdapter(activity,item)
daytime_color_set_list.setAdapter(daytime_color_set_list_adp)

nighttime_color_set_list_adp=LuaAdapter(activity,item)
nighttime_color_set_list.setAdapter(nighttime_color_set_list_adp)

general_set_list_adp=LuaAdapter(activity,item)
general_set_list.setAdapter(general_set_list_adp)

editor_set_list_adp=LuaAdapter(activity,item)
editor_set_list.setAdapter(editor_set_list_adp)

cloud_set_list_adp=LuaAdapter(activity,item)
cloud_set_list.setAdapter(cloud_set_list_adp)

function add_common_item(adapter,main_title,sub_title,key)
  adapter.add({item_text={text=main_title},item_subtext={text=sub_title},data_keytext={text=key},color_card_back={Visibility=8},switch_background={Visibility=8}})
end

function add_switch_item(adapter,main_title,sub_title,key,switch_checked)
  adapter.add({item_text={text=main_title},item_subtext={text=sub_title},data_keytext={text=key},color_card_back={Visibility=8},switch_background={Visibility=0},switch2={Checked=switch_checked}})
end

function add_cloud_set_item(main_title,sub_title,key)
  cloud_set_list_adp.add({item_text={text=main_title},item_subtext={text=sub_title},data_keytext={text=key},color_card_back={Visibility=8},switch_background={Visibility=8}})
end

function add_general_set_item(main_title,sub_title,key,switch_checked)
  general_set_list_adp.add({item_text={text=main_title},item_subtext={text=sub_title},data_keytext={text=key},color_card_back={Visibility=8},switch_background={Visibility=0},switch2={Checked=switch_checked}})
end

function add_editor_set_item(main_title,sub_title,key,switch_checked)
  --editor_set_list_adp.add({item_text={text=main_title},item_subtext={text=sub_title},mv={text=item_color},data_keytext={text=ide_editor_settings[v]},color_card_back={Visibility=8},switch_background={Visibility=0},switch2={Checked=editor_data[ide_editor_settings[v]]}})
  editor_set_list_adp.add({item_text={text=main_title},item_subtext={text=sub_title},data_keytext={text=key},color_card_back={Visibility=8},switch_background={Visibility=0},switch2={Checked=switch_checked}})
end

function add_color_item(main_title,sub_title,item_color,item_color2,key)
  daytime_color_set_list_adp.add({item_text={text=main_title},item_subtext={Visibility=8,text=sub_title},data_keytext={text=key},mv={text=item_color},color_card={Visibility=0,backgroundDrawable=adapter_card_radius(item_color)}})
  nighttime_color_set_list_adp.add({item_text={text=main_title},item_subtext={Visibility=8,text=sub_title},data_keytext={text=key},mv={text=item_color2},color_card={Visibility=0,backgroundDrawable=adapter_card_radius(item_color2)}})
end

editor_background.setVisibility(8)
function updateUI()
  settings_background.setVisibility(0)
  progress_background.setVisibility(8)
end
settings_background.setVisibility(0)
progress_background.setVisibility(0)
thread(function()
  require "import"
  import "java.io.File"
  require "system.public_system"
  import "system.system_settings_config"
  --day_time
  daytime_config=config["colors"]["day_time"]
  --night_time
  nighttime_config=config["colors"]["night_time"]

  editor_daytime_config=daytime_config["editor"]
  editor_nighttime_config=nighttime_config["editor"]

  for v,k in pairs(ide_general_settings) do
    if (type(v)=="number" and ide_general_settings[v]) then
      local main_title=ide_general_settings[ide_general_settings[v].."_title"]
      local sub_title=ide_general_settings[ide_general_settings[v]]
      local data_keytext=ide_general_settings[v]
      local switch_checked=settings[ide_general_settings[v]]
      call("add_general_set_item",main_title,sub_title,data_keytext,switch_checked)
    end
  end

  for v,k in pairs(ide_editor_settings) do
    if (type(v)=="number" and ide_editor_settings[v]) then
      local main_title=ide_editor_settings[ide_editor_settings[v].."_title"]
      local sub_title=ide_editor_settings[ide_editor_settings[v]]
      local switch_checked=editor_data[ide_editor_settings[v]]
      local data_keytext=ide_editor_settings[v]
      call("add_editor_set_item",main_title,sub_title,data_keytext,switch_checked)
    end
  end

  for v,k in pairs(cloud_settings) do
    if (type(v)=="number" and cloud_settings[v]) then
      local main_title=cloud_settings[cloud_settings[v].."_title"]
      local sub_title=cloud_settings[cloud_settings[v]]
      local data_keytext=cloud_settings[v]
      call("add_cloud_set_item",main_title,sub_title,data_keytext)
    end
  end

  for v,k in pairs(color_set_key) do
    local main_title=k
    local sub_title=color_set_subtitle[main_title]
    local key_text=color_set[main_title]
    local item_color=daytime_config[key_text]
    local item_color2=nighttime_config[key_text]
    if sub_title then
      call("add_color_item",main_title,sub_title,item_color,item_color2,key_text)
    end
  end
  call("updateUI")
end)


list_func1=function(p,v,i,s)
  local mvalue=v.Tag.mv.Text
  xpcall(function()
    if(string.sub(mvalue:gsub("#",""),7,8)=="")then
      local a="0xff"
      local b="0x".. string.sub(mvalue:gsub("#",""),0,2)
      local c="0x".. string.sub(mvalue:gsub("#",""),3,4)
      local d="0x".. string.sub(mvalue:gsub("#",""),5,6)
      color_tab={}
      color_tab["a"]=a
      color_tab["b"]=b
      color_tab["c"]=c
      color_tab["d"]=d

      arbg_dialog_func(function(color4)
        daytime_config[color_set[v.Tag.item_text.Text]]=color4
        --daytime_config[table.find(daytime_config,daytime_config[color_set[v.Tag.item_text.Text]])]=color4
        v.Tag.color_card.backgroundDrawable=adapter_card_radius(pc(color4))
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
      end,"settings",color_tab)
     else
      local a="0x".. string.sub(mvalue:gsub("#",""),0,2)
      local b="0x".. string.sub(mvalue:gsub("#",""),3,4)
      local c="0x".. string.sub(mvalue:gsub("#",""),5,6)
      local d="0x"..string.sub(mvalue:gsub("#",""),7,8)
      color_tab={}
      color_tab["a"]=a
      color_tab["b"]=b
      color_tab["c"]=c
      color_tab["d"]=d

      arbg_dialog_func(function(color4)
        daytime_config[color_set[v.Tag.item_text.Text]]=color4
        --daytime_config[table.find(daytime_config,daytime_config[color_set[v.Tag.item_text.Text]])]=color4
        v.Tag.color_card.backgroundDrawable=adapter_card_radius(pc(color4))
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
      end,"settings",color_tab)
    end
  end,error_dialog)
end

list_func2=function(p,v,i,s)
  local mvalue=v.Tag.mv.Text
  xpcall(function()
    if(string.sub(mvalue:gsub("#",""),7,8)=="")then
      local a="0xff"
      local b="0x".. string.sub(mvalue:gsub("#",""),0,2)
      local c="0x".. string.sub(mvalue:gsub("#",""),3,4)
      local d="0x".. string.sub(mvalue:gsub("#",""),5,6)
      color_tab={}
      color_tab["a"]=a
      color_tab["b"]=b
      color_tab["c"]=c
      color_tab["d"]=d

      arbg_dialog_func(function(color4)
        nighttime_config[color_set[v.Tag.item_text.Text]]=color4
        --nighttime_config[table.find(nighttime_config,nighttime_config[color_set[v.Tag.item_text.Text]])]=color4
        v.Tag.color_card.backgroundDrawable=adapter_card_radius(pc(color4))
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
      end,"settings",color_tab)
     else
      local a="0x".. string.sub(mvalue:gsub("#",""),0,2)
      local b="0x".. string.sub(mvalue:gsub("#",""),3,4)
      local c="0x".. string.sub(mvalue:gsub("#",""),5,6)
      local d=string.sub(mvalue:gsub("#",""),7,8)
      color_tab={}
      color_tab["a"]=a
      color_tab["b"]=b
      color_tab["c"]=c
      color_tab["d"]=d

      arbg_dialog_func(function(color4)
        nighttime_config[color_set[v.Tag.item_text.Text]]=color4
        --nighttime_config[table.find(nighttime_config,nighttime_config[color_set[v.Tag.item_text.Text]])]=color4
        v.Tag.color_card.backgroundDrawable=adapter_card_radius(pc(color4))
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
      end,"settings",color_tab)
    end
  end,error_dialog)
end

nighttime_color_set_list.onItemClick=list_func2
daytime_color_set_list.onItemClick=list_func1

more_button.onClick=function()
  pop=PopupMenu(activity,more_lay)
  menu=pop.Menu
  menu.add("保存并退出").onMenuItemClick=function(a)
    local extconfig_path=activity.getLuaExtDir().."/config.lua"
    io.open(extconfig_path,"w"):write(settings_editor.text):close()
    system_print(gets("save_succeed"))
    activity.result({"settings_update"})
  end
  menu.add("恢复默认设置").onMenuItemClick=function(a)
    activity.setSharedData("webdav_serve",false)
    activity.setSharedData("webdav_user",false)
    activity.setSharedData("webdav_pass",false)
    import "config"
    local extconfig_path=activity.getLuaExtDir().."/config.lua"
    local config_content="config="..dump(config)
    settings_editor.setText(config_content)
    io.open(extconfig_path,"w"):write(settings_editor.text):close()
    system_print(gets("save_succeed"))
    activity.result({"settings_update"})
  end
  menu.add("编辑器修改").onMenuItemClick=function(a)
    if editor_background.getVisibility()==8 then
      settings_background.setVisibility(8)
      editor_background.setVisibility(0)
     elseif editor_background.getVisibility()==0 then
      settings_background.setVisibility(0)
      editor_background.setVisibility(8)
    end
  end
  pop.show()--显示
end



general_set_list.onItemClick=function(p,v,i,s)
  local switch_backgroundv=v.Tag.switch_background.getVisibility()
  local switch2v=v.Tag.switch2.isChecked()

  if switch_backgroundv==0 then
    local data_key=v.Tag.data_keytext.Text
    if switch2v==true then
      v.Tag.switch2.setChecked(false)
      settings[data_key]=false
      activity.setSharedData(tostring("settings_"..data_key),false)
      local config_content="config="..dump(config)
      settings_editor.setText(config_content)
     else
      v.Tag.switch2.setChecked(true)
      settings[data_key]=true
      activity.setSharedData(tostring("settings_"..data_key),true)
      local config_content="config="..dump(config)
      settings_editor.setText(config_content)
    end
    if data_key=="quick_boot_mode2" then
      if switch2v==true then
        local extconfig_path=activity.getLuaExtDir().."/config.lua"
        io.open(extconfig_path,"w"):write(settings_editor.text):close()
        --关闭
        import "android.content.pm.PackageManager"
        packageManager = activity.getPackageManager();
        packageManager.setComponentEnabledSetting(ComponentName(this,activity.getPackageName()..".LuaMainQuickActivity"), PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
        packageManager.setComponentEnabledSetting(ComponentName(this,activity.getPackageName()..".BootActivity"), PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
        system_print("重启后生效")
       else
        local extconfig_path=activity.getLuaExtDir().."/config.lua"
        io.open(extconfig_path,"w"):write(settings_editor.text):close()
        --开启
        import "android.content.pm.PackageManager"
        packageManager = activity.getPackageManager();
        packageManager.setComponentEnabledSetting(ComponentName(this,activity.getPackageName()..".LuaMainQuickActivity"), PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
        packageManager.setComponentEnabledSetting(ComponentName(this,activity.getPackageName()..".BootActivity"), PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
        system_print("重启后生效")
      end
    end
  end

end

editor_set_list.onItemClick=function(p,v,i,s)
  local switch_backgroundv=v.Tag.switch_background.getVisibility()
  local switch2v=v.Tag.switch2.isChecked()
  if switch_backgroundv==0 then
    local data_key=v.Tag.data_keytext.Text
    if data_key=="symbol_bar_settings" then
      SkipPage("symbol_settings")
     else
      if switch2v==true then
        v.Tag.switch2.setChecked(false)
        editor_data[data_key]=false
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
       else
        v.Tag.switch2.setChecked(true)
        editor_data[data_key]=true
        local config_content="config="..dump(config)
        settings_editor.setText(config_content)
      end
    end
  end
end




cloud_set_operations={
  ["webdav"]=function()
    layout_webdav_dlg={
      LinearLayoutCompat;
      orientation="vertical";
      layout_width="fill";
      layout_height="wrap";
      Focusable=true,
      FocusableInTouchMode=true,
      id="layout_webdav_dlg_background";
      {
        LinearLayout;
        layout_marginTop="10dp";
        gravity="center";
        orientation="vertical";
        layout_width="fill";
        {
          CardView;
          layout_marginTop="2dp";
          CardElevation="0dp";
          layout_height="4dp";
          layout_width="80dp";
          radius="2dp";
          backgroundColor="#DEDEDE";
        };
        {
          TextView;
          textColor=text_color;
          textSize="20sp";
          ellipsize="end";
          singleLine="true";
          layout_marginLeft="20dp";
          layout_marginTop="20dp";
          layout_marginBottom="20dp";
          layout_gravity="left";
          text="WebDav配置";
        };
        {
          AppCompatTextView;
          id="helpertext",
          textSize="15sp",
          paddingTop="5dp";
          paddingBottom="5dp";
          layout_width="90%w";
          layout_gravity="center",
          textColor=text_color;
          text="请先在坚果云注册并开通WebDav服务";
        };
        {
          LinearLayoutCompat;
          layout_width="fill";
          orientation="vertical";
          layout_height="wrap";
          {
            MyEditText:build{
              Hint="WebDav地址";
              et_id="webdav_server";
              text="https://dav.jianguoyun.com/dav/";
              --helperText="Helper Text";
            };
            layout_width="95%w";
            layout_gravity="center";
          };
          {
            MyEditText:build{
              Hint="WebDav账号";
              et_id="webdav_account";
              --helperText="Helper Text";
            };
            layout_width="95%w";
            layout_gravity="center";
          };
          {
            MyEditText:build{
              Hint="WebDav密码";
              et_id="webdav_password";
              --helperText="Helper Text";
            };
            layout_width="95%w";
            layout_gravity="center";
          };
        };
        {
          CheckBox;
          text=gets("show_password");
          layout_width="80%w";
          layout_height='40dp';
          layout_gravity="center",
          id="webdav_dlg_check_box";
          layout_marginBottom="10dp";
        };
        {
          LinearLayoutCompat;
          orientation="horizontal";
          layout_width="-1";
          layout_height="-2";
          gravity="right|center";
          paddingTop="15dp";
          {
            CardView;
            layout_width="-2";
            layout_height="-2";
            radius="4dp";
            backgroundColor=basic_color_num;
            layout_marginTop="8dp";
            layout_marginLeft="8dp";
            layout_marginRight="24dp";
            layout_marginBottom="24dp";
            Elevation="1dp";
            id="save_webdav_info_ok_button";
            {
              TextView;
              layout_width="-1";
              layout_height="-2";
              textSize="16sp";
              paddingRight="16dp";
              paddingLeft="16dp";
              Typeface=load_font("bold");
              paddingTop="8dp";
              paddingBottom="8dp";
              text=gets("ok_button");
              textColor=get_theme_color("background_color");
              --BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{common_ripple}));
            };
          };
        };
      };
    };
    import "system.system_strings"
    import "android.text.InputType"
    webdav_dlg = MaterialAlertDialogBuilder(activity)
    webdav_dlg.setView(loadlayout(layout_webdav_dlg))
    webdav_dlg_2=webdav_dlg.show()
    set_dialog_style(webdav_dlg_2)
    save_webdav_info_ok_button.onClick=function()
      local webdav_serve=webdav_server.text
      local webdav_user=webdav_account.text
      local webdav_pass=webdav_password.text
      --system_print("save")
      if webdav_user~="" and webdav_pass~="" and webdav_serve~="" then
        activity.setSharedData("webdav_serve",webdav_serve)
        activity.setSharedData("webdav_user",webdav_user)
        activity.setSharedData("webdav_pass",webdav_pass)
        system_print(gets("save_succeed"))
        webdav_dlg_2.dismiss()
      end
    end
    webdav_password.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)

    webdav_dlg_check_box.onClick=function()
      if webdav_dlg_check_box.isChecked() then
        webdav_password.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
       else
        webdav_password.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
      end
    end
    if activity.getSharedData("webdav_user") and activity.getSharedData("webdav_serve") and activity.getSharedData("webdav_pass") then
      webdav_password.setText(activity.getSharedData("webdav_pass"))
      webdav_account.setText(activity.getSharedData("webdav_user"))
      webdav_server.setText(activity.getSharedData("webdav_serve"))
    end
    --print("webdav")
  end
}
cloud_set_list.onItemClick=function(p,v,i,s)
  local data_key=v.Tag.data_keytext.Text
  if cloud_set_operations[data_key] then
    cloud_set_operations[data_key]()
  end
  return true
end

parameter = 0
function onKeyDown(code, event)
  if string.find(tostring(event), "KEYCODE_BACK") ~= nil then
    if parameter + 2 > tonumber(os.time()) then
      local extconfig_path=activity.getLuaExtDir().."/config.lua"
      local config_content="config="..dump(config)
      settings_editor.setText(config_content)
      io.open(extconfig_path,"w"):write(settings_editor.text):close()
      system_print(gets("save_succeed"))
      activity.result({"settings_update"})
     else
      system_print(gets("back_tip"))
      parameter = tonumber(os.time())
    end
    return true
  end
end