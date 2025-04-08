package com.luastudio.azure.util;

import android.content.Context;
import android.widget.Toast;

import com.luastudio.azure.LuaApplication;

public class LuaToast {

    public Context mContext = LuaApplication.mApp.getApplicationContext();
    

    /**
     * 在Java或者Lua程序中，调用系统显示字符串
     *
     * @param o Java对象
     *
     * @return null
     */
    public LuaToast(Object o) {

        Toast.makeText(mContext, o.toString(), Toast.LENGTH_LONG).show();

    }

}
