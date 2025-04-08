package com.luastudio.azure.util;


import android.app.*;
import android.content.*;
import android.content.pm.*;
import android.graphics.*;
import android.net.*;
import android.os.*;
import android.provider.*;
import android.text.*;
import android.util.*;
import java.io.*;
import java.lang.reflect.*;
import java.lang.Process;

public class LuaWallpaper
{

	//参数:
	//上下文,图片绝对路径
    public static void setWallpaper(Context context,String path)
	{
		
		String authority = context.getPackageName();
		
        if (context == null || TextUtils.isEmpty(path) || TextUtils.isEmpty(authority))
		{
            return;
        }
        Uri uriPath = getUriWithPath(context, path, authority);
        Intent intent;
        if (isHuaweiRom())
		{
            try
			{
                ComponentName componentName =
                    new ComponentName("com.android.gallery3d", "com.android.gallery3d.app.Wallpaper");
                intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(uriPath, "image/*");
                intent.putExtra("mimeType", "image/*");
                intent.setComponent(componentName);
                context.startActivity(intent);
            }
			catch (Exception e)
			{
                e.printStackTrace();
                try
				{
                    WallpaperManager.getInstance(context.getApplicationContext())
                        .setBitmap(getImageBitmap(path));
                }
				catch (IOException e1)
				{
                    e1.printStackTrace();
                }
            }
        }
		else if (isMiuiRom())
		{
            try
			{
                ComponentName componentName = new ComponentName("com.android.thememanager",
																"com.android.thememanager.activity.WallpaperDetailActivity");
                intent = new Intent("miui.intent.action.START_WALLPAPER_DETAIL");
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(uriPath, "image/*");
                intent.putExtra("mimeType", "image/*");
                intent.setComponent(componentName);
                context.startActivity(intent);
            }
			catch (Exception e)
			{
                e.printStackTrace();
                try
				{
                    WallpaperManager.getInstance(context.getApplicationContext())
                        .setBitmap(getImageBitmap(path));
                }
				catch (IOException e1)
				{
                    e1.printStackTrace();
                }
            }
        }
		else
		{
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
			{
                try
				{
                    intent =
                        WallpaperManager.getInstance(context.getApplicationContext()).getCropAndSetWallpaperIntent(uriPath);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.getApplicationContext().startActivity(intent);
                }
				catch (IllegalArgumentException e)
				{
                    Bitmap bitmap = null;
                    try
					{
                        bitmap = MediaStore.Images.Media.getBitmap(context.getApplicationContext().getContentResolver(), uriPath);
                        if (bitmap != null)
						{
                            WallpaperManager.getInstance(context.getApplicationContext()).setBitmap(bitmap);
                        }
                    }
					catch (IOException e1)
					{
                        e1.printStackTrace();
                    }
                }
            }
			else
			{
                try
				{
                    WallpaperManager.getInstance(context.getApplicationContext())
                        .setBitmap(getImageBitmap(path));
                }
				catch (IOException e1)
				{
                    e1.printStackTrace();
                }
            }
        }
    }

	private static Bitmap getImageBitmap(String srcPath)
	{
		return BitmapFactory.decodeFile(srcPath);
	}

	private static Uri getUriWithPath(Context context, String filepath, String authority)
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
		{
			//7.0以上的读取文件uri要用这种方式了
			return FileProvider.getUriForFile(context.getApplicationContext(), authority, new File(filepath));
		}
		else
		{
			return Uri.fromFile(new File(filepath));
		}
	}
	 
    /**
     * 判断是否为华为系统
     */
    private static boolean isHuaweiRom()
	{
        if (!TextUtils.isEmpty(getEmuiVersion()) && !getEmuiVersion().equals(""))
		{
            return true;
        }
        return false;
    }

    /**
     * 判断是否为小米系统
     */
    private static boolean isMiuiRom()
	{
        if (!TextUtils.isEmpty(getSystemProperty("ro.miui.ui.version.name")))
		{
            return true;
        }
        return false;
    }

    private static String getSystemProperty(String propName)
	{
        String line;
        BufferedReader input = null;
        try
		{
            Process p = Runtime.getRuntime().exec("getprop " + propName);
            input = new BufferedReader(new InputStreamReader(p.getInputStream()), 1024);
            line = input.readLine();
            input.close();
        }
		catch (IOException ex)
		{
            return null;
        }
		finally
		{
            if (input != null)
			{
                try
				{
                    input.close();
                }
				catch (IOException e)
				{
                    
                }
            }
        }
        return line;
    }

    /**
     * 判断是否为Flyme系统
     */
    private static boolean isFlymeRom(Context context)
	{
        Object obj = isInstalledByPkgName(context, "com.meizu.flyme.update") ;
          
        return isInstalledByPkgName(context, "com.meizu.flyme.update");
    }

    /**
     * 判断是否是Smartisan系统
     */
    private static boolean isSmartisanRom(Context context)
	{
        Object obj = isInstalledByPkgName(context, "com.smartisanos.security");
		
        return isInstalledByPkgName(context, "com.smartisanos.security");
    }

    /**
     * 根据包名判断这个app是否已安装
     */
    private static boolean isInstalledByPkgName(Context context, String pkgName)
	{
        PackageInfo packageInfo;
        try
		{
            packageInfo = context.getPackageManager().getPackageInfo(pkgName, 0);
        }
		catch (PackageManager.NameNotFoundException e)
		{
            packageInfo = null;
        }
        if (packageInfo == null)
		{
            return false;
        }
		else
		{
            return true;
        }
    }

    /**
     * @return 只要返回不是""，则是EMUI版本
     */
    private static String getEmuiVersion()
	{
        String emuiVerion = "";
        Class<?>[] clsArray = new Class<?>[] { String.class };
        Object[] objArray = new Object[] { "ro.build.version.emui" };
        try
		{
            Class<?> SystemPropertiesClass = Class.forName("android.os.SystemProperties");
            Method get = SystemPropertiesClass.getDeclaredMethod("get", clsArray);
            String version = (String) get.invoke(SystemPropertiesClass, objArray);
            
            if (!TextUtils.isEmpty(version))
			{
                return version;
            }
        }
		catch (ClassNotFoundException e)
		{
            
        }
		catch (LinkageError e)
		{
            
        }
		catch (NoSuchMethodException e)
		{
            
        }
		catch (NullPointerException e)
		{
            
        }
		catch (Exception e)
		{
            
        }
        return emuiVerion;
    }
	
	
	
	
	
}







