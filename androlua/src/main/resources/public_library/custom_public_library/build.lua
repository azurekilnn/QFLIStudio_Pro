PathManager = luajava.bindClass "com.qflistudio.azure.manager.PathManager"()
PathManager.init(activity)
paths={
  filesDir=tostring(PathManager.getLuaApplicationDir()),
}
paths.resDir=paths.filesDir.."/res"
  
filesMD5s={}
replaceFiles={}
buildSettings={}
signInfo={
  keyPassword="",
  keyAlias="",
  keyAliasPassword="",
  signatureAlgorithm="",

  keyPath=paths.resDir.."/keys/testkey.pk8",
  certPath=paths.resDir.."/keys/testkey.x509.pem"
}


build_info={
  useStartInterface=false,
}

buildRes={
  publicAaptPath=paths.resDir.."/aapt"
}
paths.environmentPath=activity.getLuaExtDir(".environment")
buildRes.androidjarPath=activity.getSharedData("android_jar_path") or paths.environmentPath.."/res/android.jar"
buildRes.defalutApkTemplatePath_2=paths.resDir.."/templates/luastudio_demo"
buildRes.defalutApkTemplatePath=paths.environmentPath.."/res/templates/luastudio_demo"


axmlReplaceInfo={}


tempRes={}

local base={}
base.setProjectPath=function(info)
  base.updateContent(gets("init_project_paths_tips"))
  local projectType=info["template"]
  local path=info["projectPath"]
  local apkName=info["apkName"]
  paths.projectPath=path
  --工程目录
  paths.appPath=paths.projectPath.."/app"
  --构建目录
  paths.buildDir=paths.projectPath.."/build"
  paths.binPath=paths.buildDir.."/bin"
  paths.libPath=paths.projectPath.."/libs"

  paths.buildJars=paths.binPath.."/jar"
  paths.buildAssets=paths.binPath.."/assets_bin"
  paths.buildLua=paths.binPath.."/lua_bin"
  paths.buildLib=paths.binPath.."/lib_bin"
  paths.buildAarRes=paths.binPath.."/aarres"
  --lua/lib存放目录
  paths.extenderDir=paths.projectPath.."/extended_dir"
  --打包配置文件目录
  paths.luaDir=paths.extenderDir.."/lua"
  paths.libDir=paths.extenderDir.."/lib"
  paths.apkDir=paths.buildDir.."/apk"

  paths.mainPath=paths.appPath.."/src/main"
  paths.resPath=paths.mainPath.."/res"
  --Lua目录
  paths.assetsPath=paths.mainPath.."/assets"
  paths.resourcesPath=paths.mainPath.."/resources"
  paths.jniLibsPath=paths.mainPath.."/jniLibs"

  paths.buildFilePath=paths.projectPath.."/build.lsinfo"
  paths.unsignedApkPath=paths.binPath.."/tmp_unsigned.apk"
 
  if apkName then
  paths.signedApkPath=paths.apkDir.."/"..apkName
  else
  paths.signedApkPath=paths.apkDir.."/signed.apk"
  end

  local creters={
    paths.buildDir,--
    paths.binPath,--
    paths.apkDir
   }

  for k,v in pairs(creters) do
    local file=File(v)
    if not file.exists() then
      file.mkdirs()
    end
  end

  if projectType and projectType=="lua_java" then
    paths.genPath=paths.buildDir.."/gen"
    paths.classesPath=paths.binPath.."/classes"
    paths.buildDex=paths.binPath.."/jar2dex"
    paths.outputDexPath=paths.binPath.."/dex"

    paths.buildTmpApk=paths.binPath.."/resources.ap_"
    paths.md5Text=paths.binPath.."/md5.txt"

    paths.configGradle=paths.appPath.."/build.gradle"

    paths.mainPath=paths.appPath.."/src/main"
    paths.javaPath=paths.mainPath.."/java"
    paths.resPath=paths.mainPath.."/res"
    paths.assetsPath=paths.mainPath.."/assets"
    paths.resourcesPath=paths.mainPath.."/resources"
    paths.jniLibsPath=paths.mainPath.."/jniLibs"

    paths.androidxmlDir=paths.buildDir.."/axml"
    paths.androidxmlpath=paths.mainPath.."/AndroidManifest.xml"
    paths.androidxmlBinPath=paths.binPath.."/AndroidManifest.xml"

    local creters={
      paths.buildJars,--
      paths.buildDir,--
      paths.classesPath,
      paths.resPath,
      paths.buildDex,
      paths.binPath,--
      paths.genPath,--
      paths.buildAarRes,--
      paths.buildAssets,--
      paths.outputDexPath,
     }

    for k,v in pairs(creters) do
      local file=File(v)
      if not file.exists() then
        file.mkdirs()
      end
    end
  end
