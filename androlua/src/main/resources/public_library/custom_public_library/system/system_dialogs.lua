--对话框背景
function dialog_background_corner(color,radiu)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(color)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,0,0,0,0});
  return drawable
end

function dialog_corner(id,color,radiu)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(color)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,0,0,0,0});
  id.setBackgroundDrawable(drawable)
end

function set_dialog_style(dialog)
  local dialog_window=dialog.getWindow();
  dialog_window.setBackgroundDrawable(dialog_background_corner(pc(background_color),radiu))
  local params = dialog_window.getAttributes();
  params.gravity = Gravity.BOTTOM;
  params.width = WindowManager.LayoutParams.MATCH_PARENT;
  params.height = WindowManager.LayoutParams.WRAP_CONTENT;
  dialog_window.setAttributes(params);
  --print((background_color))
end

--进度条对话框
function create_progress_dlg(text,title,focus)
  --圆形旋转样式
  progress_dlg = ProgressDialog(activity,R.style.ThemeProgressDialogStyle)
  progress_dlg.setProgressStyle(ProgressDialog.STYLE_SPINNER)
  if title then
    progress_dlg.setTitle(title)
  end
  if text then
    progress_dlg.setMessage(text)
   else
    progress_dlg.setMessage(gets("loading_text"))
  end
  if focus==false then
   else
    progress_dlg.setCancelable(false);
    progress_dlg.setCanceledOnTouchOutside(false)
  end
  progress_dlg2=progress_dlg.show().dismiss()
  local background_color=pc(background_color)
  set_dialog_style(progress_dlg2)
  return progress_dlg,progress_dlg2
end

function create_project_dlg()
  if create_project_dialog then
   else
    local function check_symbols(table,key)
      for index,content in ipairs(table) do
        if string.find(key,content) then
          return true
        end
      end
    end
    local layout_create_project_dialog = import "layout.layout_dialogs.layout_create_project_dialog"
    create_project_dialog = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
    create_project_dialog.setContentView(loadlayout(layout_create_project_dialog))

    dialog_corner(layout_create_project_dialog_background,pc(background_color),radiu)
    widget_radius(create_project_dialog_ok_button,basic_color_num,radiu)
    --工程类型适配器
    local app_type_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(app_type_table))
    app_type_list.setAdapter(app_type_adp)
    new_app_name.setText("HelloWorld")
    new_app_packagename.setText("com.luastudio.helloworld")
    helpertext_1.setVisibility(8)
    helpertext_2.setVisibility(8)
    local symbol_table={"?","*",":",'"',"<",">","/","\\","|",",","!",";","'"}
    new_app_name.addTextChangedListener{
      onTextChanged=function(s)
        if check_symbols(symbol_table,tostring(s)) then
          helpertext_1.setTextColor(pc(error_tips_text_color))
          helpertext_1.setText(gets("warning_symbols_tips"))
          helpertext_1.setVisibility(0)
          create_project_dialog_ok_button.setEnabled(false)
         elseif #s==0 then
          helpertext_1.setTextColor(pc(text_color))
          helpertext_1.setText(gets("type_appname_tips"))
          helpertext_1.setVisibility(0)
          create_project_dialog_ok_button.setEnabled(false)
         else
          helpertext_1.setTextColor(pc(text_color))
          helpertext_1.setText("")
          helpertext_1.setVisibility(8)
          create_project_dialog_ok_button.setEnabled(true)
        end
      end
    }
    new_app_packagename.addTextChangedListener{
      onTextChanged=function(s)
        if check_symbols(symbol_table,tostring(s)) then
          helpertext_2.setTextColor(pc(error_tips_text_color))
          helpertext_2.setText(gets("warning_symbols_tips"))
          helpertext_2.setVisibility(0)
          create_project_dialog_ok_button.setEnabled(false)
         elseif #s==0 then
          helpertext_2.setTextColor(pc(text_color))
          helpertext_2.setText(gets("type_apppackagename_tips"))
          helpertext_2.setVisibility(0)
          create_project_dialog_ok_button.setEnabled(false)
         else
          helpertext_2.setTextColor(pc(text_color))
          helpertext_2.setText("")
          helpertext_2.setVisibility(8)
          create_project_dialog_ok_button.setEnabled(true)
        end
      end
    }
  end
