require "imports"
bin_settings=config["bin_moudle"]["settings"]
import "system_incident"
load_common_components()
import "mods.build_funlib"
proj_path,java_dir_path,compiler_mode=...
local paths=build_funlib.set_java_compiler_paths(proj_path,java_dir_path)
local compiler_jar_path=paths["jar_path"].."/compiler.jar"

drawer_item_checked_background = GradientDrawable().setShape(GradientDrawable.RECTANGLE).setColor(parseColor(basic_color)-0xde000000).setCornerRadii({dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5),dp2px(5)});

drawer_item=import "layout.layout_bin_item"
app_title="Java 编译"
activity.setTitle(app_title)
activity.setContentView(loadlayout("layout.layout_main"))
main_title_id.setText(app_title)

--返回按钮
back_button.setVisibility(0)
binlog_background_id.setVisibility(0)
menu_img.setVisibility(8)
more_button.setVisibility(8)
--mode_background.setVisibility(8)
info_background.setVisibility(8)
sw_background.setVisibility(8)
adp=LuaMultiAdapter(activity,drawer_item)
main_lv.setAdapter(adp)

ch_table={
  {"Java 编译","bug_report"},
  {"Jar2Dex","build"},
  --{gets("settings"),"settings"},
  --{gets("exit"),"exit"},
};

main_lv.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    local s=v.Tag.tv.Text
    if s=="Java 编译" then
      LuaUtil.rmDir(File(paths["build_bin_path"]))
      if compiler_mode and compiler_mode=="java_file" then
        activity.newTask(javafile_compile, update, callback).execute({proj_path,java_dir_path})
       else
        activity.newTask(javadir_compile, update, callback).execute({proj_path,java_dir_path})
      end
    end
    if s=="Jar2Dex" then
      if compiler_jar_path and File(compiler_jar_path).exists() then
        if not File(paths["lualibs_path"]).exists() then
          File(paths["lualibs_path"]).mkdirs()
        end
        local save_dex_name=File(compiler_jar_path).name
        local compiler_dex_path=paths["lualibs_path"].."/"..save_dex_name..".dex"
        if File(compiler_dex_path).exists() then
          File(compiler_dex_path).renameTo(File(compiler_dex_path..".lsbak"))
        end
        activity.newTask(jar2dex, update, callback).execute({compiler_jar_path,compiler_dex_path})
      end
    end
  end
})


--侧滑列表高亮项目函数
drawer_item_light(adp,ch_table,"bug_report")

import "android.content.res.ColorStateList"
--system_ripple({menu_buton,back_button,menu_button},"circular_theme")
ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0, 0)
ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0, 0)
back_button.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))


function update(content,code)
  if build_apk_status then
    build_apk_status='=>'..content.."\n"..build_apk_status
   else
    build_apk_status=content
  end
  build_apk_log.setText(build_apk_status)
end

function callback(s)
  LuaUtil.rmDir(File(paths["build_bin_path"]))
  if s then
    if type(s)=="string" then
      build_apk_log.setText(s.."\n\n"..build_apk_log.text)
    end
  end
end

function jar2dex(jar_path,dex_path)
  require "import"
  import "android.os.Environment"
  import "java.io.*"
  import "java.io.PrintWriter"
  import "java.io.ByteArrayOutputStream"
  import "java.util.ArrayList"
  import "com.duy.dx.command.dexer.Main"
  --import "com.mythoi.developerApp.build.DexUtil"
  this.update("Jar2Dex...");
  this.update("Jar: "..jar_path);
  this.update("Dex: "..dex_path);
  local array2 = ArrayList();
  array2.add("--verbose");
  array2.add("--no-strict");
  array2.add("--no-files");
  array2.add("--output="..dex_path);
  --array2.add("--num-threads=12");
  array2.add(jar_path);
  local command2=array2.toArray(String[array2.size()]);
  local result = Main.main(command2);
  this.update("Status:"..result)
  if result==0 then
    this.update("Jar转Dex成功："..dex_path)
  end
end

