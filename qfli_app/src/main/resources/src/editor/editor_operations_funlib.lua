function load_lua_keywords()
  local system_ms={
    "get_string","copy_text","load_font_path","load_font_file","load_font_res",
    "load_font","load_icon_path","backup_project","SystemEditText",
    "choose_file","arbg_dialog_func","system_print","load_system_popup",
    "editor_icons","system_dialog","system_title_color","get_resources",
    "get_ui_mode","get_theme_color","change_color_strength","replace_text","widget_radius",
    "read_lsinfo_file","read_alp_file","import_project","fix_project",
    "import_alp_project","share_file","getr","pc","ul","gets","error_dialog",
    "environment_path","cache_path","project_path","project_storage",
    "plugin_path","backup_path","data_storage","custom_path",
  "loadlayout","setContentView","activity","import","md5","cjson","json","setTheme","setTitle","require"
  }
  local ms={
    "newLSActivity","onCreate","onStart","onResume","onPause","onStop",
    "onDestroy","onActivityResult","onResult","onCreateOptionsMenu",
    "onOptionsItemSelected","onClick","onTouch","onLongClick","onItemClick",
    "LuaEditor","QKEditor","MyEditor","PhotoView"}
  local zh_ms={
    "内部储存地址","图标储存地址","储存地址","调用系统发送短信","加QQ群",
    "联系QQ","分享文件","分享文本","调用系统浏览器搜索","调用系统浏览器打开链接",
    "打开程序","安装程序","卸载程序","播放MP4","播放MP3","拨号","搜索应用",
    "调用系统打开文件","发送彩信","打开系统设置","打开APN设置","打开位置和访问信息设置",
    "打开网络设置","打开无线和网络热点设置","打开位置和安全设置","打开无线网WIFI设置",
    "打开无线网IP设置","打开蓝牙设置","打开时间和日期设置","打开声音设置",
    "打开显示设置","打开语言设置","两角圆弧","渐变","导航栏颜色","通知栏颜色",
    "状态栏颜色","沉浸状态栏","状态栏亮色","状态栏暗色","获取状态栏高度","隐藏状态栏",
    "打开输入法设置","打开用户词典","打开应用程序设置","打开开发者选项","打开快速启动设置",
    "打开已下载软件列表","打开应用程序数据同步设置","打开可用网络搜索","打开移动网络设置",
    "打开默认存储设置","打开SD卡存储设置","进入子页面","加载Js","加载网页","刷新网页",
    "网页前进","网页后退","停止加载","退出程序","退出页面","GetFileSize","文件是否存在",
    "文件夹是否存在","创建多级文件夹","创建文件夹","创建文件","写入文件","读取文件",
    "删除文件","解压文件","复制文件","获取设备ID","获取设备IMEI","获取设备屏幕尺寸",
    "后台发送短信","获取剪切板内容","复制文本","关闭WIFI","打开WIFI","删除浏览器进度条",
    "设置图片src","关闭弹窗","跳转页面2","弹出菜单","设置文本","获取屏幕宽","获取屏幕高",
    "获取文本","编辑框颜色","进度条颜色","控件颜色","获取手机存储路径","打印","提示",
    "自定义位置提示","带图片的提示","自定义提示","控件高","控件宽","文本颜色",
    "导入包类","点击事件","长按事件","列表项目被单击","列表项目被长按","控件可视",
    "控件不可视","关闭侧滑","打开侧滑","关闭右侧滑","打开右侧滑", "关闭左侧滑",
    "打开左侧滑","设置主题","设置标题","隐藏标题栏","设置布局",
    "使弹出的输入法不影响布局","使弹出的输入法影响布局","重置当前页面","波纹",
    "控件圆角","设置按钮颜色"}

  for k,v in ipairs(system_ms) do
    table.insert(ms,v)
  end
  for k,v in ipairs(zh_ms) do
    table.insert(ms,v)
  end
  return ms
end

if lua_keywords then
 else
  lua_keywords=load_lua_keywords()
end

local function cancel_selected(editor)
  local cursor=editor.cursor
  if cursor.isSelected then
    local right_line=cursor.getRightLine()
    local right_column=cursor.getRightColumn()
    editor.setSelection(right_line,right_column)
  end
end