end
--检查模板
base.checkLuaStudioTemplate=function()
  base.updateContent(gets("check_template_tips"))
  local luastudio_template_dir=tostring(activity.getFilesDir()).."/luastudio"
  local appInfo=activity.getApplicationInfo()
  base.updateContent(appInfo.publicSourceDir)
   if not File(luastudio_template_dir).exists() then
    ZipUtil.unzip(appInfo.publicSourceDir,luastudio_template_dir)
  end
end

base.copyNativelibrary=function()
  local nativelibrary_dir=tostring(File(activity.ApplicationInfo.nativeLibraryDir).getParentFile())
  local extend_path=paths.libDir

  if pcall(function()LuaUtil.copyDir(File(nativelibrary_dir),File(extend_path))end)
    local arm64_nativelibrary_dir=extend_path.."/arm64"
    local arm_nativelibrary_dir=extend_path.."/arm"

    local narm64_nativelibrary_dir=extend_path.."/arm64-v8a"
    local narm_nativelibrary_dir=extend_path.."/armeabi-v7a"

    if File(arm64_nativelibrary_dir).exists() then
      File(arm64_nativelibrary_dir).renameTo(File(narm64_nativelibrary_dir))
     elseif File(arm_nativelibrary_dir).exists() then
      File(arm_nativelibrary_dir).renameTo(File(narm_nativelibrary_dir))
    end
  end
end
--检查公用库文件
base.checkExtendedFiles=function()
  base.updateContent(gets("check_lua_public_library"))
  --解压公用库，运行库
   if not File(paths.luaDir).exists() then
    ZipUtil.unzip(tostring(PathManager.getLuaApplicationDir()).."/res/public_library_demo.jar",paths.extenderDir)
    base.updateContent(gets("unzip_to_tips")..paths.extenderDir)
  end
  if not File(paths.libDir).exists() then
    base.pcallHandler(pcall(base.copyNativelibrary))
  end
end
--初始化Aapt
base.initAapt=function()
  base.updateContent(gets("init_aapt_tips"))
  local file=File(tostring(activity.getFilesDir()).."/libc++_shared.so")
  --base.updateContent(tostring(activity.getFilesDir()).."/libc++_shared.so")
  if not file.exists() then
    LuaUtil.copyDir(File(tostring(activity.getLuaDir("res")).."/libc++_shared.so"),file)
    file.setExecutable(true)--设置可执行权限
    --base.updateContent(tostring(activity.getLuaDir("res")).."/libc++_shared.so")
  end
  --初始化aapt
  base.updateContent(buildRes.publicAaptPath)
  chmod = String {"chmod", "744", buildRes.publicAaptPath}
  local process = Runtime.getRuntime().exec(chmod);
  local code = process.waitFor()

  if code ~= 0 then
    base.updateContent(gets("init_aapt_unsuccessfully_tips"))
  else
    base.updateContent(gets("init_aapt_successfully_tips"))
  end
end
--运行
base.runShell=function(command)
--print(command.toString())
  local cmd ={"/bin/sh", "-c" , command}
  local process = Runtime.getRuntime().exec(cmd)

  local code = process.waitFor()
--print(code)
  if code ~= 0 then
    import "java.io.BufferedReader"
    import "java.io.InputStreamReader"
    local err = process.getErrorStream()
    local is = InputStreamReader(err)
    local br = BufferedReader(is)
    local line =""
    local str=""
    while line~=nil do
      str=str..line
      line=br.readLine()
    end
    return base.errorHandler(str)
  end
  return true
end
--运行
base.runShell=function(command)
  local result=String(Utils.runshell(command));
  if result.contains("ERROR:") or not result.contains("Writing all files...") or result.contains("error:") then
    if result.contains("ERROR:")then
      return base.errorHandler(result)
    end
  end
