package com.androlua;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.widget.Toast;

import androidx.core.content.FileProvider;

import com.luajava.LuaState;
import com.luajava.LuaTable;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class LuaApplication extends Application implements LuaContext {

    public static LuaApplication mApp;
    static private HashMap<String, Object> data = new HashMap<String, Object>();
    protected String localDir;
    protected String odexDir;
    protected String libDir;
    protected String luaMdDir;
    protected String luaCpath;
    protected String luaLpath;
    protected String luaExtDir;
    protected String appExtDir;
    protected String luaCustomDir;
    protected String androlua_verison;
    protected String androlua_verisoncode;

    protected String environment_root_path;
    protected File luaDataDir;

    private boolean isUpdata;
    private SharedPreferences mSharedPreferences;


    public Uri getUriForPath(String path) {
        return FileProvider.getUriForFile(this, getPackageName(), new File(path));
    }

    public Uri getUriForFile(File path) {
        return FileProvider.getUriForFile(this, getPackageName(), path);
    }

    public String getPathFromUri(Uri uri) {

        String path = null;
        if (uri != null) {
            String[] p = {
                    getPackageName()
            };
            switch (uri.getScheme()) {
                case "content":
                    /*try {
						InputStream in = getContentResolver().openInputStream(uri);
					} catch (IOException e) {
						e.printStackTrace();
					}*/
                    Cursor cursor = getContentResolver().query(uri, p, null, null, null);

                    if (cursor != null) {
                        int idx = cursor.getColumnIndexOrThrow(getPackageName());
                        if (idx < 0)
                            break;
                        path = cursor.getString(idx);
                        cursor.moveToFirst();
                        cursor.close();
                    }
                    break;
                case "file":
                    path = uri.getPath();
                    break;
            }
        }
        return path;
    }


    public static LuaApplication getInstance() {
        return mApp;
    }

    @Override
    public ArrayList<ClassLoader> getClassLoaders() {
        // TODO: Implement this method
        return null;
    }

    @Override
    public void regGc(LuaGcable obj) {
        // TODO: Implement this method
    }

    @Override
    public String getLuaPath() {
        // TODO: Implement this method
        return null;
    }

    @Override
    public String getLuaPath(String path) {
        return new File(getLuaDir(), path).getAbsolutePath();
    }

    @Override
    public String getLuaPath(String dir, String name) {
        return new File(getLuaDir(dir), name).getAbsolutePath();
    }

    @Override
    public String getLuaExtPath(String path) {
        return new File(getLuaExtDir(), path).getAbsolutePath();
    }

    @Override
    public String getLuaExtPath(String dir, String name) {
        return new File(getLuaExtDir(dir), name).getAbsolutePath();
    }

    public int getWidth() {
        return getResources().getDisplayMetrics().widthPixels;
    }

    public int getHeight() {
        return getResources().getDisplayMetrics().heightPixels;
    }

    @Override
    public String getLuaDir(String dir) {
        // TODO: Implement this method
        return localDir;
    }

    @Override
    public String getLuaExtDir(String name) {
        File dir = new File(getLuaExtDir(), name);
        if (!dir.exists())
            if (!dir.mkdirs())
                return dir.getAbsolutePath();
        return dir.getAbsolutePath();
    }
    public String getCustomDir() {
        // TODO: Implement this method
        return luaCustomDir;
    }
    public String getEnvironmentDir(String name) {
        File dir = new File(getEnvironmentDir(), name);
        if (!dir.exists())
            if (!dir.mkdirs())
                return dir.getAbsolutePath();
        return dir.getAbsolutePath();
    }
    public String getAndroLuaVersion() {
        // TODO: Implement this method
        return androlua_verison;
    }
    public String getAndroLuaVersionCode() {
        // TODO: Implement this method
        return androlua_verisoncode;
    }
    public File getLuaDataDir() {
        // TODO: Implement this method
        return luaDataDir;
    }
    public String getLibDir() {
        // TODO: Implement this method
        return libDir;
    }


    public String getOdexDir() {
        // TODO: Implement this method
        return odexDir;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        disableAPIDialog();
        mApp = this;
        CrashHandler crashHandler = CrashHandler.getInstance();
        // 注册crashHandler
        crashHandler.init(getApplicationContext());
        mSharedPreferences = getSharedPreferences(this);

        //初始化AndroLua工作目录
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            String sdDir = Environment.getExternalStorageDirectory().getAbsolutePath();
            luaExtDir = sdDir + "/QFLIStudio_Pro/LuaStudio_Pro";
            appExtDir = sdDir + "/QFLIStudio_Pro";
            luaCustomDir = luaExtDir + "/luastudio_custom";
            environment_root_path =luaExtDir + "/.environment";
               } else {
            File[] fs = new File("/storage").listFiles();
            for (File f : fs) {
                String[] ls = f.list();
                if (ls == null)
                    continue;
                if (ls.length > 5)
                    luaExtDir = f.getAbsolutePath() + "/LuaStudio_Pro";
                luaCustomDir = luaExtDir + "/luastudio_custom";

                environment_root_path = luaExtDir + "/.environment"; }
            if (luaExtDir == null)
                luaExtDir = getDir("LuaStudio_Pro", Context.MODE_PRIVATE).getAbsolutePath();
            luaCustomDir = luaExtDir + "/luastudio_custom";

            environment_root_path =luaExtDir + "/.environment";
        }

        File destDir = new File(luaExtDir);
        if (!destDir.exists())
            destDir.mkdirs();
        File appDir = new File(appExtDir);
        if (!appDir.exists())
            appDir.mkdirs();
        File customDir = new File(luaCustomDir);
        if (!customDir.exists())
            customDir.mkdirs();

        //定义文件夹
        luaDataDir = this.getExternalFilesDir("");
        androlua_verison = "5.0.20";
        androlua_verisoncode = "50020";
        //localDir = getFilesDir().getAbsolutePath();
        localDir = getDir("luastudio", Context.MODE_PRIVATE).getAbsolutePath();
        odexDir = getDir("odex", Context.MODE_PRIVATE).getAbsolutePath();
        libDir = getDir("lib", Context.MODE_PRIVATE).getAbsolutePath();
        luaMdDir = getDir("lua", Context.MODE_PRIVATE).getAbsolutePath();
        luaCpath = getApplicationInfo().nativeLibraryDir + "/lib?.so" + ";" + libDir + "/lib?.so";
        //luaDir = extDir;
        luaLpath = luaMdDir + "/?.lua;" + luaMdDir + "/lua/?.lua;" + luaMdDir + "/?/init.lua;";

    }

    private static SharedPreferences getSharedPreferences(Context context) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            Context deContext = context.createDeviceProtectedStorageContext();
            if (deContext != null)
                return PreferenceManager.getDefaultSharedPreferences(deContext);
            else
                return PreferenceManager.getDefaultSharedPreferences(context);
        } else {
            return PreferenceManager.getDefaultSharedPreferences(context);
        }
    }

    @Override
    public String getLuaDir() {
        // TODO: Implement this method
        return localDir;
    }

    @Override
    public void call(String name, Object[] args) {
        // TODO: Implement this method
    }

    @Override
    public void set(String name, Object object) {
        // TODO: Implement this method
        data.put(name, object);
    }

    @Override
    public Map getGlobalData() {
        return data;
    }


    @Override
    public Object getSharedData(String key) {
        return mSharedPreferences.getAll().get(key);
    }

    @Override
    public Object getSharedData(String key, Object def) {
        Object ret = mSharedPreferences.getAll().get(key);
        if (ret == null)
            return def;
        return ret;
    }

    @Override
    public boolean setSharedData(String key, Object value) {
        SharedPreferences.Editor edit = mSharedPreferences.edit();
        if (value == null)
            edit.remove(key);
        else if (value instanceof String)
            edit.putString(key, value.toString());
        else if (value instanceof Long)
            edit.putLong(key, (Long) value);
        else if (value instanceof Integer)
            edit.putInt(key, (Integer) value);
        else if (value instanceof Float)
            edit.putFloat(key, (Float) value);
        else if (value instanceof Set)
            edit.putStringSet(key, (Set<String>) value);
        else if (value instanceof LuaTable)
            edit.putStringSet(key, (HashSet<String>) ((LuaTable) value).values());
        else if (value instanceof Boolean)
            edit.putBoolean(key, (Boolean) value);
        else
            return false;
        edit.apply();
        return true;
    }

    public Object get(String name) {
        // TODO: Implement this method
        return data.get(name);
    }

    public String getLocalDir() {
        // TODO: Implement this method
        return localDir;
    }


    public String getMdDir() {
        // TODO: Implement this method
        return luaMdDir;
    }

    @Override
    public String getLuaExtDir() {
        // TODO: Implement this method
        return luaExtDir;
    }

    public String getAppExtDir() {
        // TODO: Implement this method
        return appExtDir;
    }

    public String getEnvironmentDir() {
        // TODO: Implement this method
        return environment_root_path;
    }


    @Override
    public void setLuaExtDir(String dir) {
        // TODO: Implement this method
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            String sdDir = Environment.getExternalStorageDirectory().getAbsolutePath();
            luaExtDir = new File(sdDir , dir).getAbsolutePath();
        } else {
            File[] fs = new File("/storage").listFiles();
            for (File f : fs) {
                String[] ls = f.list();
                if (ls == null)
                    continue;
                if (ls.length > 5)
                    luaExtDir = new File(f, dir).getAbsolutePath() ;
            }
            if (luaExtDir == null)
                luaExtDir = getDir(dir, Context.MODE_PRIVATE).getAbsolutePath();
        }
    }

    @Override
    public String getLuaLpath() {
        // TODO: Implement this method
        return luaLpath;
    }

    @Override
    public String getLuaCpath() {
        // TODO: Implement this method
        return luaCpath;
    }

    @Override
    public Context getContext() {
        // TODO: Implement this method
        return this;
    }

    @Override
    public LuaState getLuaState() {
        // TODO: Implement this method
        return null;
    }

    @Override
    public Object doFile(String path, Object[] arg) {
        // TODO: Implement this method
        return null;
    }

    @Override
    public void sendMsg(String msg) {
        // TODO: Implement this method
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();

    }

    @Override
    public void sendError(String title, Exception msg) {

    }

    /**
     * 反射 禁止弹窗
     */
    private void disableAPIDialog(){
        if (Build.VERSION.SDK_INT < 28)return;
        try {
            Class clazz = Class.forName("android.app.ActivityThread");
            Method currentActivityThread = clazz.getDeclaredMethod("currentActivityThread");
            currentActivityThread.setAccessible(true);
            Object activityThread = currentActivityThread.invoke(null);
            @SuppressLint("SoonBlockedPrivateApi") Field mHiddenApiWarningShown = clazz.getDeclaredField("mHiddenApiWarningShown");
            mHiddenApiWarningShown.setAccessible(true);
            mHiddenApiWarningShown.setBoolean(activityThread, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