end

--BottomSheetDialog全屏显示

function setDefaultBottomSheetDialog(bottom_sheet_dialog)
  --获取屏幕高度
  local DisplayMetrics = luajava.bindClass "android.util.DisplayMetrics"
  local outMetrics = DisplayMetrics();
  local wm = activity.getSystemService(Context.WINDOW_SERVICE);
  wm.getDefaultDisplay().getMetrics(outMetrics);
  local Height = outMetrics.heightPixels;
  import "com.google.android.material.bottomsheet.BottomSheetBehavior"
  local material_r=luajava.bindClass("com.google.android.material.R")
  local view=bottom_sheet_dialog.getWindow().findViewById(material_r.id.design_bottom_sheet)
  view.layoutParams.height= Height*0.45
  local bottomSheetBehavior = BottomSheetBehavior.from(view);
  bottomSheetBehavior.peekHeight = Height
end


function setFullScreenBottomSheetDialog(bottom_sheet_dialog)
  --获取屏幕高度
  local DisplayMetrics = luajava.bindClass "android.util.DisplayMetrics"
  local outMetrics = DisplayMetrics();
  local wm = activity.getSystemService(Context.WINDOW_SERVICE);
  wm.getDefaultDisplay().getMetrics(outMetrics);
  local Height = outMetrics.heightPixels;
  import "com.google.android.material.bottomsheet.BottomSheetBehavior"
  local material_r=luajava.bindClass("com.google.android.material.R")
  local view=bottom_sheet_dialog.getWindow().findViewById(material_r.id.design_bottom_sheet)
  view.layoutParams.height= Height
  local bottomSheetBehavior = BottomSheetBehavior.from(view);
  bottomSheetBehavior.peekHeight = Height
  bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
end

--BottomSheetDialog全屏显示
function setHideableBottomSheetDialog(bottom_sheet_dialog)
  import "com.google.android.material.bottomsheet.BottomSheetBehavior"
  local material_r=luajava.bindClass("com.google.android.material.R")
  local view=bottom_sheet_dialog.getWindow().findViewById(material_r.id.design_bottom_sheet)
  local bottomSheetBehavior = BottomSheetBehavior.from(view);
  bottomSheetBehavior.setHideable(false)
end

--捐赠对话框
function create_donation_dlg()
  donation_dialog_data = {gets("alipay"), gets("weixin"), gets("qq")};
  donation_incident = {}
  donation_incident[gets("weixin")] = function()
    LuaUtil.copyDir(File(donation_dialog_img_data[gets("weixin")]), File(internal_storage .. "/" .. donation_path_key .. ".png"))
    system_print(gets("save_succeed"))
  end
  donation_incident[gets("qq")] = function()
    LuaUtil.copyDir(File(donation_dialog_img_data[gets("qq")]), File(internal_storage .. "/" .. donation_path_key .. ".png"))
    system_print(gets("save_succeed"))
  end
  donation_incident[gets("alipay")] = function()
    xpcall(function()
      local url = "alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/fkx04744lsmxexbkyprtt8e"
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
    end,
    function()
      local url = "https://qr.alipay.com/fkx04744lsmxexbkyprtt8e";
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
    end)
  end

  local layout_donation_dialog = import "layout.layout_dialogs.layout_donation_dialog"
  donation_dialog = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  donation_dialog.setContentView(loadlayout(layout_donation_dialog))
  dialog_corner(layout_donation_dialog_background,pc(background_color),radiu)
  --按钮圆角
  widget_radius(donation_dialog_ok_button,basic_color_num,radiu)
  --捐赠方式适配器
  local donation_dialog_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(donation_dialog_data))
  donation_dialog_list.setAdapter(donation_dialog_adp)
  donation_dialog_list.onItemSelected=function(p,v)
    local donation_path_key=donation_dialog_data[donation_dialog_list.getSelectedItemPosition()+1]
    if donation_path_key==gets("alipay") then
      donation_dialog_ok_button.setText(gets("jump"))
     else
      donation_dialog_ok_button.setText(gets("ok_button"))
    end
    setImage(donation_dialog_img,tostring(donation_dialog_img_data[v.Text]))
  end
  donation_dialog_ok_button.onClick=function()
    local donation_path_key=donation_dialog_data[donation_dialog_list.getSelectedItemPosition()+1]
    local donation_pic=donation_dialog_img_data[donation_path_key]
    donation_incident[donation_path_key]()
  end