function javadir_compile(proj_path,java_dir_path)
  require "import"
  import "android.os.Environment"
  import "java.io.*"
  import "java.io.PrintWriter"
  import "java.io.ByteArrayOutputStream"
  import "java.util.ArrayList"
  import "mods.build_funlib"
  import "config"
  local errorStream = ByteArrayOutputStream() -- 编译信息
  local environment_root_path = config["general"]["paths"]["environment_root_path"]
  local android_jar_path = environment_root_path.."/res/android.jar"
  this.update("待编译目录："..java_dir_path)
  local function build_java(proj_path,java_dir_path)
    local paths=build_funlib.set_java_compiler_paths(proj_path,java_dir_path)
    error_info=StringBuffer()

    this.update("正在编译Java...")
    this.update("输出目录："..paths["class_path"])
    local function addJavaFile(dir,t)
      local list=File(dir).listFiles()
      for i=0,#list-1 do
        local v=list[i]
        if v.isDirectory() then
          addJavaFile(v.path,t)
         elseif v.isFile() and tostring(v.name):find("%.java$") then
          t[#t+1]=v.path
        end
      end
    end
    local commands = {
      --"-extdirs",proj_path.."/libs/jar"..":"..proj_path.."/libs/jar" , -- jarsPath
      "-bootclasspath", android_jar_path,

      --"-classpath", paths["gen_path"]..":"..paths["java_path"],
      "-proc:none",
      "-target","1.8",
      "-source","1.8",
      "-d",paths["class_path"],
    }

    addJavaFile(paths["java_path"],commands)
    import "com.sun.tools.javac.Main"

    local result = Main.compile(commands,PrintWriter(errorStream))
    local message = errorStream.toString()
    errorStream.close()
    this.update("Status:"..result)
    if result==0 then
      LuaUtil.zip(paths["class_path"],paths["jar_path"],"/compiler.jar")
      this.update("编译成功："..paths["jar_path"].."/compiler.jar")
     elseif result==1 then
      this.update(message)
      error_info.append(message)--io.open(activity.getLuaExtDir().."/cache/log/error.txt"))
    end
    return error_info
  end
  local status, err = pcall(build_java,proj_path,java_dir_path)
  if not status then
    error_info.append(err)
  end
  if error_info.toString()~="" then
    return "Java编译出错："..error_info.toString()
  end
end

function javafile_compile(proj_path,java_file_path)
  require "import"
  import "android.os.Environment"
  import "java.io.*"
  import "java.io.PrintWriter"
  import "java.io.ByteArrayOutputStream"
  import "java.util.ArrayList"
  import "mods.build_funlib"
  import "config"
  local errorStream = ByteArrayOutputStream() -- 编译信息
  local environment_root_path = config["general"]["paths"]["environment_root_path"]
  local android_jar_path = environment_root_path.."/res/android.jar"
  this.update("待编译文件："..java_file_path)
  local function build_java(proj_path,java_file_path)
    local paths=build_funlib.set_java_compiler_paths(proj_path,java_file_path)
    error_info=StringBuffer()

    this.update("正在编译Java...")
    --this.update("输出目录："..paths["class_path"])
    local function addJavaFile(path,t)
      local v=File(path)
      if v.isFile() and tostring(v.name):find("%.java$") then
        t[#t+1]=v.path
      end
    end
    local commands = {
      --"-extdirs",proj_path.."/libs/jar"..":"..proj_path.."/libs/jar" , -- jarsPath
      "-bootclasspath", android_jar_path,
      --"-classpath", paths["gen_path"]..":"..paths["java_path"],
      "-proc:none",
      "-target","1.8",
      "-source","1.8",
      "-d",paths["class_path"],
    }
    function jar2dex(jar_path,dex_path)
      require "import"
      import "android.os.Environment"
      import "java.io.*"
      import "java.io.PrintWriter"
      import "java.io.ByteArrayOutputStream"
      import "java.util.ArrayList"
      import "com.duy.dx.command.dexer.Main"
      --import "com.mythoi.developerApp.build.DexUtil"
      this.update("Jar2Dex...");
      this.update("Jar: "..jar_path);
      this.update("Dex: "..dex_path);
      local array2 = ArrayList();
      array2.add("--verbose");
      array2.add("--no-strict");
      array2.add("--no-files");
      array2.add("--output="..dex_path);
      --array2.add("--num-threads=12");
      array2.add(jar_path);
      local command2=array2.toArray(String[array2.size()]);
      local result = Main.main(command2);
      this.update("Status:"..result)
      if result==0 then
        this.update("Jar转Dex成功："..dex_path)
      end
    end

    addJavaFile(java_file_path,commands)
    import "com.sun.tools.javac.Main"

    local result = Main.compile(commands,PrintWriter(errorStream))
    local message = errorStream.toString()
    errorStream.close()
    this.update("Status:"..result)
    if result==0 then
      local tmp_file=paths["jar_path"].."/tmp.jar"
      LuaUtil.zip(paths["class_path"],paths["jar_path"],"/tmp.jar")

      jar2dex(tmp_file,java_file_path..".dex")
      LuaUtil.rmDir(File(tmp_file))

      --this.update("编译成功："..paths["jar_path"].."/tmp.jar")
     elseif result==1 then
      this.update(message)
      error_info.append(message)--io.open(activity.getLuaExtDir().."/cache/log/error.txt"))
    end
    return error_info
  end
  local status, err = pcall(build_java,proj_path,java_file_path)
  if not status then
    error_info.append(err)
  end
  if error_info.toString()~="" then
    return "Java编译出错："..error_info.toString()
  end
end

if compiler_mode and compiler_mode=="java_file" then
  activity.newTask(javafile_compile, update, callback).execute({proj_path,java_dir_path})
 else
  activity.newTask(javadir_compile, update, callback).execute({proj_path,java_dir_path})
end