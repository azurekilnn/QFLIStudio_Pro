set_style()
import "editor.editor_funlib"
import "editor.editor_operations_funlib"
import "system.emlog_funlib"
import "system.system_dialogs"
import "io.noties.markwon.Markwon"
import "java.util.concurrent.Executors"
import "io.noties.markwon.image.glide.GlideImagesPlugin"
import "io.noties.markwon.image.*"
import "io.github.rosemoe.sora.widget.CodeEditor"
setCommonView("layout.layout_post_article_activity",gets("post_article_text"),"back_with_more_mode")

preview_layout={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  id="preview_tv_background";
  Visibility="8";
  {
    MaterialCardView;
    layout_margin="8dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_height="fill";
    layout_width="fill";
    CardBackgroundColor=get_theme_color("background_color");
    {
      LinearLayoutCompat;
      layout_height="wrap";
      layout_width="fill";
      orientation="vertical";
      padding="8dp";
      background=Ripple(nil,0x22000000);
      {
        TextView;
        layout_height="wrap";
        layout_width="fill";
        id="title_tv";
        textColor=text_color;
        textIsSelectable=true;
        layout_margin="10dp";
        textSize="18sp";

        singleLine=true;
      };
      {
        TextView;
        layout_height="fill";
        layout_width="fill";
        id="preview_tv";
        textColor=text_color;
        layout_margin="10dp";

        textIsSelectable=true;
      };
    };
  };
};

additional_options_layout={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  id="additional_options_background";
  Visibility="8";
  {
    MaterialCardView;
    layout_margin="8dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_height="fill";
    layout_width="fill";
    CardBackgroundColor=get_theme_color("background_color");
    {
      LinearLayoutCompat;
      layout_height="wrap";
      orientation="vertical";
      layout_width="fill";
      {
        ScrollView;
        layout_height="wrap";
        layout_width="fill";
        {
          LinearLayoutCompat;
          layout_height="wrap";
          orientation="vertical";
          layout_width="fill";
          paddingBottom="40dp";
          padding="8dp";

          {
            EditText;
            id="cover_edit";
            hint=gets("cover_edit_hint");
            layout_width="fill";
            layout_height="wrap";
            gravity="left|center";
            background="#00000000";
            textColor=text_color;
            HintTextColor=get_theme_color("paratext_color");
            paddingLeft="8dp";
            textSize="14sp";
            singleLine=true;
            layout_margin="8dp";
            padding="12dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            layout_weight="1";
            Typeface=load_font("common");
          };
          {
            ImageView;
            layout_margin="8dp";
            id="upload_cover_img";
            layout_gravity="center";
            layout_width="wrap";
            layout_height="wrap";
            layout_weight="1";
          };
          {
            Button;
            text=gets("upload_cover_text");
            layout_marigin="20dp";
            id="upload_cover_button";
            layout_gravity="right";
            layout_weight="1";
          };
          {
            EditText;
            id="excerpt_edit";
            hint=gets("excerpt_edit_hint");
            layout_width="fill";
            layout_height="wrap";
            gravity="left|center";
            background="#00000000";
            textColor=text_color;
            HintTextColor=get_theme_color("paratext_color");
            paddingLeft="8dp";
            textSize="14sp";
            singleLine=true;
            layout_margin="8dp";
            padding="12dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            layout_weight="1";
            Typeface=load_font("common");
          };
          {
            EditText;
            id="tags_edit";
            hint=gets("tags_edit_hint");
            layout_width="fill";
            layout_height="wrap";
            gravity="left|center";
            background="#00000000";
            textColor=text_color;
            HintTextColor=get_theme_color("paratext_color");
            paddingLeft="8dp";
            textSize="14sp";
            singleLine=true;
            layout_margin="8dp";
            padding="12dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            layout_weight="1";
            Typeface=load_font("common");
          };
          {
            LinearLayoutCompat;
            layout_width="-1";
            gravity='center';
            id="sw_background_1";
            layout_height="-1";
            orientation="vertical";
            style='?android:attr/buttonBarButtonStyle';
            {
              Switch;
              text=gets("draft_mode_text");
              id="switch_1";
              layout_gravity="right";
            };
          };
        };
      };
    };
  };
};