end

--关于对话框
function create_about_dlg()
  local layout_about_dialog = import "layout.layout_dialogs.layout_about_dialog"
  about_dialog = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  about_dialog.setContentView(loadlayout(layout_about_dialog))
  setFullScreenBottomSheetDialog(about_dialog)
  dialog_corner(layout_about_dialog_background,pc(background_color),radiu)
  widget_radius(about_dialog_ok_button,basic_color_num,radiu)
  widget_radius(about_dialog_donation_button,pc(background_color),radiu)
  about_content_textview.setText(update_content)
  about_dialog_ok_button.onClick=function()
    about_dialog.dismiss()
    if donation_dialog then
      donation_dialog.show()
     else
      create_donation_dlg()
      donation_dialog.show()
    end
  end
  about_dialog_donation_button.onClick=function()
    about_dialog.dismiss()
  end
end

function create_fix_error_project_dlg(positiveButtonClick)
  local fix_error_project_dlg=MaterialAlertDialogBuilder(this,R.style.AlertDialogTheme)
  fix_error_project_dlg.setTitle(gets("warning_tips"))--提示
  fix_error_project_dlg.setMessage(gets("fix_error_project_tips"))
  fix_error_project_dlg.setPositiveButton(gets("fix_project"),positiveButtonClick or function()end)
  fix_error_project_dlg.setNegativeButton(gets("cancel_button"),nil)
  fix_error_project_dlg_2=fix_error_project_dlg.show()
  set_dialog_style(fix_error_project_dlg_2)
  return fix_error_project_dlg,fix_error_project_dlg_2
end

function create_fix_error_project_dlg_2(positiveButtonClick)
  local fix_error_project_dlg=MaterialAlertDialogBuilder(this,R.style.AlertDialogTheme)
  fix_error_project_dlg.setTitle(gets("warning_tips"))--提示
  fix_error_project_dlg.setMessage(gets("fix_error_project_tips_2"))
  fix_error_project_dlg.setPositiveButton(gets("ok_button"),positiveButtonClick or function()end)
  fix_error_project_dlg.setNegativeButton(gets("cancel_button"),nil)
  fix_error_project_dlg_2=fix_error_project_dlg.show()
  set_dialog_style(fix_error_project_dlg_2)
  return fix_error_project_dlg,fix_error_project_dlg_2
end


function create_delete_tips_dlg(positiveButtonClick)
  local delete_tips_dialog=AlertDialogBuilder(this)
  delete_tips_dialog.setTitle(gets("warning_tips"))--提示
  delete_tips_dialog.setMessage(gets("warning_delete_tips"))
  delete_tips_dialog.setPositiveButton(gets("ok_button"),positiveButtonClick or function()end)
  delete_tips_dialog.setNegativeButton(gets("cancel_button"),nil)
  delete_tips_dialog_2=delete_tips_dialog.show()
  set_dialog_style(delete_tips_dialog_2)
  return delete_tips_dialog,delete_tips_dialog_2
end

function create_delete_old_proj_dlg(positiveButtonClick)
  local delete_tips_dialog=AlertDialogBuilder(this)
  delete_tips_dialog.setTitle(gets("warning_tips"))--提示
  delete_tips_dialog.setMessage(gets("warning_delete_old_proj_tips"))
  delete_tips_dialog.setPositiveButton(gets("ok_button"),positiveButtonClick or function()end)
  delete_tips_dialog.setNegativeButton(gets("cancel_button"),nil)
  delete_tips_dialog_2=delete_tips_dialog.show().dismiss()
  set_dialog_style(delete_tips_dialog_2)
  return delete_tips_dialog,delete_tips_dialog_2
end

