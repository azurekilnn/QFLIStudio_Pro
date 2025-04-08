package com.luastudio.azure.executor;

import android.content.Context;

import com.androlua.LuaContext;
import com.androlua.util.AsyncTaskX;
import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class LuaExecutor {
    private ExecutorService executorService;

    private Object[] loadeds;
    private boolean mGc;

    private LuaState L;

    private LuaContext mLuaContext;

    private byte[] mBuffer;

    private long mDelay=0;

    private LuaObject mCallback;

    private LuaObject mUpdate;

    public LuaExecutor() {
        // 创建一个单线程的线程池
        executorService = Executors.newSingleThreadExecutor();
    }

    public void execute(Runnable task) {
        // 提交任务给 ExecutorService
        executorService.execute(task);
    }



    public void shutdown() {
        // 关闭 ExecutorService
        executorService.shutdown();
    }
}