end
base.startAapt=function()
  base.updateContent(gets("start_aapt_tips"))
  
  local aaptList=ArrayList();
  aaptList.add(buildRes.publicAaptPath)
  base.updateContent(buildRes.publicAaptPath.."\t\t"..tostring(File(paths.resPath).exists()))
  aaptList.add("package")
  aaptList.add("-v");
  aaptList.add("-f");
  aaptList.add("--auto-add-overlay")
  aaptList.add("-m")

  aaptList.add("-S")
  base.updateContent(paths.resPath.."\t\t"..tostring(File(paths.resPath).exists()))
  aaptList.add(paths.resPath)
--[[for k,v in pairs(aarRessTable) do
        comm.add("-S");
        comm.add(v.path.."/res/");
      end]]
  aaptList.add("-J")
  base.updateContent(paths.genPath)
  base.updateContent(paths.genPath.."\t\t"..tostring(File(paths.genPath).exists()))
  aaptList.add(paths.genPath)

  --   "--extra-packages",aar编译包名, --aarPackagePath
  -- AndroidManifest.xml
  aaptList.add("-M")
  base.updateContent(paths.androidxmlpath.."\t\t"..tostring(File(paths.androidxmlpath).exists()))
  aaptList.add(paths.androidxmlpath)
  -- Android.jar
  aaptList.add("-I")
  base.updateContent(buildRes.androidjarPath.."\t\t"..tostring(File(buildRes.androidjarPath).exists()))
  aaptList.add(buildRes.androidjarPath)
  -- apPath
  
  aaptList.add("-F")
  aaptList.add(paths.buildTmpApk)
  
    aaptList.add("--no-version-vectors")
  local args=aaptList.toArray(String[aaptList.size()])
  base.pcallHandler(pcall(base.runShell,args))
  base.updateContent(paths.buildTmpApk)
end

base.startJavac=function()
  base.updateContent(gets("start_javac_tips"))
  import "java.io.PrintWriter"
  import "java.io.ByteArrayOutputStream"

  -- 我们直接用PrintWriter存储直接读取
  local errorStream = ByteArrayOutputStream() -- 编译信息

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
    --    "-verbose",
    "-extdirs",paths.libPath..":"..paths.buildJars , -- jarsPath
    "-bootclasspath", buildRes.androidjarPath, -- Android.jar
    -- Compile All Type Code Resource
    "-classpath", paths.genPath..":"..paths.javaPath,--..":",
    "-proc:none",
    "-target","1.8",
    "-source","1.8",
    "-d", paths.classesPath, -- classesPath
    -- mainJavaPath -- The First Running Java Path
  }

  addJavaFile(paths.javaPath,commands)
  addJavaFile(paths.genPath,commands)

  import "com.sun.tools.javac.Main"

  local result = Main.compile(commands,PrintWriter(errorStream))
  local message = errorStream.toString()
  errorStream.close()

  if result==1 then
    return base.errorHandler(message)
  end
  return LuaUtil.zip(paths.classesPath,paths.buildJars,"/main.jar")
end


base.errorHandler=function(err)
  if err~="" then
    errorBuffer.append(err)
    base.updateContent("error"..tostring(err))
    if errorBuffer.toString()~="" then
      return errorBuffer
    end
  end
end
base.pcallHandler=function(status,err)
  if not status then
    return base.errorHandler(err)
  end
end
base.copy=function(input, output)
  LuaUtil.copyFile(input, output)
  input.close()
end
base.copy2=function(input, output)
  LuaUtil.copyFile(input, output)
end
base.copy3=function(input, output,deleteStatus)
  LuaUtil.copyDir(input, output)
  if deleteStatus then
    os.remove(input)
  end