function init_basic_dlg_layout(value)
  local dialog_data={}
  dialog_data["dialog_views_data"]={}
  local dialog_views_data=dialog_data["dialog_views_data"]
  local empty_incident = function()end

  local title = value["title"] or ""
  local positiveButton = value["positiveButton"] or {}
  local negativeButton = value["negativeButton"] or {}
  local dialog_type = value["type"]

  local positiveButtonText = positiveButton["text"] or ""
  local negativeButtonText = negativeButton["text"] or ""

  local positiveButtonClick = positiveButton["click"] or empty_incident
  local negativeButtonClick = negativeButton["click"] or empty_incident

  local layout_basic_dialog = import "layout.layout_dialogs.layout_basic_dialog"
  local layout_basic_dialog = loadlayout(layout_basic_dialog)

  local basic_view = layout_basic_dialog.getChildAt(0)
  local tips_bar_view = basic_view.getChildAt(0)
  local basic_sub_view = basic_view.getChildAt(1)
  local basic_tool_bar_view = basic_sub_view.getChildAt(0)
  local basic_main_view = basic_sub_view.getChildAt(1)
  local basic_button_view = basic_sub_view.getChildAt(2)
  local basic_top_bar_main_view = basic_tool_bar_view.getChildAt(0)
  local basic_tool_bar_main_view = basic_top_bar_main_view.getChildAt(0)
  local basic_search_bar_root_view = basic_tool_bar_view.getChildAt(1)
  local basic_search_bar_main_view = basic_search_bar_root_view.getChildAt(0)
  basic_tool_bar_title_tv = basic_tool_bar_main_view.getChildAt(1).getChildAt(0)

  dialog_views_data["basic_view"] = basic_view
  dialog_views_data["tips_bar_view"] = tips_bar_view
  dialog_views_data["basic_sub_view"] = basic_sub_view
  dialog_views_data["basic_tool_bar_view"] = basic_tool_bar_view
  dialog_views_data["basic_main_view"] = basic_main_view
  dialog_views_data["basic_button_view"] = basic_button_view
  dialog_views_data["basic_top_bar_main_view"] = basic_top_bar_main_view
  dialog_views_data["basic_tool_bar_main_view"] = basic_tool_bar_main_view
  dialog_views_data["basic_search_bar_root_view"] = basic_search_bar_root_view
  dialog_views_data["basic_search_bar_main_view"] = basic_search_bar_main_view
  dialog_views_data["basic_tool_bar_title_tv"] = basic_tool_bar_title_tv


  basic_tool_bar_view.setVisibility(8)

  function setWinTitle(title)
    activity.setTitle(title)
    basic_tool_bar_title_tv.setText(title)
  end

  local basic_title_tv = basic_main_view.getChildAt(0)
  dialog_views_data["basic_title_tv"] = basic_tool_bar_title_tv
  local basic_content_view = basic_main_view.getChildAt(1)
  dialog_views_data["basic_content_view"] = basic_content_view

  local basic_positive_button = basic_button_view.getChildAt(1)
  dialog_views_data["basic_positive_button"] = basic_positive_button
  local basic_positive_button_tv = basic_positive_button.getChildAt(0)
  dialog_views_data["basic_positive_button_tv"] = basic_positive_button_tv

  local basic_negative_button = basic_button_view.getChildAt(0)
  dialog_views_data["basic_negative_button"] = basic_negative_button
  local basic_negative_button_tv = basic_negative_button.getChildAt(0)
  dialog_views_data["basic_negative_button_tv"] = basic_negative_button_tv

  basic_positive_button.onClick = positiveButtonClick
  basic_negative_button.onClick = negativeButtonClick

  basic_positive_button_tv.setText(positiveButtonText)
  basic_negative_button_tv.setText(negativeButtonText)

  function load_dialog_tool_bar(dialog_views_data,basic_tool_bar_main_view)
    basic_tool_bar_menu_button = basic_tool_bar_main_view.getChildAt(0)
    basic_tool_bar_search_button = basic_tool_bar_main_view.getChildAt(2)
    basic_tool_bar_more_button = basic_tool_bar_main_view.getChildAt(3)
    basic_tool_bar_more_lay = basic_tool_bar_main_view.getChildAt(4)
    basic_tool_bar_more_button_img = basic_tool_bar_more_button.getChildAt(0)
    dialog_views_data["basic_tool_bar_menu_button"] = basic_tool_bar_menu_button
    dialog_views_data["basic_tool_bar_search_button"] = basic_tool_bar_search_button
    dialog_views_data["basic_tool_bar_more_button"] = basic_tool_bar_more_button
    dialog_views_data["basic_tool_bar_more_lay"] = basic_tool_bar_more_lay
    dialog_views_data["basic_tool_bar_more_button_img"] = basic_tool_bar_more_button_img
  end

  function load_dialog_search_bar()

  end

  if dialog_type=="no_button_dialog" then
    basic_positive_button.setVisibility(8)
    basic_negative_button.setVisibility(8)
   elseif dialog_type=="white_dialog" then
    basic_positive_button.setVisibility(8)
    basic_negative_button.setVisibility(8)
    basic_title_tv.setVisibility(8)
    tips_bar_view.setVisibility(8)

   elseif dialog_type=="tool_bar_with_only_back_mode_dialog" then
    basic_positive_button.setVisibility(8)
    basic_negative_button.setVisibility(8)
    basic_title_tv.setVisibility(8)
    tips_bar_view.setVisibility(8)
    basic_tool_bar_view.setVisibility(0)

    load_dialog_tool_bar(dialog_views_data,basic_tool_bar_main_view)

    basic_tool_bar_more_button.setVisibility(8)

    basic_search_bar_cancel_button = basic_search_bar_main_view.getChildAt(0)
    basic_search_bar_edit = basic_search_bar_main_view.getChildAt(1).getChildAt(0)
    basic_search_bar_cancel_button_img = basic_search_bar_cancel_button.getChildAt(0)
    basic_search_bar_search_button = basic_search_bar_main_view.getChildAt(2)
    basic_search_bar_search_button_img = basic_search_bar_search_button.getChildAt(0)

    dialog_views_data["basic_search_bar_cancel_button"] = basic_search_bar_cancel_button
    dialog_views_data["basic_search_bar_edit"] = basic_search_bar_edit
    dialog_views_data["basic_search_bar_cancel_button_img"] = basic_search_bar_cancel_button_img
    dialog_views_data["basic_search_bar_search_button"] = basic_tool_bar_more_lay
    dialog_views_data["basic_search_bar_search_button_img"] = basic_tool_bar_more_button_img

    system_ripple({basic_tool_bar_menu_button,basic_tool_bar_search_button,basic_tool_bar_more_button},"circular_theme")
    basic_tool_bar_menu_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_search_bar_cancel_button.onClick=function()
      basic_search_bar_root_view.setVisibility(8)
      basic_tool_bar_view.setVisibility(0)
    end

    basic_search_bar_search_button.onClick=function()
      basic_tool_bar_view.setVisibility(8)
      basic_search_bar_root_view.setVisibility(0)
    end
   elseif dialog_type=="tool_bar_dialog" then
    basic_positive_button.setVisibility(8)
    basic_negative_button.setVisibility(8)
    basic_title_tv.setVisibility(8)
    tips_bar_view.setVisibility(8)
    basic_tool_bar_view.setVisibility(0)

    load_dialog_tool_bar(dialog_views_data,basic_tool_bar_main_view)

    system_ripple({basic_tool_bar_menu_button,basic_tool_bar_search_button,basic_tool_bar_more_button},"circular_theme")
    basic_tool_bar_menu_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_search_bar_cancel_button.onClick=function()
      basic_search_bar_root_view.setVisibility(8)
      basic_tool_bar_view.setVisibility(0)
    end

    basic_search_bar_search_button.onClick=function()
      basic_tool_bar_view.setVisibility(8)
      basic_search_bar_root_view.setVisibility(0)
    end
   elseif dialog_type=="tool_bar_with_search_dialog" then
    basic_positive_button.setVisibility(8)
    basic_negative_button.setVisibility(8)
    basic_title_tv.setVisibility(8)
    tips_bar_view.setVisibility(8)
    basic_tool_bar_view.setVisibility(0)

    load_dialog_tool_bar(dialog_views_data,basic_tool_bar_main_view)

    basic_search_bar_cancel_button = basic_search_bar_main_view.getChildAt(0)
    basic_search_bar_edit = basic_search_bar_main_view.getChildAt(1).getChildAt(0)
    basic_search_bar_cancel_button_img = basic_search_bar_cancel_button.getChildAt(0)
    basic_search_bar_search_button = basic_search_bar_main_view.getChildAt(2)
    basic_search_bar_search_button_img = basic_search_bar_search_button.getChildAt(0)
    system_ripple({basic_tool_bar_menu_button,basic_search_bar_cancel_button,basic_search_bar_search_button,basic_tool_bar_search_button,basic_tool_bar_more_button},"circular_theme")
    basic_tool_bar_menu_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_tool_bar_search_button.onClick=function()
    end
    basic_search_bar_cancel_button.onClick=function()
      basic_search_bar_root_view.setVisibility(8)
      basic_top_bar_main_view.setVisibility(0)
    end

    basic_tool_bar_search_button.setVisibility(0)
    basic_tool_bar_more_button.setVisibility(8)

    basic_tool_bar_search_button.onClick=function()
      basic_top_bar_main_view.setVisibility(8)
      basic_search_bar_root_view.setVisibility(0)
    end
  end

  if title then
    basic_title_tv.setText(title)
    basic_tool_bar_title_tv.setText(title)
  end

  if value["view"] then
    local status=pcall(function()basic_content_view.addView(loadlayout(value["view"]))end)
    if not status then
      pcall(function()basic_content_view.addView(value["view"])end)
    end
  end
  return layout_basic_dialog,dialog_data
