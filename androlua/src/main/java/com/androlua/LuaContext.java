package com.androlua;

import android.content.*;
import com.luajava.*;
import java.util.*;
import java.util.Map;

public interface LuaContext {
     ArrayList<ClassLoader> getClassLoaders();
     void call(String func, Object... args);
     void set(String name, Object value);
     String getLuaPath();
     String getLuaPath(String path);
     String getLuaPath(String dir, String name);
     String getLuaDir();
     String getLuaDir(String dir);
     String getLuaExtDir();
     String getLuaExtDir(String dir);
     void setLuaExtDir(String dir);
     String getLuaExtPath(String path);
     String getLuaExtPath(String dir, String name);
     String getLuaLpath();
     String getLuaCpath();
     Context getContext();
     LuaState getLuaState();
     Object doFile(String path, Object... arg);
     void sendMsg(String msg);
     void sendError(String title, Exception msg);
     int getWidth();
     int getHeight();
     Map getGlobalData();
     Object getSharedData(String key);
     Object getSharedData(String key,Object def);
     boolean setSharedData(String key, Object value);
     void regGc(LuaGcable obj);
}