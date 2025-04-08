package com.luastudio.azure;

import com.androlua.LuaContext;
import com.luajava.LuaException;
import com.luajava.LuaObject;

public class LuaAppTimer extends com.androlua.LuaTimer {

    public LuaAppTimer(LuaContext main, String src) throws LuaException {
        super(main, src);
    }

    public LuaAppTimer(LuaContext main, String src, Object[] arg) throws LuaException {
        super(main, src, arg);
    }

    public LuaAppTimer(LuaContext main, LuaObject func, Object[] arg) throws LuaException {
        super(main, func, arg);
    }

    public LuaAppTimer(LuaContext main, LuaObject func) throws LuaException {
        super(main, func);
    }


}
