local ver = activity.getPackageManager().getPackageInfo(activity.getPackageName(),0).versionName
local code = activity.getPackageManager().getPackageInfo(activity.getPackageName(),0).versionCode
log_zh=[[特别注意：本版本为了保持主程序体积大小，将不再内置android.jar。如需使用混合开发，请自行添加android.jar到LuaStudio+的环境文件夹中（老用户若未清空环境文件夹不受影响）。

LuaStudio+ 环境文件夹路径：
../LuaStudio_Pro/.environment
  
LuaStudio+ 启动速度 (测试设备: nova6 SE)
-关闭主页模式启动至完全加载所需时间: 
3.95s -> 2.28s (2022-07-22)

-开启主页模式启动至完全加载所需时间: 
3.00s -> 1.30s (2023-07-22)

-开启主页模式启动至进入编辑器完全加载所需时间: 
5.25s -> 5.98s (2022-07-22)

2023-07-25
-[优化]完善混合工程打包。
-[新增]APK模板新增android:roundIcon属性。

2023-07-24
-[优化]重写混合工程打包模块。

2023-07-23
-[优化]重写常规工程打包模块。

2023-07-22
-[新增]新增内置快捷编辑器。
-[新增]新增ApkSigner (V1 + V2 + V3 + V4) 签名，暂时不支持自定义密钥。
-[新增]支持在外部选择文件直接打开LuaStudio+内置快捷编辑器。
-[修复]修复快捷操作栏新建文件已知问题。
-[修复]组件列表可以直接进入带参数的页面。

2023-07-21
-[修复]修复全局搜索已知的问题。
-[修复]修复布局助手对话框颜色异常的问题。
-[优化]优化LuaStudio基础主题。
-[新增]新增Dex查看器。
-[新增]接入Android OAID。
-[新增]新增开源许可查看。
-[新增]新增红、粉、紫等19款默认主题。

2023-07-20
-[修复]修复在工程内打开其他工程目录时没有回到已打开的工程目录然后退出程序后重新进入程序会出现目录错乱的问题。
-[修复]修复相同路径的文件被qq误识别成相同文件的问题。
-[修复]修复直接进入编辑器已知问题。
-[修复]恢复主页关闭开关。
-[新增]新增文章发布页支持插入图片、插入常用语句。
-[新增]新增SoraEditor getTextActionWindow()方法。

2023-07-19
-[新增]新增 Markwon Library。
-[新增]新增文章发布页支持预览。
-[优化]使用BottomNavigationView作为主页新底栏。

2023-07-17
-[修复]修复教程手册无法打开的问题。
-[修复]修复Logcat潜在问题。
-[新增]新增主页文章发布页。
-[新增]新增主页工程列表搜索功能。
-[新增]新增主页左上角头像显示。
-[新增]新增文件列表长按图片可直接上传到公用云 (共5T容量 需登录)。
-[新增]新增文件列表长按文件夹可以直接批量格式化 (目前仅支持Lua)。
-[新增]更新字符串资源。

2023-07-16
-[修复]修复检查错误时无法自动跳转到错误行的问题。
-[修复]修复布局助手 ImageView src 无法修改的问题。
-[修复]修复Flyme (Android 10+) 无法分享文件的问题。
-[修复]恢复运行文件时对内容语法进行检测。
-[修复]修复检查语法错误时不定位错误位置的问题。
-[修复]修复工程属性无法进入。
-[修复]修复Webdav设置问题。
-[优化]优化SoraEditor代码对齐方法。
-[新增]新增导入分析支持分析androidx控件/库。
-[新增]新增文件列表打开文件新增非编译判断 (阻止编译的文件被打开)。
-[新增]新增文件列表支持直接分享文件。
-[新增]新增符号栏“'”。

2023-06-09
-[修复]修复进入编辑器时报错的问题。
-[修复]恢复自动记录编辑器光标位置。
-[修复]修复无法关闭单一标签的问题。
-[修复]修复打开图片时报错问题。

2023-06-05
-优化文件列表加载逻辑。
-优化工程列表加载逻辑。
-优化批量删除。
-统一全局对话框样式。
-重写重命名方法。
-重写代码查错方法。
-新增高性能实时查错方法 (仅支持SoraEditor)。
-新增编辑器多标签页。
-新增编辑器选择语言功能 (仅支持SoraEditor)。
-修复部分已知问题。

2023-03-30
-[Editor]优化符号栏智能插入。
-[Editor]代码行快捷操作指令适配SoraEditor。

2023-01-31
-更新快捷代码。
-重写基础对话框。
-重写插入快捷代码对话框。

2023-01-26
-修复图标仓库标题未能正常显示的问题。
-修复部分情况下无法解压程序的问题。
-修复未同意用户协议后重新进入协议跳过检测用户协议的问题。
-图标仓库支持英文显示。

2022-11-12
-修复存储权限被系统拒绝后无法启动的问题。
-修复onVersionChanged函数。
-修复右侧滑项目不显示的问题。
-修复工程操作对话框读取工程信息的错误问题。
-修复WebDav已知问题。
-修复主页已知问题。
-优化LuaStudio+工程结构。

2022-11-05
-新增popupMenu代替原有侧滑栏功能菜单的方案。
-修复主页工程列表已知问题。
-自动过滤缺失main.lua的工程。
-优化右侧滑栏从文件列表切换工程列表加载速度。
-支持打开历史打开目录。

2022-10-31
-修复部分已知问题。
-优化编辑器。

2022-10-16
-修复部分已知问题。
-工程属性支持对Xml配置文件应用包名、应用版本、应用版本号进行修改。

2022-10-07
-修复LogCat已知问题。
-新增图标仓库。
-修复Alp文件导入后构建工程配置文件导致导入后unknown问题。

2022-08-29
-去除安卓13请求授权/Android/data分区对话框。
-修复主页列表已知问题。
-修复public_library已知问题。
-修复混合工程已知问题。
-新增Java独立文件编译、Jar2Dex、Java目录编译。

2022-08-28
-修复混合工程Java无法编译问题。
-修复WebDav已知问题。
-修复文件选择器潜在问题。
-修复跟随系统主题与手动设置冲突问题。
-修复登录界面编辑框不跟随主题变色问题。
-新增编辑器WebDav入口。
-新增主页作为可选功能。
-新增工程恢复时间显示。
-优化应用启动速度。

2022-08-19
-修复已知问题。

2022-08-14
-修复跟随系统主题已知问题。
-修复LuaAppActivity已知问题。
-优化应用启动速度。

2022-08-13
-引入Sora-Editor。

2022-08-11
-修复文件选择模块已知问题。
-修复LuaThread、LuaAsyncTask在LuaAppCompatActivity内无法设置变量activity值界面context的问题。

2022-08-08
-修复工程列表搜索已知问题。
-修复跨工程打开文件已知问题。
-新增工程恢复列表删除功能。
-支持文件搜索。

2022-08-05
-新增自动打开上次打开文件（仅支持自动打开工程内文件）。
-新增编辑器一键返回顶部功能。
-新增内置 Material Components 主题配色。
-修复 LuaAppCompatActivity 闪退问题。
-修复文件列表已知问题。

2022-08-03
-更新公用库(extended_dir/lua)。
-修复混合工程打包问题。

2022-07-22
-修复添加文件按钮无事件问题。
-修复文件选择模块已知问题。
-优化使用流畅度。

2022-07-14
-文件列表与工程列表合并，一气呵成。
-新增PhotoView控件。
-新增apk模板 (LuaStudioDemo 1.0) ，打包后应用将与LuaStudio+特性相同。
-新增属性编辑模块对xml配置文件权限编辑支持。
-更新apk模板 (AndroLua+ 5.0.20)。
-修复工程打包后apk版本固定1.0问题。
-修复编辑器打开侧滑后下层主布局触摸响应问题。
-优化编辑器加载速度。
-优化打包模块闪退问题。

2022-06-18
-(import模块) 支持导入extend目录下lua文件夹文件。
-(打包模块) 支持LuaJava混合打包。
-修复文件标签栏已知问题。
-优化主页工程列表。
-更换打包签名密钥。

2022-06-11
-新增账号系统。
-新增快捷操作栏。
-修复编辑器保存文件已知问题。
-优化主页工程列表。

2022-05-14
-修复文件标签栏已知问题。
-优化部分界面问题。

2022-05-02
-修复文件列表已知问题。
-修复主页底栏已知问题。
-修复文件选择模块已知问题。
-新增WebDav云端存储。

2022-04-30
-修复部分已知问题。
-优化编辑器流畅度。

2022-04-22
-新增长按代码快捷操作按钮执行上次操作。
-新增实时检查错误功能。
-修复部分已知问题。
-优化主页工程列表。
-优化编辑器代码快捷操作栏。

2022-04-15
-新增IDE内部字体强制大小功能。
-修复布局助手已知问题。
-修复MyEditor已知问题。
-修复文件列表在指定情况下显示异常。
-修复在第三方应用导入工程不重新加载列表问题。
-修复工程属性已知问题。
-优化文件选择模块。
-优化控制面板。
-优化主题配色。

2022-04-09
-新增编辑器独立窗口模式。
-修复文件选择模块已知问题。
-修复loadlayout已知问题。
-修复自定义设置已知问题。
-修复部分已知问题。
-文件选择模块支持访问/Android/data目录。
-支持从第三方应用直接导入工程文件。

2022-04-04
-修复文件批量删除问题。
-修复部分已知问题。

2022-04-03
-修复编辑器右侧滑栏搜索工程问题。
-修复符号栏与快捷按钮高度不一问题。
-修复代码联想问题。
-修复loadlayout模块已知问题。
-修复自定义设置已知问题。
-修复在指定情况下返回主页异常问题。
-修复文件标签栏已知问题。
-修复主页安装包列表问题。
-修复主页工程列表已知问题。
-新增 MODIFY_AUDIO_SETTINGS 权限。
-新增工程属性编辑功能。
-新增全局搜索功能。
-支持编辑器侧滑滑动。

2022-03-26
-新增文件标签栏。
-新增历史打开文件信息记录功能。
-优化编辑器代码。

2022-03-12
-修复部分对话框已知问题。
-修复手册搜索问题。
-新增选中文本后点击符号栏上 " ' ( ) [ ] { } 按钮自动填充选中文本功能。
-新增控制面板。
-新增自动进入工程二级目录功能。
-新增编辑器复制行、剪切行、删除行等快捷功能。
-优化部分功能函数。

2022-03-06
-修复文件夹无法删除问题。
-修复工程列表问题。
-优化部分功能函数。

2022-02-27
-修复已知问题。

2022-02-20
-修复打包工程lua文件夹无法打包子目录问题。
-修复选择文件问题。
-新增lua文件夹加密。

2022-02-08
-新增重命名功能。
-新增导入修复功能。
-新增工程历史记录功能。
-新增代码导航功能。
-新增Lua教程手册。
-修复编辑器右侧滑已知问题。
-修复部分文件无法打开问题。

2022-02-07
-新增插入代码功能。
-新增导入资源功能。
-新增文件编译功能。
-新增编辑器给予主界面响应功能。
-新增编辑器里快捷新建工程功能。
-新增工程列表搜索包名功能。
-新增主页搜索框在特定场景自动收起功能。
-重写工程信息读取功能，兼容远古版本工程。
-修复打包工程已知问题。
-修复工程操作栏无法加载问题。
-修复编辑器工程列表无法操作问题。
-修复工程恢复搜索备份文件问题。
-修复夜间状态栏不显示问题。
-修复在编辑器内打开夜间模式返回主页问题。
-修复在编辑器内无法打开搜索栏问题。
-修复在编辑器内右侧滑标题显示问题。
-修复LogCat已知问题。

2022-02-06
-新增工程导入功能。
-新增工程修复功能。
-新增文件删除功能。
-修复打包模块已知问题。
-修复语言库已知问题。
-更新androlua_lite模板（AndroLua+ 5.0.18）。
-更新androlua_lite X5版模板（AndroLua+ 5.0.18）。
-更新lua公用库（LuaStudio+ 2.0）。
-支持androlua备份文件(.alp)导入。

2022-02-05
-新增DataLibrary（dingyi）。
-重写工程打包模块部分用法。
-修复打包dex库文件用法已知问题。
-修改build information保存方式。

2022-02-04
-新增getEnvironmentDir()函数。
-新增编辑器搜索代码功能。
-新增编辑器跳转行数功能。
-新增编辑器取色器功能。
-新增编辑器配色参考文档。
-新增编辑器Lua文档。
-新增编辑器Java Api浏览器。
-新增常规恢复/误删恢复功能。
-新增对新建文件/文件夹名限制，将仅支持创建文件/文件夹名为26个字母大小写、数字和“_”组成的文件名。
-新增QKEditor（云歌）。
-新增MyEditor。
-新增Glide控件，并引入loadlayout中。
-修复公用顶栏部分已知问题。
-修复新建文件报错问题。
-修复安卓7.0以上intent类操作报错问题。
-修复编辑页面操作栏取消按钮点击事件失效问题。

2022-02-02
-修复新建文件项目不显示问题。
-修复编辑界面打开侧滑后editor焦点丢失问题。
-公用顶栏模块新增搜索按钮。
-新增主页工程搜索功能。
-新增启动自动进入工程编辑界面功能。
-更新build info存储方式（Lua Table）。
-更新Java层：
 -task支持最大8196个线程，同步执行1024（5.0.17）。

2022-01-16
-提升系统语言库的兼容性。
-恢复对32位设备的支持。

2022-01-03
-提升系统字体库、系统图标库的兼容性。
-新增注册/登录界面。

LuaStudio Pro 2022
2021-12-31
-跨年版本，完成对基础功能的支持。

LuaStudio Pro 2021
-所有界面重写。
-支持搜索设置大小写敏感。
-支持关闭返回提示。

LuaStudio 2020
0.0.1
-重置版本号。
-使用java混合开发模式。
-软件正式更名为LuaStudio。]]
log_en=[[Special note: In order to maintain the size of the main program, Android. jar will no longer be built-in in this version. If you need to use mixed development, please add android.jar to the environment folder of LuaStudio+yourself (old users will not be affected if the environment folder is not cleared).
LuaStudio+ environment folder path:
../LuaStudio_Pro/. environment
  
LuaStudio+ startup speed (test equipment: nova6 SE)
Time required to turn off home mode boot to full load: 3.95s
Time required to boot to full load from home mode on: 3.00s
Time required to boot into home mode until the editor is fully loaded: 5.25s

July 21, 2023
-[Fix] Fix known issues with global search.
-[Fix] Fixed the issue of abnormal color in the layout assistant dialog box.
-[Optimization] Optimize the basic theme of LuaStudio.
-[New] Connect to Android OAID.
-[New] New open source license view.
-[New] Add 19 default themes such as red, pink, and purple.

July 20th, 2023
-[Repair] Fixed the issue of directory confusion when opening other project directories within a project without returning to the already opened project directory and then exiting the program and re-entering the program.
-[Fix] Fixed the issue of files with the same path being mistakenly recognized by QQ as the same file.
-[Fix] Fix a known issue by directly entering the editor.
-[Repair] Restore the home page shutdown switch.
-[New] The new article publishing page supports inserting images and common sentences.
-[New] Added the SoraEditor getTextActionWindow() method.

July 19, 2023
-[New] Add Markwon Library.
-[New] New article release page supports preview.
-[Optimization] Use BottomNavigationView as the new bottom bar on the homepage.

July 17, 2023
-[Fix] Fix the issue where the tutorial manual cannot be opened.
-[Fix] Fix potential issues with Logcat.
-[New] Add a new homepage article publishing page.
-[New] New homepage project list search function added.
-[New] Add a avatar display in the upper left corner of the homepage.
-[Add] The new file list can be directly uploaded to the Public cloud by long pressing the picture (a total of 5T capacity needs to be logged in).
-[New] Adding a new file list allows for direct batch formatting by long pressing on a folder (currently only Lua is supported).
-[New] Update string resources.

July 16, 2023
-[Fix] Fixed the issue of not being able to automatically jump to the wrong line when checking for errors.
-[Fix] Fixed an issue where the layout assistant ImageView src cannot be modified.
-[Fix] Fixed the issue of Flyme (Android 10+) not being able to share files.
-[Fix] Detect content syntax when restoring running files.
-[Repair] Fix the problem of not locating the wrong location when checking for Syntax error.
-[Repair] The repair project attribute cannot be accessed.
-[Fix] Fix Webdav settings issue.
-[Optimization] Optimize the SoraEditor code alignment method.
-[New] Added import analysis support for analyzing Android controls/libraries.
-[Add] Add a new file list to open a file and add a non compiled judgment (preventing compiled files from being opened).
-[New] New file list supports direct file sharing.
-[Add] Add a symbol column "'".

June 9, 2023
-[Fix] Fixed the issue of errors when entering the editor.
-[Repair] Restores the automatic recording editor cursor position.
-[Fix] Fixed the issue of not being able to close a single label.
-[Repair] Fixed an error when opening an image.

June 5th, 2023
-Optimize the file list loading logic.
-Optimize the loading logic of the project list.
-Optimize batch deletion.
-Unified global dialog box style.
-Rewrite the rename method.
-Rewrite code error detection methods.
-New enhanced real-time error detection method (only SoraEditor is supported).
-Add multiple tabs for the editor.
-Added language selection function for editor (only SoraEditor is supported).
-Fix some known issues.

March 30, 2023
-[Editor] Optimize symbol bar intelligent insertion.
-[Editor] Code line shortcut operation instructions are adapted to SoraEditor.

January 31, 2023
-Update shortcut code.
-Rewrite the basic dialog box.
-Rewrite the Insert Shortcut Code dialog box.

January 26, 2023
-Fix the issue of icon warehouse titles not displaying properly.
-Fixed some cases where the program could not be decompressed.
-Fix the issue of skipping the detection of user agreements after re-entering the protocol without agreeing to the user agreement.
-The icon warehouse supports English display.

2022-11-12
- Fixed the issue that storage permission could not be started after being denied by the system.
- Fixed the onVersionChanged function.
- Fixed the issue that the right sliding item was not displayed.
- Fixed the wrong issue where the project operation dialog read project information.
- Fixed WebDav known issues.
- Fixed homepage known issues.
- Optimized LuaStudio+ engineering structure.

2022-11-05
- Added popupMenu to replace the original sideslide bar function menu.
- Fixed a known issue with the homepage project list.
- Automatically filter projects that are missing main.lua.
- Optimized the loading speed of the project list toggle from the file list in the right slider.
- Support opening history to open catalogs.

2022-10-31
- Fixed some known issues.
- Optimized editor.

2022-10-16
- Fixed some known issues.
- Engineering properties support modifying the application package name, application version, and application version number of the XML configuration file.

2022-10-07
- Fixed LogCat known issues.
- Added icon repository.
- Fixed the issue that building the project configuration file after importing Alp file caused by unknown after import.

2022-08-29
- Remove Android 13 request authorization/Android/data partition dialog.
- Fixed homepage list known issue.
- Fixed public_library known issues.
- Fixed mixed engineering known issues.
- Added Java standalone file compilation, Jar2Dex, Java directory compilation.

2022-08-28
- Fixed hybrid engineering Java failed to compile issue.
- Fixed WebDav known issues.
- Fixed file picker potential issues.
- Fixed the issue where following system themes conflicts with manual settings.
- Fixed the issue that the editing box on the login interface did not change color according to the theme.
- Added editor WebDav entry.
- Added homepage as an optional feature.
- Added project recovery time display.
- Optimize app startup speed.

2022-08-19
- Fixed known issues.

2022-08-14
- Fixed following system themes known issues.
- Fixed LuaAppActivity known issues.
- Optimized app startup speed.

2022-08-13
- Introduction of Sora-Editor.

2022-08-11
- Fixed file selection module known issue.
- Fixed the issue that LuaThread and LuaAsyncTask could not set the variable activity value interface context in LuaAppCompatActivity.

2022-08-29
- Fixed public_library known issues.

2022-08-28
- Fixed the issue that mixed project Java could not compile.
- Fixed WebDav known issues.
- Fixed potential problems with file pickers.
- Fixed the issue where following system themes conflicted with manual settings.
- Fixed the issue that the edit box of the login interface did not change color according to the theme.
- Added editor WebDav entry.
- Added home page as an optional feature.
- Added project recovery time display.
- Optimized app launch speed.

2022-08-19
- Fixed known issues.

2022-08-14
-Fixed known issues with following system themes.
-Fixed LuaAppActivity known issues.
-Optimize application startup speed.

2022-08-13
-Introduced Sora-Editor.

2022-08-11
-Fixed file selection module known issues.
-Fixed the problem that LuaThread and LuaAsyncTask cannot set the variable activity value interface context in LuaAppCompatActivity.

2022-08-08
-Fixed known issues with project list search.
-Fixed known issues with opening files across projects.
-Added the function of deleting the project recovery list.
-Support file search.

2022-08-05
-Added automatic opening of the last opened file (only supports automatic opening of files in the project).
-Added the function of returning to the top with one click of the editor.
-Added built-in Material Components theme colors.
-Fixed the crash issue of LuaAppCompatActivity.
-Fixed file list known issues.

2022-08-03
-Update common library (extended_dir/lua).
-Fixed mixed project packaging issue.

2022-07-22
-Fix the problem of no event for add file button.
-Fix file selection module known issues.
-Optimize usage fluency.

2022-07-14
-The file list is merged with the project list in one go.
-Added PhotoView control.
-Added apk template (LuaStudioDemo 1.0), the packaged application will have the same features as LuaStudio+.
-Added attribute editing module to support xml configuration file permission editing.
-Updated apk template (AndroLua+ 5.0.20).
-Fixed the issue that the apk version was fixed 1.0 after the project was packaged.
-Fixed the touch response problem of the lower main layout after the editor opened the slide.
-Optimize editor loading speed.
-Optimized the flashback problem of the packaging module.

2022-06-18
-(import module) Supports importing lua folder files in the extend directory.
-(Packaging module) Supports LuaJava hybrid packaging.
-Fixed known issues with file tab bar.
-Optimized the homepage project list.
-Replace the package signing key.

2022-06-11
-Added account system.
-Added shortcut operation bar.
-Fixed known issues with editor saving files.
-Optimized the homepage project list.

2022-05-14
-Fixed known issues with the file tab bar.
-Optimized some interface issues.

2022-05-02
-Fixed file list known issues.
-Fixed known issues with the bottom bar of the home page.
-Fixed file selection module known issues.
-Added WebDav cloud storage.

2022-04-30
-Fixed some known issues.
-Optimized editor fluency.

2022-04-22
-Added Long press the code shortcut operation button to perform the last operation.
-Added real-time error checking function.
-Fixed some known issues.
-Optimized the homepage project list.
-Optimized the editor code shortcut action bar.

2022-04-15
-Added IDE internal font force size function.
-Fixed layout assistant known issues.
-Fixed MyEditor known issues.
-Fixed file list display abnormally under specified conditions.
-Fixed the issue that importing a project in a third-party application would not reload the list.
-Fixed known issues with project properties.
-Optimized file selection module.
-Optimized the control panel.
-Optimized the theme color.

2022-04-09
-Added editor independent window mode.
-Fixed file selection module known issues.
-Fixed known issues with loadlayout module.
-Fixed custom settings known issues.
-Fixed some known issues.
-The file selection module supports accessing the /Android/data directory.
-Support direct import of project files from third-party applications.

2022-04-04
-Fixed the issue of batch deletion of files.
-Fixed some known issues.

2022-04-03
-Fixed the problem of searching for projects in the slider on the right side of the editor.
-Fixed the problem that the heights of the symbol bar and shortcut buttons are different.
-Fixed code association issue.
-Fixed known issues with loadlayout module.
-Fixed custom settings known issues.
-Fixed the abnormal problem of returning to the home page under specified conditions.
-Fixed known issues with the file tab bar.
-Fixed homepage installation package list issue.
-Fixed known issues with homepage project list.
-Added MODIFY_AUDIO_SETTINGS permission.
-Added project property editing function.
-Added global search function.
-Support editor side slide sliding.

2022-03-26
-Added a file tab.
-Added the function of opening file information record.
-Optimized editor.

2022-03-12
-Fixed some dialog known issues.
-Fixed manual search issue.
-Added the function of automatically filling the selected text by clicking the " ' ( ) button on the symbol bar after selecting the text.
-Added a control panel.
-Added the function of automatically entering the secondary directory of the project.
-Added editor shortcut functions such as copy line, cut line, delete line, etc.
-Optimized some functions.

2022-03-06
-Fixed the problem that the folder could not be deleted.
-Fixed project list issue.
-Optimized some functions.

2022-02-27
-Fixed known issues.

2022-02-20
-Fixed the problem that the packaged project lua folder cannot package subdirectories.
-Fixed file selection issue.
-Added lua folder encryption.

2022-02-08
-Added code navigation feature.
-Added Lua tutorial manual.
-Fixed a known bug in the right slide of the editor.
-Fixed the problem that some files could not be opened.

2022-02-07
-Added insert code function.
-Added the function of importing resources.
-Added file compilation function.
-Added the editor to give the main interface responsive function.
-Added the function of quickly creating a new project in the editor.
-Added project list search package name function.
-Added the function of automatically closing the home page search box in certain scenarios.
-Rewrite the project information reading function, compatible with ancient version projects.
-Fixed known issues in packaging engineering.
-Fixed the problem that the project operation bar could not be loaded.
-Fixed the problem that the editor project list cannot be operated.
-Fixed the problem of searching for backup files in project recovery.
-Fixed the problem that the status bar does not display at night.
-Fixed the issue of returning to the homepage with night mode turned on in the editor.
-Fixed an issue where the search bar could not be opened in the editor.
-Fixed the display problem of the title sliding on the right side in the editor.
-Fixed known issues with LogCat.

2022-02-06
-Added project import function.
-Added engineering repair function.
-Added file delete function.
-Fixed known issues with packaging modules.
-Fixed known issues with the language library.
-Updated androlua_lite template (AndroLua+ 5.0.18).
-Updated androlua_lite template for X5 version (AndroLua+ 5.0.18).
-Update the lua common library (LuaStudio+ 2.0).
-Support the androlua backup(.alp) file import.

2022-02-05
-Added DataLibrary (dingyi).
-Rewritten some usage of project packaging module.
-Fixed known issues in the usage of packaged dex library files.
-Modify the save method of build information.

2022-02-04
-Added getEnvironmentDir() function.
-Added editor search function.
-Added the function of jumping lines in the editor.
-Added editor color picker function.
-Added editor color matching reference documentation.
-Added editor Lua documentation.
-Added editor Java Api browser.
-Added general recovery/accidental deletion recovery function.
-Added a new file/folder name restriction, which will only support the creation of file/folder names with 26 letter case, numbers and "_".
-Added LuaEditorX View (Aluaj).
-Added QKEditor View (cloud song).
-Added MyEditor View.
-Added Glide control and introduced it into loadlayout.
-Fixed some known issues in the public header.
-Fixed the problem of creating a new file error.
-Fixed the problem of error reporting of intent class operations above Android 7.0.
-Fixed the issue that the click event of the cancel button in the edit page action bar is invalid.


2022-02-02
-Fixed the problem that the new file item does not display.
-Fixed the issue that editor focus was lost after DrawerLayout was opened in the editing interface.
-A new search button has been added to the public top bar module.
-Added homepage project search function.
-Added the function of automatically entering the project editing interface when starting.
-Update build info storage method(Lua Table).
-Update the Java layer：
 -The task supports a maximum of 8196 threads, and 1024 are executed synchronously (5.0.17).

2022-01-16
-Improve the compatibility of the system language library.
-Restore support for 32-bit devices.

2022-01-03
-Improve the compatibility of system font library and system icon library.
-Added registration/login interface.

LuaStudio Pro 2022
2021-12-31
-The new year version completes the support for basic functions.

LuaStudio Pro 2021
-All interface rewrites.
-Support search setting case sensitive.
-Support closing return prompt.]]