main_handler_run(function()
  page_2_background.addView(loadlayout(preview_layout))
  page_3_background.addView(loadlayout(additional_options_layout))

  view_radius(cover_edit,dp2px(8),pc(gray_color))
  view_radius(excerpt_edit,dp2px(8),pc(gray_color))
  view_radius(tags_edit,dp2px(8),pc(gray_color))

  sw_background_1.onClick=function()
    if switch_1.isChecked() then
      switch_1.setChecked(false)
      draft_mode="n"
     else
      switch_1.setChecked(true)
      draft_mode="y"
    end
  end

  upload_cover_button.onClick=function()
    system_choose_file("image/*",function(path,name)
      if uploading_dlg then
       else
        uploading_dlg=create_uploading_dlg()
      end
      uploading_dlg.show()
      upload_file(cloud_url,path,function(code,content,url)
        uploading_dlg.dismiss()
        if code==302 then
          local url=url_filter(tostring(url))
          cover_edit.setText(url)
          setImage(upload_cover_img,url)
         else
          system_print(gets("upload_unsuccessfully_tip"))
        end
      end)
    end)
  end
  markwon = Markwon.builder(activity)
  .usePlugin(ImagesPlugin.create())
  .usePlugin(GlideImagesPlugin.create(activity))
  .usePlugin(AzureUtil.createGifGlideImagesPlugin(activity))
  .build();

  chip_edit.onClick=function()
    preview_tv_background.setVisibility(8)
    edit_article_background.setVisibility(0)
    additional_options_background.setVisibility(8)
  end
  chip_preview.onClick=function()
    preview_tv_background.setVisibility(0)
    edit_article_background.setVisibility(8)
    additional_options_background.setVisibility(8)
  end
  chip_additional_options.onClick=function()
    preview_tv_background.setVisibility(8)
    edit_article_background.setVisibility(8)
    additional_options_background.setVisibility(0)
  end
  local get_user_info_status,user_info=get_saved_user_info()
  if get_user_info_status then
    user_cookies=user_info["cookies"]
  end
  draft_mode="n"
  more_button.onClick=function()
    if (get_user_info_status and user_cookies) then
      if (title_edit.text~="" and editor.text~="") then

        local other_data={
          --文章摘要
          excerpt=excerpt_edit.text,
          --文章封面
          cover=cover_edit.text,
          --标签
          tags=tags_edit.text,
          --分类ID
          sort_id="7",
          --草稿
          draft=draft_mode,--y
        }
        post_article(title_edit.text,editor.text,user_cookies,other_data,function(status,msg,data,article_id)
          if status then
            system_print(gets("send_article_successfully"))
            activity.result({"article_update"})
           else
            system_print(gets("send_article_unsuccessfully"))
          end
        end)
       else
        system_print(gets("input_nil"))
      end
     else
      system_print(gets("login_status_has_expired"))
    end
  end

  title_edit.addTextChangedListener{
    onTextChanged=function(c)
      local s=tostring(c)
      title_tv.setText(s)
    end
  }
  local ContentChangeEvent=luajava.bindClass "io.github.rosemoe.sora.event.ContentChangeEvent"
  editor.subscribeEvent(ContentChangeEvent,{
    onReceive=function(event,unsubscribe)
      if (event.getAction()) then
        markwon.setMarkdown(preview_tv, editor.getText().toString());
      end
    end
  });


end,500)
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
view_radius(title_edit,dp2px(8),pc(gray_color))

setImage(more_img,load_icon_path("check"))
system_ripple({back_button,more_button},"circular_theme")
current_editor_lib=editor_opeartions["SoraEditor"]
local editor_typeface=(load_font("editor") or (Typeface.MONOSPACE))
editor.setTypefaceText(editor_typeface)
--隐藏滑条
editor.horizontalScrollBarEnabled=false
editor.getTextActionWindow().setEnabled(true)
grammar_registry,theme_registry=current_editor_lib["init_hightlight"](editor)
local language=TextMateLanguage.create("text.html.markdown",grammar_registry, theme_registry,true)
editor.setEditorLanguage(language)
chip_edit.setChecked(true)

function create_upload_dlg()

  local layout_file_upload_dlg = import "layout.layout_dialogs.layout_img_upload_dialog"
  local file_upload_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  file_upload_dlg.setContentView(loadlayout(layout_file_upload_dlg))

  dialog_corner(layout_file_upload_dlg_background,pc(get_theme_color("background_color")),radiu)
  widget_radius(file_upload_dlg_ok_button,basic_color_num,radiu)

  file_upload_dlg_helpertext_1.setVisibility(8)

  return file_upload_dlg
end

function insert_incident_2(title,onclick)
  preview_chipgroup.addView(loadlayout({
    Chip;
    text=gets(title);
    checkable=false;
    checkedIconEnabled=false;
    onClick=onclick;
  }))
end

function insert_incident(title,symbol,position)
  preview_chipgroup.addView(loadlayout({
    Chip;
    text=gets(title);
    checkable=false;
    checkedIconEnabled=false;
    onClick=function()
      current_editor_lib["insert_text_3"](editor,symbol,position)
    end;
  }))
end

insert_incident("H¹","# ",2)
insert_incident("H²","## ",3)
insert_incident("H³","### ",4)
insert_incident("B","****",2)
insert_incident("删除线","~~~~",2)
insert_incident("横线","------------\n",12)
insert_incident("I","**",1)
insert_incident("无序列表","- ",2)
insert_incident("有序列表","1. ",3)
insert_incident_2("插入图片",function()
  system_choose_file("image/*",function(path,name)
    if uploading_dlg then
     else
      uploading_dlg=create_uploading_dlg()
    end
    uploading_dlg.show()
    upload_file(cloud_url,path,function(code,content,url)
      uploading_dlg.dismiss()
      if code==302 then
        local url=url_filter(tostring(url))
        if insert_img_dlg then
         else
          insert_img_dlg=create_upload_dlg()
        end
        insert_img_dlg.show()
        img_url_edit.setText(url)
        img_desc_edit.setText("")
        file_upload_dlg_ok_button.onClick=function()
          local img_template='![%s](%s "%s")'
          local content=string.format(img_template,img_desc_edit.text,url,img_desc_edit.text)
          current_editor_lib["insert_text"](editor,content)
          insert_img_dlg.dismiss()
        end
       else
        system_print(gets("upload_unsuccessfully_tip"))
      end
    end)
  end)
end)