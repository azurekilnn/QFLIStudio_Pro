package com.mythoi.androluaj.util;

public class A
{

  public static NotifyListener notify;

  public void setNotifyListener(NotifyListener notify){
    this.notify=notify;
  }

  public interface NotifyListener{
    public void getNotify(String curLogLine);
  }


}
