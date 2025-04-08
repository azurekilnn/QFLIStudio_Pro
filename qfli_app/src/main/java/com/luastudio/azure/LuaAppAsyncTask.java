package com.luastudio.azure;

import com.androlua.LuaActivity;
import com.androlua.LuaContext;
import com.androlua.LuaPrint;
import com.androlua.LuaService;
import com.luajava.JavaFunction;
import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;

public class LuaAppAsyncTask extends com.androlua.LuaAsyncTask {

    private final LuaContext mLuaContext;

    public LuaAppAsyncTask(LuaContext luaContext, long delay, LuaObject callback) throws LuaException {
        super(luaContext, delay, callback);
        mLuaContext = luaContext;
    }

    public LuaAppAsyncTask(LuaContext luaContext, String src, LuaObject callback) throws LuaException {
        super(luaContext, src, callback);
        mLuaContext = luaContext;
    }

    public LuaAppAsyncTask(LuaContext luaContext, LuaObject func, LuaObject callback) throws LuaException {
        super(luaContext, func, callback);
        mLuaContext = luaContext;
    }

    public LuaAppAsyncTask(LuaContext luaContext, LuaObject func, LuaObject update, LuaObject callback) throws LuaException {
        super(luaContext, func, update, callback);
        mLuaContext = luaContext;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        // 任务开始前的自定义逻辑
        System.out.println("MyLuaAsyncTask 开始执行");
    }

    @Override
    protected void onPostExecute(Object result) {
        super.onPostExecute(result);
        // 任务完成后的自定义逻辑
        System.out.println("MyLuaAsyncTask 执行完成，结果: " + result);
    }

    @Override
    protected Object doInBackground(Object[] args) {
        if (mDelay != 0) {
            try {
                Thread.sleep(mDelay);
            }
            catch (InterruptedException e) {}
            return args;
        }
        L = LuaStateFactory.newLuaState();
        L.openLibs();
        L.pushJavaObject(mLuaContext);
        if (mLuaContext instanceof LuaActivity) {
            L.setGlobal("activity");
        }
        else if (mLuaContext instanceof LuaAppActivity) {
            L.setGlobal("activity");
        }
        else if (mLuaContext instanceof LuaService) {
            L.setGlobal("service");
        }
        L.pushJavaObject(this);
        L.setGlobal("this");
        L.pushContext(mLuaContext);

        L.getGlobal("luajava");
        L.pushString(mLuaContext.getLuaDir());
        L.setField(-2, "luadir");
        L.pop(1);

        try {
            JavaFunction print = new LuaPrint(mLuaContext, L);
            print.register("print");

            JavaFunction update = new JavaFunction(L){

                @Override
                public int execute() {
                    // TODO: Implement this method
                    update(L.toJavaObject(2));
                    return 0;
                }
            };

            update.register("update");

            L.getGlobal("package");

            L.pushString(mLuaContext.getLuaLpath());
            L.setField(-2, "path");
            L.pushString(mLuaContext.getLuaCpath());
            L.setField(-2, "cpath");
            L.pop(1);
        }
        catch (Exception e) {
            mLuaContext.sendError("AsyncTask", e);
        }

        if(loadeds!=null){
            LuaObject require=L.getLuaObject("require");
            try {
                require.call("import");
                LuaObject _import=L.getLuaObject("import");
                for(Object s:loadeds)
                    _import.call(s.toString());
            }
            catch (Exception e) {

            }
        }

        try {
            L.setTop(0);
            int ok = L.LloadBuffer(mBuffer, "LuaAsyncTask");

            if (ok == 0) {
                L.getGlobal("debug");
                L.getField(-1, "traceback");
                L.remove(-2);
                L.insert(-2);
                int l=args.length;
                for (int i=0;i < l;i++) {
                    L.pushObjectValue(args[i]);
                }
                ok = L.pcall(l, LuaState.LUA_MULTRET, -2 - l);
                if (ok == 0) {
                    int n=L.getTop() - 1;
                    Object[] ret=new Object[n];
                    for (int i=0;i < n;i++)
                        ret[i] = L.toJavaObject(i + 2);
                    return ret;
                }
            }
            throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
        }
        catch (LuaException e) {
            mLuaContext.sendError("doInBackground", e);
        }


        return null;
    }
}