end
base.initBuildMoudle=function()
  require "import"
  require "permission"
  import "java.io.*"
  import "console"
  import "java.util.zip.*"
  import "com.mythoi.androluaj.util.Utils"
  import "com.mythoi.androluaj.util.DealClasses"
  application_packagename=activity.getPackageName()
  if application_packagename=="com.luastudio.azure" then
    hommeapplication_version="Full"
  elseif application_packagename=="com.luastudiolite.azure" then
    hommeapplication_version="Lite"
  end
  if hommeapplication_version=="Lite" then
    compile "mao"
    compile "sign"
    import "mao.res.*"
    import "apksigner.*"
  else
    import "mao.res.*"
  end
  ApkSigner=luajava.bindClass("com.luastudio.azure.util.ApkSigner")

  errorBuffer=StringBuffer()
end
base.apkHandler=function()
  local zis = buildRes.apkTemplateZipInputStream
  local out = buildRes.tempApkout
  local entry = zis.getNextEntry();
  while entry do
    local name = entry.getName()
    if replaceFiles[name] then
    elseif name:find("META%-INF") then
    elseif name:find("assets") then
    elseif name~="" then
      local zipEntry = ZipEntry(name)
      out.putNextEntry(zipEntry)
      local zipEntryName = zipEntry.getName()
      if zipEntryName == "AndroidManifest.xml" then
        base.updateContent(gets("build_change_file_tips").."\t\t"..zipEntryName)
        base.pcallHandler(pcall(base.replaceAxml,zis,out))
      elseif not zipEntry.isDirectory() then
        base.pcallHandler(pcall(base.copy2,zis,out))
      end
    end
    entry = zis.getNextEntry()
  end
  out.setComment(table.concat(filesMD5s))
  zis.close();
  out.closeEntry()
  out.close()
end
base.addFile=function(path,zipPath,outputStream,deleteStatus)
  if replaceFiles[zipPath] then
    base.errorHandler(path.."/.aly")
    return
  end
  local entry = ZipEntry(zipPath)
  outputStream.putNextEntry(entry)
  replaceFiles[zipPath] = true
  base.copy(FileInputStream(File(path)),outputStream)
  table.insert(filesMD5s, LuaUtil.getFileMD5(path))
  if deleteStatus then
os.remove(path)
  end
end
base.addFile2=function(path,zipPath,outputStream)
  base.copy(FileInputStream(File(path)),outputStream)
end
base.setPureProjectTemplate=function(path)
  if (path and type(path)=="string" and File(path).exists()) then
    paths.apkTemplatePath=path
  elseif (File(buildRes.defalutApkTemplatePath).exists()) then
    paths.apkTemplatePath=buildRes.defalutApkTemplatePath

    axmlReplaceInfo.appName="LuaStudioDemo"
    axmlReplaceInfo.packageName="com.luastudio.demo"
    axmlReplaceInfo.versionName="5.0.20"
    axmlReplaceInfo.versionCode="50020"
  elseif (File(buildRes.defalutApkTemplatePath_2).exists()) then
    paths.apkTemplatePath=buildRes.defalutApkTemplatePath_2

    axmlReplaceInfo.appName="LuaStudioDemo"
    axmlReplaceInfo.packageName="com.luastudio.demo"
    axmlReplaceInfo.versionName="5.0.20"
    axmlReplaceInfo.versionCode="50020"
  else
    --以IDE本身作为模板
    local appInfo=activity.getApplicationInfo()
    local packageInfo=activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0)
    paths.apkTemplatePath=appInfo.publicSourceDir

    axmlReplaceInfo.appName=appInfo.nonLocalizedLabel
    axmlReplaceInfo.packageName=activity.getPackageName()
    axmlReplaceInfo.versionName=packageInfo.versionName
    axmlReplaceInfo.versionCode=packageInfo.versionCode
  end
  buildRes.apkTemplateFile=File(paths.apkTemplatePath)
  buildRes.apkTemplateFileInputStream=FileInputStream(buildRes.apkTemplateFile)
  buildRes.apkTemplateZipInputStream=ZipInputStream(BufferedInputStream(buildRes.apkTemplateFileInputStream))
  base.updateContent(gets("init_apk_template_tips")..":\t"..paths.apkTemplatePath)
  return true
end


