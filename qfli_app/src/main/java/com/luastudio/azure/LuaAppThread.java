package com.luastudio.azure;

import android.os.Looper;

import com.androlua.LuaActivity;
import com.androlua.LuaContext;
import com.androlua.LuaPrint;
import com.androlua.LuaService;
import com.luajava.JavaFunction;
import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;

public class LuaAppThread extends com.androlua.LuaThread {

    public LuaAppThread(LuaContext luaContext, String src) throws LuaException {
        super(luaContext, src, false, null);
    }

    public LuaAppThread(LuaContext luaContext, String src, Object[] arg) throws LuaException {
        super(luaContext, src, false, arg);
    }

    public LuaAppThread(LuaContext luaContext, String src, boolean isLoop) throws LuaException {
        super(luaContext, src, isLoop, null);
    }

    public LuaAppThread(LuaContext luaContext, String src, boolean isLoop, Object[] arg) throws LuaException {
        super(luaContext, src, isLoop, arg);
    }
    public LuaAppThread(LuaContext luaContext, LuaObject func) throws LuaException {
        super(luaContext, func, false, null);
    }
    public LuaAppThread(LuaContext luaContext, LuaObject func, Object[] arg) throws LuaException {
        super(luaContext, func, false, arg);
    }
    public LuaAppThread(LuaContext luaContext, LuaObject func, boolean isLoop) throws LuaException {
        super(luaContext, func, isLoop, null);
    }

    public LuaAppThread(LuaContext luaContext, LuaObject func, boolean isLoop, Object[] arg) throws LuaException {
       super(luaContext, func, isLoop, arg);
    }

    @Override
    public void run() {
        try {

            if (L == null) {
                initLua();

                if (mBuffer != null)
                    newLuaThread(mBuffer, mArg);
                else
                    newLuaThread(mSrc, mArg);
            }
        }
        catch (LuaException e) {
            mLuaContext.sendError(this.toString(), e);
            return;
        }
        if (mIsLoop) {
            Looper.prepare();
            thandler = new ThreadHandler();
            isRun = true;
            L.getGlobal("run");
            if (!L.isNil(-1)) {
                L.pop(1);
                runFunc("run");
            }

            Looper.loop();
        }
        isRun = false;
        L.gc(LuaState.LUA_GCCOLLECT, 1);
        System.gc();
        return ;
    }

    private void initLua() throws LuaException {
        L = LuaStateFactory.newLuaState();
        L.openLibs();
        L.pushJavaObject(mLuaContext.getContext());
        if (mLuaContext instanceof LuaActivity) {
            L.setGlobal("activity");
        } else if (mLuaContext instanceof LuaService) {
            L.setGlobal("service");
        } else {
            L.setGlobal("activity");
        }
        L.pushJavaObject(this);
        L.setGlobal("this");
        L.pushContext(mLuaContext);

        JavaFunction print = new LuaPrint(mLuaContext, L);
        print.register("print");

        L.getGlobal("package");

        L.pushString(mLuaContext.getLuaLpath());
        L.setField(-2, "path");
        L.pushString(mLuaContext.getLuaCpath());
        L.setField(-2, "cpath");
        L.pop(1);

        JavaFunction set = new JavaFunction(L) {
            @Override
            public int execute() {

                mLuaContext.set(L.toString(2), L.toJavaObject(3));
                return 0;
            }
        };
        set.register("set");

        JavaFunction call = new JavaFunction(L) {
            @Override
            public int execute() {

                int top=L.getTop();
                if (top > 2) {
                    Object[] args = new Object[top - 2];
                    for (int i=3;i <= top;i++) {
                        args[i - 3] = L.toJavaObject(i);
                    }
                    mLuaContext.call(L.toString(2), args);
                }
                else if (top == 2) {
                    mLuaContext.call(L.toString(2));
                }
                return 0;
            }
        };
        call.register("call");
    }

}
