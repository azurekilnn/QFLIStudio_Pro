package com.mythoi.androluaj.util;
import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class LogCatReceiver extends BroadcastReceiver
{
  public static boolean isStop=false;
  @SuppressLint("SuspiciousIndentation")
  public void onReceive(Context context, Intent intent) {
    if("com.adrt.SENDLOG".equals(intent.getAction())&&!isStop)
    {
      String log=intent.getStringExtra("logLine");
      Utils.mArrayList.add(log);
      //接口回调
      if(A.notify!=null)
      A.notify.getNotify(log);
    }
  }
}



