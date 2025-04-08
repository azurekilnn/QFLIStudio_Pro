package com.luastudio.azure.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import com.androlua.LuaContext;
import com.luajava.LuaException;
import com.luajava.LuaFunction;
import com.luajava.LuaObject;
import com.luajava.LuaTable;
import com.luastudio.azure.util.LuaToast;

public class LuaBaseAdapter extends BaseAdapter {

    public LuaContext mContext;
    public LuaTable   mTable;

    public LuaBaseAdapter(LuaContext a, LuaTable t) {
        mContext = a;
        mTable   = t;
        init();
    }

    public void init() {
        if (mTable != null) {
            String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
            try {
                LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
                if (!mTableValue.isNil()) {
                    if (mTableValue.isFunction()) {

                        LuaFunction mFunction = mTableValue.getFunction();
                        //需要传入的参数
                        mFunction._call(this);

                    } else {
                        throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
                    }
                }
            } catch (Exception e) {
                mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
            }
        }
    }


    @Override
    public int getCount() {
        if (mTable != null) {
            String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
            try {
                LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
                if (!mTableValue.isNil()) {
                    if (mTableValue.isFunction()) {

                        LuaFunction mFunction = mTableValue.getFunction();
                        //需要传入的参数
                        return (int) mFunction._call(this).getNumber();

                    } else {
                        throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
                    }
                }
            } catch (Exception e) {
                mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
            }
        }
        return 0;
    }


    @Override
    public Object getItem(int p1) {
        if (mTable != null) {
            String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
            try {
                LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
                if (!mTableValue.isNil()) {
                    if (mTableValue.isFunction()) {

                        LuaFunction mFunction = mTableValue.getFunction();
                        //需要传入的参数
                        return mFunction._call(p1, this).getObject();

                    } else {
                        throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
                    }
                }
            } catch (Exception e) {
                mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
            }
        }
        return null;
    }

    @Override
    public View getView(int p1, View p2, ViewGroup p3) {
        if (mTable != null) {
            String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
            try {
                LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
                if (!mTableValue.isNil()) {
                    if (mTableValue.isFunction()) {

                        LuaFunction mFunction = mTableValue.getFunction();
                        //需要传入的参数
                        Object o = mFunction._call(p1, p2, p3, this).getObject();

                        return (View) o; 

                    } else {
                        throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
                    }
                }
            } catch (Exception e) {
                mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
            }
        }
        return new TextView((Context) mContext);
    }

    @Override
    public long getItemId(int p1) {
        if (mTable != null) {
            String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
            try {
                LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
                if (!mTableValue.isNil()) {
                    if (mTableValue.isFunction()) {

                        LuaFunction mFunction = mTableValue.getFunction();
                        //需要传入的参数
                        return (long) mFunction._call(p1, this).getNumber();

                    } else {
                        throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
                    }
                }
            } catch (Exception e) {
                mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
            }
        }
        return p1;
    }
}