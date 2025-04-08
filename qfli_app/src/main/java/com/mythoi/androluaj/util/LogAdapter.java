package com.mythoi.androluaj.util;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;
import java.util.List;
import android.text.Html;
import android.util.Log;

public class LogAdapter<T extends Object> extends ArrayAdapter
{

  private Context context;

  private List<T> list;
  
  private int layoutID;
  
  private int curColor;
  public LogAdapter(Context context,int layoutID,List<T> list)
  {
    super(context,layoutID,list);
    this.list=list;
    this.layoutID=layoutID;
    this.context=context;
    View view=LayoutInflater.from(context).inflate(layoutID, null);
    TextView tv=((TextView)view);
    curColor= tv.getCurrentTextColor();    
  }


  @Override
  public View getView(int position, View convertView, ViewGroup parent)
  {
    // TODO: Implement this method
    if(convertView ==null)
    {
      convertView = LayoutInflater.from(context).inflate(layoutID, null);
    }
    String str2=list.get(position).toString();
    TextView tv=((TextView)convertView);
    if(str2.contains("System.out")||str2.contains("I/art")||str2.contains("/Timeline")){
      tv.setTextColor(0xff4CBD1F);
    }
     else if(str2.contains("System.err")||str2.contains("AndroidRuntime")||str2.contains("IInputConnectionWrapper")||str2.contains("W/art"))
    {
      tv.setTextColor(0xffff0000);
    }else if(str2.contains(" D ")&&str2.contains("     :"))
    { 
      tv.setTextColor(0xff7228A8);
    }else if(str2.contains(" E ")&&str2.contains("     :"))
    {
      tv.setTextColor(0xffff0000);
    }else if(str2.contains(" I ")&&str2.contains("     :"))
    {
      tv.setTextColor(0xff3DDEE4);
    }else if(str2.contains(" V ")&&str2.contains("     :"))
    {
      tv.setTextColor(0xff2585F0);
    }else if(str2.contains(" W ")&&str2.contains("     :"))
    {
      tv.setTextColor(0xffDFD511);
    } else{
      tv.setTextColor(curColor);
    }
    return super.getView(position, convertView, parent);
  }


}