end




--基本对话框
function create_basic_dlg(value)
  local dialog_data={}
  local fullScreenStatus = value["fullScreenStatus"]
  local layout_basic_dialog,dialog_data=init_basic_dlg_layout(value)

  basic_dialog = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  basic_dialog.setContentView(layout_basic_dialog)

  if fullScreenStatus then
    setFullScreenBottomSheetDialog(basic_dialog)
  end
  return basic_dialog,dialog_data
end

--基本对话框
function create_basic_alert_dlg(value)
  local customLayout = value["customLayout"]
  local fullScreenStatus = value["fullScreenStatus"]
  local layout_basic_dialog=init_basic_dlg_layout(value)

  basic_alert_dialog=AlertDialog.Builder(activity)
  if customLayout==false then
   else
    basic_alert_dialog.setView(layout_basic_dialog)
  end

  local basic_alert_dialog_show = basic_alert_dialog.show().dismiss()
  local window = basic_alert_dialog_show.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  local wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  if fullScreenStatus then
    wlp.height = WindowManager.LayoutParams.MATCH_PARENT;
   else
    wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  end
  window.setAttributes(wlp);
  return basic_alert_dialog,basic_alert_dialog_show
end

--快捷代码对话框
function create_insert_code_dlg()
  import "system.codes.quick_codes"

  layout_insert_code_dialog=import "layout.layout_dialogs.layout_insert_code_dialog"
  insert_code_dialog_1,insert_code_dialog=create_basic_alert_dlg({title=gets("insert_code"),view=layout_insert_code_dialog,type="no_button_dialog"})

  local insert_code_expandable_lv_adp=ArrayExpandableListAdapter(activity)
  insert_code_expandable_lv.setAdapter(insert_code_expandable_lv_adp)
  insert_code_expandable_lv.onGroupClick=function(parent,view,group_position,id)
  end
  insert_code_expandable_lv.onChildClick=function(parent,view,group_position,child_position,id)
    local sub_key=quick_codes[group_position+1]
    local sub_codes=quick_codes[sub_key]
    if sub_codes then
      local content_key=sub_codes[child_position+1]
      local content=sub_codes[content_key]
      pcall(main_paste_text,content)
      insert_code_dialog.dismiss()
    end
  end

  for k,v in ipairs(quick_codes) do
    insert_code_expandable_lv_adp.add(v,quick_codes[v])
  end
  return insert_code_dialog