--主程序更新日志
update_log_zh=[[
版本：
%s(%s)

AndroLua+ 版本:
%s(%s)

开发者：
Azure

软件介绍:
LuaStudio是轻函系列的一款编程开发应用。

<注: qq、微信捐赠码会自动保存至手机存储根目录。>

更新内容:
%s]]
update_log_en=[[
Version:
%s(%s)

AndroLua+ Version:
%s(%s)

Developer:
Azure

Software introduction:
Luastudio is a programming development application of Qingset series.

<Note: QQ and WeChat donation codes will be automatically saved to the phone storage root directory.>

Update log:
%s]]
update_log_zh=string.format(update_log_zh,ver,code,activity.getAndroLuaVersion(),activity.getAndroLuaVersionCode(),log_zh)
update_log_en=string.format(update_log_en,ver,code,activity.getAndroLuaVersion(),activity.getAndroLuaVersionCode(),log_en)

local now_language=Locale.getDefault().getLanguage();
if now_language=="zh" then
  update_content=update_log_zh
 else
  update_content=update_log_en
end

--[[
adb pair 192.168.68.240:39217
adb connect 192.168.68.240:39195
adb shell am start -W com.luastudio.azure/.MainActivity
adb shell am start -W com.luastudio.azure/.LuaMainActivity
]]