local function add_names()
  require "import"
  local classes=require "android_libs"
  local system_ms={
    "get_string","copy_text","load_font_path","load_font_file","load_font_res",
    "load_font","load_icon_path","backup_project","SystemEditText",
    "choose_file","arbg_dialog_func","system_print","load_system_popup",
    "editor_icons","system_dialog","system_title_color","get_resources",
    "change_color_strength","replace_text","widget_radius",
    "read_lsinfo_file","read_alp_file","import_project","fix_project",
    "import_alp_project","share_file","getr","pc","ul","gets","error_dialog",
    "environment_path","cache_path","project_path","project_storage",
    "plugin_path","backup_path","data_storage","custom_path"}
  local ms={
    "newLSActivity","onCreate","onStart","onResume","onPause","onStop",
    "onDestroy","onActivityResult","onResult","onCreateOptionsMenu",
    "onOptionsItemSelected","onClick","onTouch","onLongClick","onItemClick",
    "LuaEditor","QKEditor","MyEditor","PhotoView"}
  local zh_ms={
    "内部储存地址","图标储存地址","储存地址","调用系统发送短信","加QQ群",
    "联系QQ","分享文件","分享文本","调用系统浏览器搜索","调用系统浏览器打开链接",
    "打开程序","安装程序","卸载程序","播放MP4","播放MP3","拨号","搜索应用",
    "调用系统打开文件","发送彩信","打开系统设置","打开APN设置","打开位置和访问信息设置",
    "打开网络设置","打开无线和网络热点设置","打开位置和安全设置","打开无线网WIFI设置",
    "打开无线网IP设置","打开蓝牙设置","打开时间和日期设置","打开声音设置",
    "打开显示设置","打开语言设置","两角圆弧","渐变","导航栏颜色","通知栏颜色",
    "状态栏颜色","沉浸状态栏","状态栏亮色","状态栏暗色","获取状态栏高度","隐藏状态栏",
    "打开输入法设置","打开用户词典","打开应用程序设置","打开开发者选项","打开快速启动设置",
    "打开已下载软件列表","打开应用程序数据同步设置","打开可用网络搜索","打开移动网络设置",
    "打开默认存储设置","打开SD卡存储设置","进入子页面","加载Js","加载网页","刷新网页",
    "网页前进","网页后退","停止加载","退出程序","退出页面","GetFileSize","文件是否存在",
    "文件夹是否存在","创建多级文件夹","创建文件夹","创建文件","写入文件","读取文件",
    "删除文件","解压文件","复制文件","获取设备ID","获取设备IMEI","获取设备屏幕尺寸",
    "后台发送短信","获取剪切板内容","复制文本","关闭WIFI","打开WIFI","删除浏览器进度条",
    "设置图片src","关闭弹窗","跳转页面2","弹出菜单","设置文本","获取屏幕宽","获取屏幕高",
    "获取文本","编辑框颜色","进度条颜色","控件颜色","获取手机存储路径","打印","提示",
    "自定义位置提示","带图片的提示","自定义提示","控件高","控件宽","文本颜色",
    "导入包类","点击事件","长按事件","列表项目被单击","列表项目被长按","控件可视",
    "控件不可视","关闭侧滑","打开侧滑","关闭右侧滑","打开右侧滑", "关闭左侧滑",
    "打开左侧滑","设置主题","设置标题","隐藏标题栏","设置布局",
    "使弹出的输入法不影响布局","使弹出的输入法影响布局","重置当前页面","波纹",
    "控件圆角","设置按钮颜色"}
  for k,v in ipairs(system_ms) do
    table.insert(ms,v)
  end
  for k,v in ipairs(zh_ms) do
    table.insert(ms,v)
  end
  local buf=String[#ms+#classes]
  for k,v in ipairs(ms) do
    buf[k-1]=v
  end
  local l=#ms
  for k,v in ipairs(classes) do
    buf[l+k-1]=string.match(v,"%w+$")
  end
  return buf
end

local sora_lib={}
local lua_editor_lib={}
--撤销
sora_lib["undo"]=function(editor)
  editor.undo()
end
lua_editor_lib["undo"]=function(editor)
  editor.undo()
end
--重做
sora_lib["redo"]=function(editor)
  editor.redo()
end
lua_editor_lib["redo"]=function(editor)
  editor.redo()
end
--切换语言
sora_lib["swtich_language"]=function(editor,scope_name)
  local language=TextMateLanguage.create(scope_name,grammar_registry, theme_registry,true)
  if scope_name=="source.lua" then
    if lua_keywords then
     else
      lua_keywords=load_lua_keywords()
    end
    language.setCompleterKeywords(lua_keywords)
  end
  editor.setEditorLanguage(language)
end
lua_editor_lib["swtich_language"]=function(editor)
end
--复制文本
sora_lib["copy_text"]=function(editor)
  local cursor=editor.cursor
  if cursor.isSelected then
    editor.copyText()
    cancel_selected(editor)
  end
end
lua_editor_lib["copy_text"]=function(editor)
  editor.copy()
end
--粘贴文本
sora_lib["paste_text"]=function(editor)
  editor.pasteText()
end
lua_editor_lib["paste_text"]=function(editor)
  editor.paste()
end
--全选文本
sora_lib["selet_all_text"]=function(editor)
  editor.selectAll()
end
lua_editor_lib["selet_all_text"]=function(editor)
  editor.selectAll()
end
--剪切文本
sora_lib["cut_text"]=function(editor)
  local cursor=editor.cursor
  if cursor.isSelected then
    editor.cutText()
  end
end
lua_editor_lib["cut_text"]=function(editor)
  editor.cut()
end
--选择行
sora_lib["select_line"]=function(editor)
  local cursor=editor.cursor
  local left_line=cursor.getLeftLine()
  local content=luajava.bindClass("io.github.rosemoe.sora.text.Content")
  local right_column=(content(editor.text).getColumnCount(left_line))
  --print(right_column)
  cursor.setLeft(left_line,0)
  cursor.setRight(left_line,right_column)
  editor.invalidate();
end
sora_lib["select_line_2"]=function(editor)
  local cursor=editor.cursor
  local left_line=cursor.getLeftLine()
  local Content=luajava.bindClass("io.github.rosemoe.sora.text.Content")
  local content=Content(editor.text)
  local all_lines=content.getLineCount()
  if left_line==0 then
    local right_column=(content.getColumnCount(left_line))
    cursor.setLeft(left_line,0)
    if all_lines==1 and right_column~=0 then
      cursor.setRight(left_line,right_column)
      return true
     elseif all_lines~=1 and right_column~=0 then
      cursor.setRight(left_line+1,0)
      return true
     else
      return false
    end
   else
    local left_column=(content.getColumnCount(left_line-1))
    local right_column=(content.getColumnCount(left_line))
    cursor.setLeft(left_line-1,left_column)
    cursor.setRight(left_line,right_column)
    return true
  end
  editor.invalidate();
end
lua_editor_lib["select_line"]=function(editor)
  local start_caretrow=editor.getCaretRow()
  editor.gotoLine(start_caretrow + 1)
  editor.setSelection(editor.getSelectionEnd())
  local start_position=editor.getCaretPosition()
  editor.gotoLine(start_caretrow + 2)
  local to_position=editor.getCaretPosition()
  editor.setSelection(start_position,to_position-start_position-1)
end
lua_editor_lib["select_line_2"]=function(editor)
  local start_caretrow=editor.getCaretRow()
  editor.gotoLine(start_caretrow + 1)
  editor.setSelection(editor.getSelectionEnd())
  local start_position=editor.getCaretPosition()
  editor.gotoLine(start_caretrow + 2)
  local to_position=editor.getCaretPosition()
  editor.setSelection(start_position,to_position-start_position)
end
--格式化代码
sora_lib["format_code"]=function(editor)
  --[[import "com.luastudio.azure.system.LuaFormatter"
  import "io.github.rosemoe.sora.text.Content"
  FormatResultReceiver=import "io.github.rosemoe.sora.lang.format.Formatter$FormatResultReceiver"
  local content = Content(editor.text);

  formatter = LuaFormatter()
  formatter.setReceiver(FormatResultReceiver{
    onFormatSucceed=function(applyContent, cursorRange)
      editor.selectAll()
      editor.deleteText()
      editor.insertText(tostring(applyContent),0)
      local start=cursorRange.getStart()
      local end_p=cursorRange.getEnd()
      editor.setSelection(start.line,start.column)
    end,
    onFormatFail=function(throwable)
    end
  });
  formatContent = text.copyText(false);
  formatContent.setUndoEnabled(false);
  formatter.format(formatContent, editor.getCursorRange());
  editor.postInvalidate();
  
]]
  editor.formatCodeAsync()

  --[[  local scroll_y=(editor.getScrollY()+500)
  local cursor=editor.cursor
  local left_line=cursor.getLeftLine()
  local current_content=editor.getText()
  local formatted_code=format_lua_code(current_content)
  local current_content=tostring(current_content)
  if current_content~=formatted_code then
    editor.setText(formatted_code)
    task(50,function()
      editor.setSelection(left_line,0)
      editor.scrollTo(0,scroll_y)
    end)
  end]]
end
lua_editor_lib["format_code"]=function(editor)
  editor.format()
end
--插入文本
sora_lib["insert_text"]=function(editor,text)
  editor.insertText(text,1)
end
lua_editor_lib["insert_text"]=function(editor,text)
  editor.paste(text)
end
sora_lib["insert_text_2"]=function(editor,text)
  editor.insertText(text,0)
end
sora_lib["insert_text_3"]=function(editor,text,position)
  local insert_position=position or 1
  editor.insertText(text,insert_position)
end

--快捷操作：复制行
sora_lib["copy_line"]=function(editor)
  local cursor=editor.cursor
  local right_line=cursor.getRightLine()
  local right_column=cursor.getRightColumn()
  current_editor_lib["select_line"](current_editor)
  current_editor_lib["copy_text"](current_editor)
  current_editor.setSelection(right_line,right_column)
end
lua_editor_lib["copy_line"]=function(editor)
  last_editor_selectEnd=lua_editor_lib["get_selection_end"](editor)
  lua_editor_lib["select_line"](editor)
  lua_editor_lib["copy_text"](editor)
  editor.setSelection(last_editor_selectEnd)
end
--快捷操作：剪切行
sora_lib["cut_line"]=function(editor)
  if sora_lib["select_line_2"](editor) then
    sora_lib["cut_text"](editor)
  end
end
lua_editor_lib["cut_line"]=function(editor)
  lua_editor_lib["select_line_2"](editor)
  editor.cut()
end
--快捷操作：删除行
sora_lib["delete_line"]=function(editor)
  if sora_lib["select_line_2"](editor) then
    editor.deleteText()
  end
end
lua_editor_lib["delete_line"]=function(editor)
  lua_editor_lib["select_line_2"](editor)
  editor.paste("")
  editor.setSelection(tonumber(editor.getCaretPosition() - 1))
end
--快捷操作：重复行
sora_lib["repeat_line"]=function(editor)
  editor.duplicateLine()
end
lua_editor_lib["repeat_line"]=function(editor)
  lua_editor_lib["select_line"](editor)
  editor.insert(editor.getSelectionEnd(), "\n" .. editor.getSelectedText())
end
--快捷操作：清空行
sora_lib["clear_line"]=function(editor)
  sora_lib["select_line"](editor)
  sora_lib["insert_text_2"](editor,"")
end
lua_editor_lib["clear_line"]=function(editor)
  lua_editor_lib["select_line"](editor)
  editor.paste("")
end
--快捷操作：注释行
sora_lib["comment_line"]=function(editor)
  local cursor=editor.cursor
  local left_line=cursor.getLeftLine()
  local right_line=cursor.getRightLine()
  local left_column=cursor.getLeftColumn()
  local right_column=cursor.getRightColumn()
  local selected_text=tostring(editor.getText().subContent(left_line, left_column, right_line, right_column))
  if cursor.isSelected then
    if (left_line==right_line) then
      local new_selected_text="--"..selected_text
      sora_lib["insert_text"](editor,new_selected_text)
     else
      local new_selected_text="--[["..selected_text.."]]\n"
      sora_lib["insert_text"](editor,new_selected_text)
    end
  end
end
lua_editor_lib["comment_line"]=function(editor)
  if (open_file_type and open_file_type=="lua") then
    lua_editor_lib["select_line"](editor)
    if string.sub(String((editor.getSelectedText())).trim(), 1, 2) == "--" then
      editor.setSelection(editor.getSelectionStart() + tointeger(String(String((editor.getSelectedText())).replaceAll("([ ]*).*", "$1")).length()), 2)
      editor.paste("")
      editor.gotoLine(editor.getCaretRow() + 2)
      editor.setSelection(editor.getCaretPosition() - 1)
     else
      editor.insert(editor.getSelectionStart() + tointeger(String(String((editor.getSelectedText())).replaceAll("([ ]*).*", "$1")).length()), "--")
      editor.gotoLine(editor.getCaretRow() + 2)
      editor.setSelection(editor.getCaretPosition() - 1)
    end
  end
end
--初始化高亮
sora_lib["init_hightlight"]=function(editor)
  import "io.github.rosemoe.sora.langs.textmate.TextMateColorScheme"
  TextMateLanguage=luajava.bindClass "io.github.rosemoe.sora.langs.textmate.TextMateLanguage"
  --TextMateLanguage=luajava.bindClass "com.luastudio.azure.editor.formatter.LuaTextMateLanguage"
  import "io.github.rosemoe.sora.langs.textmate.registry.FileProviderRegistry"
  import "io.github.rosemoe.sora.langs.textmate.registry.GrammarRegistry"
  import "io.github.rosemoe.sora.langs.textmate.registry.ThemeRegistry"
  import "io.github.rosemoe.sora.langs.textmate.registry.model.DefaultGrammarDefinition"
  import "io.github.rosemoe.sora.langs.textmate.registry.model.ThemeModel"
  import "io.github.rosemoe.sora.langs.textmate.registry.provider.AssetsFileResolver"
  import "org.eclipse.tm4e.core.registry.IGrammarSource"
  if pcall(function()
      IThemeSource=import "org.eclipse.tm4e.core.registry.IThemeSource$-CC"
    end) then
   else
    IThemeSource=import "org.eclipse.tm4e.core.registry.IThemeSource"
  end
  import "java.io.BufferedReader"
  import "java.io.InputStreamReader"

  local assets_manager=activity.getAssets();
  FileProviderRegistry.getInstance().addFileProvider(AssetsFileResolver(assets_manager))

  grammar_registry=GrammarRegistry.getInstance()
  grammar_registry.loadGrammars("textmate/languages.json")

  local editor_theme_file=File(editor_theme_file_path)
  local input_stream=FileInputStream(editor_theme_file)

  local theme_registry = ThemeRegistry.getInstance()
  theme_registry.loadTheme(ThemeModel(IThemeSource.fromInputStream(input_stream, "quietlight.json", null), "luastudio"))
  theme_registry.setTheme("luastudi_theme")

  local editorColorScheme = TextMateColorScheme.create(theme_registry)
  editor.setColorScheme(editorColorScheme)

  return grammar_registry,theme_registry
end
lua_editor_lib["init_hightlight"]=function(editor)
  if init_editor_colors then
   else
    load_editor_color_data()
    baseword_color = editor_colors_data["baseword_color"]
    keyword_color = editor_colors_data["keyword_color"]
    comment_color = editor_colors_data["comment_color"]
    userword_color = editor_colors_data["userword_color"]
    string_color = editor_colors_data["string_color"]
    editor_text_color = editor_colors_data["editor_text_color"]

    baseword_color=pc(baseword_color)
    keyword_color=pc(keyword_color)
    comment_color=pc(comment_color)
    userword_color=pc(userword_color)
    string_color=pc(string_color)
    editor_text_color=pc(editor_text_color)
    init_editor_colors=true
  end

  editor.setBasewordColor(int(baseword_color))
  editor.setKeywordColor(int(keyword_color))
  editor.setCommentColor(int(comment_color))
  editor.setUserwordColor(int(userword_color))
  editor.setStringColor(int(string_color))
  editor.setTextColor(int(editor_text_color))
end
--设置编辑器属性
sora_lib["set_attributes"]=function(editor,language_name)
  local editor_typeface=(load_font("editor") or (Typeface.MONOSPACE))
  editor.setTypefaceText(editor_typeface)
  --隐藏滑条
  editor.horizontalScrollBarEnabled=false
  --editor.verticalScrollBarEnabled=false
  --editor.overScrollMode=View.OVER_SCROLL_NEVER;
  grammar_registry,theme_registry=sora_lib["init_hightlight"](editor)
  --local language_name=(language_name)
  local language=TextMateLanguage.create(language_name,grammar_registry, theme_registry,true)
  if language_name=="source.lua" then
    if lua_keywords then
     else
      lua_keywords=load_lua_keywords()
    end
    language.setCompleterKeywords(lua_keywords)
  end
  editor.setEditorLanguage(language)

  local LongPressEvent=luajava.bindClass "io.github.rosemoe.sora.event.LongPressEvent"
  local ContentChangeEvent=luajava.bindClass "io.github.rosemoe.sora.event.ContentChangeEvent"
  local SelectionChangeEvent=luajava.bindClass "io.github.rosemoe.sora.event.SelectionChangeEvent"

  editor.subscribeEvent(SelectionChangeEvent,{
    onReceive=function(event,unsubscribe)
      local cause=(event.getCause())
      if (cause==SelectionChangeEvent.CAUSE_TEXT_MODIFICATION or cause==SelectionChangeEvent.CAUSE_TAP)
        update_file_position(editor)
      end
    end});

  editor.subscribeEvent(LongPressEvent,{
    onReceive=function(event,unsubscribe)
      if search_mode then
        tool_bar_id.setVisibility(8)
        search_bar_id.setVisibility(8)
        toline_bar_id.setVisibility(8)
        control_bar_id.setVisibility(0)
      end
    end});

  editor.subscribeEvent(ContentChangeEvent,{
    onReceive=function(event,unsubscribe)
      if (event.getAction()) then
        if (get_editor_setting("files_auto_save")) then
          save_opened_file(current_file_name)
        end
        if realtime_check_error then
          check_code_main()
        end
       else
        update_open_file_path(current_open_file_path,true)
      end
      if (event.getAction()==ContentChangeEvent.ACTION_SET_NEW_TEXT) then
       elseif (event.getAction()==ContentChangeEvent.ACTION_SET_NEW_TEXT) then
       elseif (event.getAction()==ContentChangeEvent.ACTION_SET_NEW_TEXT) then
      end
    end});
end
lua_editor_lib["set_attributes"]=function(editor)
  lua_editor_lib["init_hightlight"](editor)
  task(add_names,function(buf)
    editor.addNames(buf)
  end)


end
--跳转行
sora_lib["goto_line"]=function(editor,line)
  editor.setSelection(line-1,0)
end
--跳转行
sora_lib["get_support_languages"]=function()
  local support_languages={
    "java","kotlin","lua","python","xml","html","javascript",
    "markdown","txt",
    java="source.java",
    kotlin="source.kotlin",
    lua="source.lua",
    python="source.python",
    xml="text.xml",
    html="text.html.basic",
    javascript="source.js",
    markdown="text.html.markdown",
    txt="text.html.markdown"
  }
  return support_languages
end
--跳转行
lua_editor_lib["get_support_languages"]=function(editor_name)
  if editor_name=="MyEditor" then
    local support_languages={
      java="java",
      lua="lua",
      xml="xml",
      txt=""
    }
    return support_languages
   else
    local support_languages={
      lua="lua",
      txt=""
    }
    return support_languages
  end
end
lua_editor_lib["goto_line"]=function(editor,line)
  editor.gotoLine(line)
end
--获取选中文本
sora_lib["get_selected_text"]=function(editor)
  local cursor=editor.cursor
  if cursor.isSelected then
    local left_line=cursor.getLeftLine()
    local right_line=cursor.getRightLine()
    local left_column=cursor.getLeftColumn()
    local right_column=cursor.getRightColumn()
    local selected_text=tostring(editor.getText().subContent(left_line, left_column, right_line, right_column))
    return selected_text
   else
    return ""
  end
end
lua_editor_lib["get_selected_text"]=function(editor)
  return editor.getSelectedText()
end
--停止搜索
sora_lib["stop_search"]=function(editor)
  search_mode=false
  current_search_key=""
  local editor_searcher=editor.searcher
  editor_searcher.stopSearch()
  editor.invalidate();
end
--获取光标位置
lua_editor_lib["get_selection_end"]=function(editor)
  local select_end=editor.getSelectionEnd()
  return select_end
end
--重新注册选择事件
sora_lib["register_selection_change_event"]=function(editor)
  local SelectionChangeEvent=luajava.bindClass "io.github.rosemoe.sora.event.SelectionChangeEvent"
  editor.subscribeEvent(SelectionChangeEvent,{
    onReceive=function(event,unsubscribe)
      if search_mode then
       else
        if (event.isSelected()) then
          updateUI({editor_select_status=true})

          editorSelectionChangeEventStatus=true
         else
          updateUI({editor_select_status=false})

          editorSelectionChangeEventStatus=false
        end
      end
    end
  })
end
lua_editor_lib["register_selection_change_event"]=function(editor)
  editor.OnSelectionChangedListener=function(status,Start,End)
    if status == true then
      current_end=End
      updateUI({editor_select_status=true})
     else
      updateUI({editor_select_status=false})
    end
  end
end

editor_opeartions={}
editor_opeartions["SoraEditor"]=sora_lib
editor_opeartions["MyEditor"]=lua_editor_lib
editor_opeartions["LuaEditor"]=lua_editor_lib