base.startDx=function()

  --todo 对dx优化 dex太多合并
  import "com.mythoi.developerApp.build.DexUtil"
  local jarList=luajava.astable(File(paths.buildJars).listFiles())

  if File(paths.libPath).exists() then
    for k,v in ipairs(luajava.astable(File(paths.libPath).listFiles())) do
    if v.isDirectory() then
    else
      jarList[#jarList+1]=v
    end
    end
  end

  for k,v in pairs(jarList) do
    base.updateContent("正在编译dex("..k.."/"..#jarList..")".."\t\t"..v.name)
    if File(paths.buildDex.."/"..v.name..".dex").exists() then
    else
    local arrayDx=ArrayList()
    arrayDx.add("--verbose");
    arrayDx.add("--no-strict");
arrayDx.add("--num-threads="..tostring(Runtime.getRuntime().availableProcessors()*4)) -- 核心数
    arrayDx.add("--output="..paths.buildDex.."/"..v.name..".dex");
    --array.add("--num-threads=12");
    arrayDx.add(v.path);
    local command=arrayDx.toArray(String[arrayDx.size()]);
import "com.duy.dx.command.dexer.Main"
   local code=Main.main(command)
    if code~=0 then
      return base.errorHandler(code)
    end
  end
  end

end


base.readProjectPermission=function()
  if user_permission then
    for k, v in ipairs(user_permission) do
      user_permission[v] = true
      base.updateContent(gets("write_permission_tips")..tostring(v))
    end
  end
end

base.tryToMergeDexs=function()
  import "com.luastudio.azure.util.DexUtil"
  local dexDirFiles=File(paths.buildDex).listFiles()
  if dexDirFiles~=nil then
  local dexList=ArrayList();
  local dexDirFiles=luajava.astable(dexDirFiles)
  for k,v in ipairs(dexDirFiles) do
    base.updateContent(v["name"])
    dexList.add(v["path"]);
  end --add dex
  local message=DexUtil.mergeDex(dexList,paths.outputDexPath.."/classes.dex");
  base.updateContent(message)
end
end

base.apkBuild=function()
  base.updateContent(gets("build_apk_tips"))

  import "java.io.PrintStream"
  import "com.android.sdklib.build.ApkBuilder"

  local errorStream = ByteArrayOutputStream()

  local builder = ApkBuilder(
  File(paths.unsignedApkPath), -- unsignedApkPath
  File(paths.buildTmpApk), -- resourcePath
  nil, --dexPath
  nil, PrintStream(errorStream))


  local function addDir(f,t,n)
    for k,v in ipairs(luajava.astable(File(f).listFiles())) do
      if v.isDirectory() then
        addDir(v.path,t,n)
       elseif v.isFile() then
        local addPath=t..tostring(v.path):gsub(n,"")
        builder.addFile(v,addPath)
      end
    end
  end

  local dexDirFiles=File(paths.outputDexPath).listFiles()
  if dexDirFiles~=nil then
    for k,v in ipairs(luajava.astable(dexDirFiles)) do
      local fileName="classes"..(k-1==0 and "" or k)..".dex"
  base.updateContent(gets("build_add_file_tips")..fileName)
      builder.addFile(v,fileName)
    end --add dex
  else
    for k,v in ipairs(luajava.astable(File(paths.buildDex).listFiles())) do
      local fileName="classes"..(k-1==0 and "" or k)..".dex"
      base.updateContent(gets("build_add_file_tips")..fileName)
  builder.addFile(v,fileName)
    end --add dex
end

  if File(paths.buildLua).exists() then
    base.updateContent("add_source_folder_tips"..paths.buildLua)
    builder.addSourceFolder(File(paths.buildLua))
  end--add lua

  if File(paths.resourcesPath).exists() then
    base.updateContent("add_source_folder_tips"..paths.resourcesPath)
    builder.addSourceFolder(File(paths.resourcesPath))
  end--add resources

  if File(paths.buildAssets).exists() then
    base.updateContent("add_source_folder_tips"..paths.buildAssets)
    addDir(paths.buildAssets,"assets",paths.buildAssets)
  end --add assets

  if File(paths.jniLibsPath).exists() then
    base.updateContent("add_source_folder_tips"..paths.jniLibsPath)
    addDir(paths.jniLibsPath,"lib",paths.jniLibsPath)
  end --add lib

  if File(paths.libDir).exists() then
    base.updateContent("add_source_folder_tips"..paths.libDir)
    addDir(paths.libDir,"lib",paths.libDir)
  end --add lib

  local code=pcall(builder.sealApk)
  if not(code) then
    base.errorHandler(errorStream.toString())
  end
end

base.getFilesList=function(path)
  local filesList
  local lf=File(path).listFiles()
  if lf~=nil then
    filesList=luajava.astable(lf)
  else
    filesList={}
  end
  return filesList
end

base.buildAssetsFiles=function(path,dir)
  if buildSettings.outputFileStatus then
  else
  local entry = ZipEntry("assets/" .. dir)
  buildRes.tempApkout.putNextEntry(entry)
  end
  local filesList=base.getFilesList(path)
  for index,file in ipairs(filesList) do
    local name=file["name"]
    local file_path=file["path"]
    if file.isDirectory() then
      base.buildAssetsFiles(file["path"],dir..name.."/")
    else
      if name==(".using") then
      elseif name:find("%.apk$") or name:find("%.luac$") or name:find("^%.") then
      elseif name:find("%.lsinfo$") then
      elseif name:find("%.lsz$") then
      elseif name:find("%.lua$") or name:find("%.aly$") then
        local zipFileName=((name:find("%.lua$") and name) or (name:find("%.aly$") and name:gsub("aly$", "lua")))
        local zipPath="assets/" .. dir..zipFileName
        base.updateContent(gets("build_compile_file_tips")..zipPath)
        local newFilePath=paths.buildAssets.."/"..dir..zipFileName
        base.pcallHandler(pcall(base.buildLuaFile,file_path,zipPath,newFilePath))
      else
        if buildSettings.outputFileStatus then
          local newFilePath=paths.buildAssets.."/"..dir..name
          base.pcallHandler(pcall(base.copy3,file_path,newFilePath))
        else
        base.pcallHandler(pcall(base.addFile,file_path,"assets/" .. dir..name,buildRes.tempApkout))
        end
        base.updateContent(gets("build_add_file_tips").."assets/" .. dir .. name)
      end
    end
  end
end


--TEST
base.buildLuaFile=function(path,zipPath,newFilePath)
  local file=File(path)
  local fileName=file["name"]
  local path_2, err = ((fileName:find("%.lua$") and console.build(path)) or (fileName:find("%.aly$") and console.build_aly(path)))
  if path_2 then
    if buildSettings.outputFileStatus then
    base.updateContent(gets("build_add_file_tips").. newFilePath)
      base.pcallHandler(pcall(base.copy3,path_2,newFilePath,true))
    else
    --删除编译文件
    base.pcallHandler(pcall(base.addFile,path_2,zipPath,buildRes.tempApkout,true))
    end
  else
    base.updateContent(gets("build_add_file_tips").. zipPath.."\t\t"..tostring(err))
    if buildSettings.outputFileStatus then
      base.updateContent(gets("build_add_file_tips").. newFilePath)
      base.pcallHandler(pcall(base.copy3,path,newFilePath))
      else
        base.pcallHandler(pcall(base.addFile,path,zipPath,buildRes.tempApkout))
      end
  end
end

--TEST
base.buildLuaFiles=function(path,dir,dir2)
   local filesList=base.getFilesList(path)
  for index,file in ipairs(filesList) do
    local name=file["name"]
    local file_path=file["path"]
    if file.isDirectory() then--如果是文件夹则
      --base.updateContent(gets("read_file_list_tips")..file_path)
      base.pcallHandler(pcall(base.buildLuaFiles,file_path,name,dir2.."/"..name))
    else
      if name:find("%.lua$") or name:find("%.aly$") then
        local zipFileName=((name:find("%.lua$") and name) or (name:find("%.aly$") and name:gsub("aly$", "lua")))
        local zipPath=dir2.."/"..zipFileName
        local newFilePath=paths.buildLua.."/"..dir2.."/"..zipFileName
        base.updateContent(gets("build_compile_file_tips")..zipPath)
        base.pcallHandler(pcall(base.buildLuaFile,file_path,zipPath,newFilePath))
      else
        base.updateContent(gets("build_add_file_tips")..dir2 .."/".. name)
        if buildSettings.outputFileStatus then
          local newFilePath=paths.buildLua.."/"..dir2 .."/".. name
          base.pcallHandler(pcall(base.copy3,file_path,newFilePath))
        else
        base.pcallHandler(pcall(base.addFile,file_path,dir2.."/"..name,buildRes.tempApkout))
        end
      end
    end
  end
end

--TEST
base.buildLibFiles=function(path,dir)
  local filesList=base.getFilesList(path)
  for index,file in ipairs(filesList) do
    local name=file["name"]
    local file_path=file["path"]
    if file.isDirectory() then--如果是文件夹则
      base.buildLibFiles(file_path,name.."/")
    else
      base.updateContent(gets("build_add_file_tips").. "lib/"..dir..name)
      if buildSettings.outputFileStatus then
        --输出到文件
        local newFilePath=paths.buildLib.."/"..dir..name
        base.pcallHandler(pcall(base.copy3,file_path,newFilePath))
      else
      base.addFile(file_path,"lib/"..dir..name,buildRes.tempApkout)
      end
    end
  end
end

--TEST
base.addExtendedFiles=function()
  --打包Lua目录
  base.pcallHandler(pcall(base.buildLuaFiles,paths.luaDir,"","lua"))
  if buildSettings.outputFileStatus then
  else
  --打包Lib目录
  base.pcallHandler(pcall(base.buildLibFiles,paths.libDir,""))
end
end

base.addRes=function()
  local iconFile = File(paths.assetsPath .. "/icon.png")
  if iconFile.exists() then
    base.addFile(iconFile["path"],"res/drawable/icon.png",buildRes.tempApkout)
    base.updateContent(gets("build_add_file_tips").. "res/drawable/icon.png")
  end
  local welcomeFile = File(paths.assetsPath .. "/welcome.png")
  if welcomeFile.exists() then
    base.addFile(welcomeFile["path"],"res/drawable/welcome.png",buildRes.tempApkout)
    base.updateContent(gets("build_add_file_tips").. "res/drawable/welcome.png")
    build_info["useStartInterface"]=true
  end
  return true
end

base.updateContent=function(content)
    if pcall(function() this.update(tostring(content))end) then
    else
      activity.runOnUiThread(function()
      if pcall(function()
        if build_apk_status then
          build_apk_status='=>'..tostring(content).."\n"..build_apk_status
        else
          build_apk_status=tostring(content)
        end
        build_apk_log.setText(build_apk_status)

      end) then
      else
        print(content)
      end
    end)
  end
end

base.replaceAxml=function(inputStream,outputStream)
  local function touint32(i)
    local code = string.format("%08x", i)
    local uint = {}
    for n in code:gmatch("..") do
      table.insert(uint, 1, string.char(tonumber(n, 16)))
    end
    return table.concat(uint)
  end

  if build_info["path_pattern"] and #build_info["path_pattern"] > 1 then
    build_info["path_pattern"] = ".*\\\\." .. build_info["path_pattern"]:match("%w+$")
  end

  local arrayList = ArrayList()
  local axmlDecoder = AXmlDecoder.read(arrayList, inputStream)

  local requestChangedInfo

  --是否使用启动界面
  if build_info.useStartInterface then
    requestChangedInfo = {
      [axmlReplaceInfo["packageName"]] = build_info["packagename"],
      [axmlReplaceInfo["appName"]] = build_info["appname"],
      [axmlReplaceInfo["versionName"]] = build_info["appver"],
      [".*\\\\.alp"] = build_info["path_pattern"] or "",
      [".*\\\\.lua"] = "",
      [".*\\\\.luac"] = "",
      --启动图
      ["android.intent.action.MAIN"] = "welcome",
      ["android.intent.category.LAUNCHER"] = "welcome2",
      ["startinterface"] = "android.intent.action.MAIN",
      ["startinterface2"] = "android.intent.category.LAUNCHER",
    }
  else
    requestChangedInfo = {
      [axmlReplaceInfo["packageName"]] = build_info["packagename"],
      [axmlReplaceInfo["appName"]] = build_info["appname"],
      [axmlReplaceInfo["versionName"]] = build_info["appver"],
      [".*\\\\.alp"] = build_info["path_pattern"] or "",
      [".*\\\\.lua"] = "",
      [".*\\\\.luac"] = "",
    }
  end

  --修改应用信息和权限
  for n = 0, arrayList.size() - 1 do
    local v = arrayList.get(n)
    if requestChangedInfo[v] then
      arrayList.set(n, requestChangedInfo[v])
      base.updateContent(tostring(v).."\t\t=>\t"..tostring(requestChangedInfo[v]))
    elseif user_permission then
      local p = v:match("%.permission%.([%w_]+)$")
      if p and (not user_permission[p]) then
        arrayList.set(n, "android.permission.UNKNOWN")
      end
    end
  end

  local tmpAxml = activity.getLuaPath("tmpAxml.xml")
  local tmpAxmlfos = FileOutputStream(tmpAxml)
  axmlDecoder.write(arrayList,tmpAxmlfos)
  tmpAxmlfos.close()

  local tmpAxmlfos=io.open(tmpAxml)
  local tmpAxmlContent=tmpAxmlfos:read("*a")
  tmpAxmlfos.close()

  base.updateContent(gets("try_to_replace_code").."\t"..axmlReplaceInfo["versionCode"].."\t=>\t"..build_info["appcode"])
  --替换版本号
  tmpAxmlContent = string.gsub(tmpAxmlContent, touint32(axmlReplaceInfo["versionCode"]), touint32(tointeger(build_info["appcode"]) or 1),1)

  --替换SDK版本
  --tmpAxmlContent = string.gsub(tmpAxmlContent, touint32(21), touint32(tointeger(26) or 21),1)

  --写入新的缓存文件
  local tmpAxmlfos = io.open(tmpAxml, "w")
  tmpAxmlfos:write(tmpAxmlContent)
  tmpAxmlfos:close()

  base.addFile2(tmpAxml,"AndroidManifest.xml",outputStream)
  os.remove(tmpAxml)
end

base.createTempApk=function()
  base.updateContent(gets("create_temp_apk").."\t"..paths.unsignedApkPath)
  buildRes.tempApkfot=FileOutputStream(paths.unsignedApkPath)
  buildRes.tempApkout=ZipOutputStream(BufferedOutputStream(buildRes.tempApkfot))
end

base.signByKellinwood=function(apkPath,signedApkPath)
  local function sign_apk(keystore_path,keystore_password,alias,alias_password,unsigned_apk_path,signed_apk_path,algorithm)
    import "java.security.*"
    import "java.security.cert.*"
    import "kellinwood.security.zipsigner.*"
    import "kellinwood.security.zipsigner.optional.*"
    zipSigner = ZipSigner()
    KeyStores = KeyStoreFileManager.loadKeyStore(keystore_path,String(keystore_password).toCharArray())
    privateKey = KeyStores.getKey(alias,String(alias_password).toCharArray())
    x509Certificate = KeyStores.getCertificate(alias)
    zipSigner.setKeys("Azure",x509Certificate ,privateKey,algorithm,nil)
    zipSigner.signZip(unsigned_apk_path, signed_apk_path);
    return true
  end
  local custom_key_path=signInfo["keyPath"]
  local custom_key_password=signInfo["keyPassword"]
  local custom_key_alias=signInfo["keyAlias"]
  local custom_key_alias_password=signInfo["keyAliasPassword"]
  local signature_algorithm=signInfo["signatureAlgorithm"]
  base.updateContent(custom_key_path)
  return sign_apk(custom_key_path,custom_key_password,custom_key_alias,custom_key_alias_password,apkPath,signedApkPath,signature_algorithm)
end

base.signByApkSigner=function(apkPath,signedApkPath)
  local keyPath=signInfo["keyPath"]
  local certPath=signInfo["certPath"]
  if (keyPath and certPath and (File(keyPath).exists()) and (File(certPath).exists())) then
    base.updateContent(keyPath.."&"..certPath)
    return ApkSigner.sign(apkPath,signedApkPath,keyPath,certPath)
  else
    return false
  end
end



base.signApk=function(apkPath,signedApkPath,info)
  base.updateContent(gets("begin_sign_lib_tips").."\n");
  local signLibrary=info["signLibrary"] 
  if signLibrary and signLibrary=="kellinwood" then
    return base.signByKellinwood(apkPath,signedApkPath)
  else
    return base.signByApkSigner(apkPath,signedApkPath)
  end
  --Signer.sign(apkPath, signedApkPath)
end
return base