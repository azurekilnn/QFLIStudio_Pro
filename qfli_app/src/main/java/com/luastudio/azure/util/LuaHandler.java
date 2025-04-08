package com.luastudio.azure.util;

import android.os.*;
import java.io.*;
import com.androlua.*;
import com.luajava.*;

public class LuaHandler extends Handler
{

	private LuaContext mContext;
	private LuaTable mTable;
	
	public LuaHandler(LuaContext a,LuaTable t){
		mContext = a;
		mTable = t;
	}
	
	@Override
	public void handleMessage(Message msg)
	{
		super.handleMessage(msg);
		if (mTable != null)
		{
			String NOW_METHOD_NAME = Thread.currentThread() .getStackTrace()[2].getMethodName();
			try
			{
				LuaObject mTableValue = mTable.getField(NOW_METHOD_NAME);
				if (!mTableValue.isNil())
				{
					if (mTableValue.isFunction())
					{
						LuaFunction mFunction = mTableValue.getFunction();
						//需要传入的参数
						mFunction.call(msg,this);
					}
					else
					{
						throw new LuaException("\n" + NOW_METHOD_NAME + "不是一个function");
					}
				}
			}
			catch (Exception e)
			{
				mContext.sendError(this.getClass() + "的" + NOW_METHOD_NAME + "方法异常", e);
			}
		}
	}
}