end

function create_project_operations_dlg()
  if project_operations_dlg then
   else
    local layout_project_operations_dlg=import "layout.layout_dialogs.layout_project_operations_dialog"
    project_operations_dlg=create_basic_dlg({title=gets("project_info"),view=layout_project_operations_dlg,type="no_button_dialog"})

    local project_info_dialog_gridview_item2=import "layout.layout_items.project_info_dialog_gridview_item2"
    project_operations_data={}
    project_operations_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
      getItemCount=function()
        return #project_operations_data
      end,
      getItemViewType=function(position)
        return 0
      end,
      onCreateViewHolder=function(parent,viewType)
        local ids={}
        local view=loadlayout(project_info_dialog_gridview_item2,ids)
        local holder=LuaRecyclerHolder(view)
        view.setTag(ids)

        ids.item.onClick=function()
          local tag_data=ids["tag_data"]
          local next_project_path=current_select_project_path
          local next_project_template=current_select_project_template
          local position=current_select_project_position
          local click=tag_data["click"]
          if system_incident[click] then
            system_incident[click](next_project_path,next_project_template,position)
           else
            system_print(gets("not_developed_yet"))
          end
          if project_operations_dlg then
            project_operations_dlg.dismiss()
          end
          return true
        end
        return holder
      end,
      onBindViewHolder=function(holder,position)
        local data=project_operations_data[position+1]
        local tag=holder.view.getTag()
        tag["tag_data"]=data
        tag["position"]=position+1
        setImage(tag.item_img,load_icon_path(data["icon"]))
        tag.item_text.setText(data["title"])
      end,
    }))

    local function pidga_add(click,icon,title)
      table.insert(project_operations_data,{icon=icon,title=title,click=click})
    end
    pidga_add("open_newwindow","photo_library",gets("open_by_window"))
    pidga_add("bin_project","adb",gets("bin_project"))
    pidga_add("clone_project","file_copy",gets("clone_project"))
    pidga_add("project_info_editor","settings",gets("project_info_editor"))
    pidga_add("fix_project","build",gets("fix_project"))
    pidga_add("save_project","save",gets("save_project"))
    pidga_add("share_project","open_in_new",gets("share_project"))
    pidga_add("delete_project","delete",gets("delete"))
    project_info_dialog_rv.setAdapter(project_operations_rv_adapter)
    if pad_mode then
      local projects_recyclerview_layout_manager2=StaggeredGridLayoutManager(8,StaggeredGridLayoutManager.VERTICAL)
      project_info_dialog_rv.setLayoutManager(projects_recyclerview_layout_manager2)
     else
      local projects_recyclerview_layout_manager2=StaggeredGridLayoutManager(4,StaggeredGridLayoutManager.VERTICAL)
      project_info_dialog_rv.setLayoutManager(projects_recyclerview_layout_manager2)
    end
  end
  return project_operations_dlg
end

--system dialog 系统对话框
function system_dialog(value)
  local title=value["title"]
  local message=value["message"]
  local positive_button=value["positive_button"]
  local neutral_button=value["neutral_button"]
  local negative_button=value["negative_button"]
  dialog=AlertDialog.Builder(this)
  if title then
    dialog.setTitle(title)
  end
  if message then
    dialog.setMessage(message)
  end
  if positive_button then
    dialog.setPositiveButton(positive_button["button_name"],positive_button["func"])
  end
  if neutral_button then
    dialog.setNeutralButton(neutral_button["button_name"],neutral_button["func"])
  end
  if negative_button then
    dialog.setNegativeButton(negative_button["button_name"],negative_button["func"])
  end
  dialog2=dialog.show()
  local radiu=15
  set_dialog_style(dialog2)
  return dialog2
end

function create_login_dlg()
  login_dialog=ProgressDialog(this,R.style.AlertDialogTheme)
  login_dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER)
  login_dialog.setTitle(gets("tip_text"))
  login_dialog.setMessage(gets("logining_tips"))
  login_dialog.setCancelable(false)
  login_dialog.setCanceledOnTouchOutside(false)
  return login_dialog.show().dismiss()
end