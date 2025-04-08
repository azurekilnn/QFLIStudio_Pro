package com.luastudio.azure.util;

import com.luajava.LuaFunction;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import com.luajava.LuaTable;

public class LuaUtil {

    public static Object luaDump(LuaTable table) {
        LuaState luaState = LuaStateFactory.newLuaState();
        LuaObject luaDump = luaState.getLuaObject("dump");
        return luaDump.call(table);
    }

    public static void luaTableInsert(LuaTable table, LuaTable item) {
        LuaState luaState = LuaStateFactory.newLuaState();
        LuaFunction tableInsert;
        tableInsert = luaState.getLuaObject("table").getField("insert").getFunction();
        tableInsert.call(table, item);
    }
    public static void luaTableInsert(LuaTable table, String item) {
        LuaState luaState = LuaStateFactory.newLuaState();
        LuaFunction tableInsert;
        tableInsert = luaState.getLuaObject("table").getField("insert").getFunction();
        tableInsert.call(table, item);
    }
}
