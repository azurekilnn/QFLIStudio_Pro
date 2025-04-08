import "android.Manifest"
import "android.tool.PermissionHelper"
function system_permission_dialog()
  permiss=AlertDialog.Builder(this)
  permiss.setTitle("提示")
  permiss.setMessage("LuaStudio需要获取一些基础权限：\n•读取/写入设备存储空间。")
  permiss.setPositiveButton("前往设置",{onClick=function(v)
      --import "android.os.Build"
      --SDK版本=tonumber(Build.VERSION.SDK)
      --if SDK版本 < 23 then
      local intent=Intent()
      .setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
      .setData(Uri.fromParts("package", activity.getPackageName(), nil))
      activity.startActivity(intent)
      --[[elseif SDK版本>= 23 then
        e,s=pcall(动态申请权限)
        if e==true then
         else
          activity.startActivity(Intent()
          .setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
          .setData(Uri.fromParts("package", activity.getPackageName(), nil)))
        end
      end]]
      task(500,function()
        os.exit()
      end)
    end})
  permiss.setNeutralButton(gets("cancel_button"),{onClick=function(v)
      task(500,function()
        os.exit()
      end)
    end})
  permiss.setCancelable(false)
  permiss.show()
end

--[[function 动态申请权限()
  --需要申请的权限(权限组)
  permissions = {Manifest.permission.READ_EXTERNAL_STORAGE}
  --新建PermissionHelper
  ph = PermissionHelper()
  ph.request(activity,permissions,function(state)
    提示(state)
    if state==true then
      提示("LuaStudio 已获得读取/写入内部存储空间 的权限。")
     else
     --权限申请对话框()
    end
    --event(state)
    --state为boolean值
  end)
  --Activity申请权限回调
  function onRequestPermissionsResult(code,permissions,results)
    --调用PermissionHelper中方法检测是否申请了所有权限
    ph.onRequestPermissionsResult(code,permissions,results)
  end
end]]