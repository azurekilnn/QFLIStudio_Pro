function build_pro(info)
  require "import"
  --导入字符串模块
  import "system.system_strings"
  --导入打包模块
  import "build"
  local projectPath=info["projectPath"]
  --print(projectPath)
  local autoOpenStatus=info["autoOpenStatus"]
  local projectType=info["template"]
  --初始化打包模块
  build.pcallHandler(pcall(build.initBuildMoudle))
  build.pcallHandler(pcall(build.setProjectPath,info))
  build.pcallHandler(pcall(build.checkExtendedFiles))
  --读取工程信息 build_info
  build.pcallHandler(pcall(dofile,paths["buildFilePath"]))
  if projectType=="lua_java" then
    build.pcallHandler(pcall(build.initAapt))
    --开始aapt
    build.pcallHandler(pcall(build.startAapt))
    --输出文件
    build_info["outputFileStatus"]=true
    buildSettings["outputFileStatus"]=true
  else
    build.pcallHandler(pcall(build.setPureProjectTemplate,info["apkTemplatePath"]))
    build.pcallHandler(pcall(build.createTempApk))
  end
  build.updateContent(gets("building_tip_2").."...")--打包模块已就绪
  --设置工程目录
  local assetsPath=paths.assetsPath
  build.updateContent(gets("building_tip_1")..projectPath)
  build.updateContent(gets("building_tip_3"))--如果打包出错无法返回可长按页面或长按顶栏强制退出，并将报错截图反馈于我。
  build.updateContent(gets("building_tip_4"))--特别注意：工程目录所有文件名不得包含中文，否则可能会造成打包失败

  --设置Apk模板
  build.updateContent(gets("start_packing_tip"));--开始打包...

  if File(assetsPath).exists() then
    if projectType=="lua_java" then
    else
      build.pcallHandler(pcall(build.addRes))
    end
    build.updateContent(gets("start_packing_libraries_file_tip"))--开始打包运行库文件
    build.pcallHandler(pcall(build.addExtendedFiles))
    --准备修改axml的权限
    build.pcallHandler(pcall(build.buildAssetsFiles,assetsPath,""))

    if projectType=="lua_java" then
      --开始 编译 java
      build.pcallHandler(pcall(build.startJavac))
      --开始dx
      build.pcallHandler(pcall(build.startDx))
      local status, err = pcall(build.tryToMergeDexs)
      build.updateContent("mergeDexs"..tostring(status))
      build.pcallHandler(pcall(build.apkBuild))
    else
      build.pcallHandler(pcall(build.readProjectPermission))
      build.pcallHandler(pcall(build.apkHandler))

    end
    local status, err = pcall(build.signApk,paths.unsignedApkPath,paths.signedApkPath,info)
    if not status then
      os.remove(paths.unsignedApkPath)
      return build.errorHandler(err)
    else
      build.updateContent(gets("signature_complete_tips"));
      os.remove(paths.unsignedApkPath)
      if autoOpenStatus==false then
      else
        activity.installApk(tostring(paths.signedApkPath))
      end
      -- build.updateContent("正在打开安装包...\n");
      -- build.updateContent("安装包路径："..apkpath);
      build.updateContent(gets("opening_apk_tips").."\n");
      build.updateContent(gets("build_apk_path_tips")..paths.signedApkPath);
    end 
  end
  if (errorBuffer.toString()~="") then
    return errorBuffer
  else
    return true
  end
end