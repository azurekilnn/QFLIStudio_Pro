package com.mythoi.androluaj.util;

import android.annotation.SuppressLint;

import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import java.io.File;
import com.luajava.LuaException;
import com.luajava.LuaTable;
import java.util.Set;

public class DealClasses
{


  @SuppressLint("SuspiciousIndentation")
  public String deal(String projectPath){

    try
    {

      LuaState L=LuaStateFactory.newLuaState();
      int k= L.LdoFile(projectPath+"/src/classes.lua");
      if (k != 0 && new File(projectPath+"/src/classes.lua").exists())
      throw new LuaException("Syntax error");
      L.getGlobal("classes");
      LuaTable luaTable= (LuaTable) L.toJavaObject(-1);

      if (luaTable != null)
      { 

        Set<String> set= luaTable.keySet();
        for (String className:set)
        {
          StringBuffer strbuf=new StringBuffer();
          //类表
          LuaTable luaTable2= (LuaTable) luaTable.get(className); 
          makeAllCode(strbuf, luaTable2, className, false);
          // fileUitl.write(strbuf.toString() + "\n\n}", "sdcard/mixture/" + className + ".java");
          FileUtil.write(strbuf.toString() + "\n\n}", projectPath + "/_src/com/mythoi/classes/" + className + ".java");
        }

      }//判断luatable是否为空结束
      return "构建成功";
    }
    catch (Exception e)
    {


      return "构建错误: classes.lua配置出错！" + e;


    }

  }



  private void makeAllCode(StringBuffer strbuf, LuaTable luaTable, String className, boolean isInerClass) throws Exception
  {
    //用户方法表
    LuaTable luaTable3=(LuaTable) luaTable.get("method");
    //获取继承的完整类名
    String mSuper=luaTable.get("super").toString().replace("$", ".").replace(" ", "");
    //获取继承的类名
    String superName=new File(mSuper.replace(".", "/")).getName();
    Set<String> methodSet=luaTable3.keySet();
    //=========初始化代码start================ 
    if (!isInerClass)
    {//如果不是内部类
      if (mSuper.equals(""))
      {//如果没有继承
        strbuf.append("package com.mythoi.classes;\n import com.luajava.*;\n import com.androlua.LuaActivity;\n public class " + className + " {\n private LuaTable luaTableX;\n"); 
      }
    else
      {//如果有继承

        if (superName.contains("Activity") || mSuper.contains("SerVice") || mSuper.contains("BroadcastReceiver"))
        {
          strbuf.append("package com.mythoi.classes;\n import com.luajava.*;\n import com.androlua.LuaActivity;\n public class " + className + " extends " + mSuper + " {\n private static LuaTable luaTableX;\n"); 
          strbuf.append(" public static Class init(LuaTable luaTable){\n luaTableX=luaTable;luaTable.setField(\"class\","+className+".class); return "+className+".class;\n}\n"); 
        }
      else
        { 
          strbuf.append("package com.mythoi.classes;\n import com.luajava.*;\n import com.androlua.LuaActivity;\n public class " + className + " extends " + mSuper + " {\n private LuaTable luaTableX;\n"); 
        }

      } 
    }
  else
    {//如果是内部类
      if (mSuper.equals(""))
      {//如果没有继承
        strbuf.append("public class " + className + " {\n"); 
      }
    else
      {
        strbuf.append("public class " + className + " extends " + mSuper + " {\n"); 
      }

    }
    //===========初始化代码end===============

    for (String method:methodSet)
    {

      //========获取方法的信息=start===========
      String methodInfo=luaTable3.get(method).toString().replace("$", ".").replace(" ", "");
      String stts[]=methodInfo.split(",");//方法信息数组
      String cpp="";//构造方法的完整参数，含类型和变量
      String cp="";//构造方法不完整参数，含变量
      String pp="";//完整的参数，含变量和类型
      String p="";//不完整的参数，含变量
      String r=stts[0];//返回值
      if (r.equals(""))
      r = "void";
      for (int i=0;i < stts.length;i++)
      {
        if (!stts[i].equals(""))
        {
          if (i == stts.length - 1)
          { 
            cpp += stts[i] + " a" + i; 
            cp += "a" + i; 
            if (i != 0)
            {
              pp += stts[i] + " a" + i; 
              p += "a" + i; 
            }
          }
        else
          { 
            cpp += stts[i] + " a" + i + ",";
            cp += "a" + i + ","; 
            if (i != 0)
            {
              pp += stts[i] + " a" + i + ",";
              p += "a" + i + ","; 
            } 
          }
        }
      } 

      if(mSuper.equals("")&&(r.contains("@")||r.contains("#")))//如果没有继承
      {
        throw new Exception(className+"类没有继承父类，不能使用@和#操作，请去除");

      }

      //=============获取方法信息end=====================
      if (method.equals(className))
      {//如果是构造方法

        if (!isInerClass)
        {
          if (cpp.equals(""))
          {//如果构造方法没参数 
            if (!(superName.contains("Activity") || mSuper.contains("SerVice") || mSuper.contains("BroadcastReceiver")))
            {
              strbuf.append(" public static " + className + "  init(LuaTable luaTable){\n return new " + className + "(luaTable);\n}\n"); 
            }
            cpp = "LuaTable luaTable";
          }
        else
          {
            cpp += ",LuaTable luaTable";
          }

          if (!mSuper.equals(""))
          {//是继承
            String st="public " + className.toString() + "(" + cpp + "){\n super(" + cp + ");\n this.luaTableX=luaTable; \n" + makeCFuncCode(className.toString(), cp, false) + " \n}\n";
            strbuf.append(st);
          }
        else
          {
            String st="public " + className.toString() + "(" + cpp + "){\n this.luaTableX=luaTable; \n" + makeCFuncCode(className.toString(), cp, false) + " \n}\n";
            strbuf.append(st);
          }
        }
      else
        {
          if (!mSuper.equals(""))
          {//是继承
            String st="public " + className.toString() + "(" + cpp + "){\n super(" + cp + ");\n" + makeCFuncCode(className.toString(), cp, true) + " \n}\n";
            strbuf.append(st); 
          }
        else
          {
            String st="public " + className.toString() + "(" + cpp + "){\n" + makeCFuncCode(className.toString(), cp, true) + " \n}\n";
            strbuf.append(st); 
          }
        }
      }
    else if (r.contains("@"))
      {//如果是重写方法(返回值含@)
        String st="public " + r.replace("@", "") + " " + method + "(" + pp + "){\n" + makeFuncCode(method, r.replace("@", ""), p,isInerClass) + "}\n";
        strbuf.append(st); 
      }
    else if (r.contains("#"))
      {//如果protected方法转public方法
        if (r.replace("#", "").equals("") || r.replace("#", "").equals("void"))
        {
          String st="public void  _" + method + "(" + pp + "){\n  this." + method + "(" + p + ");\n }\n";
          strbuf.append(st);
        }
      else
        {

          String st="public " + r.replace("#", "") + " _" + method + "(" + pp + "){\n return this." + method + "(" + p + ");\n  }\n";
          strbuf.append(st);
        }
      }
    else
      {//如果是普通方法
        String st="public " + r + " " + method + "(" + pp + "){\n" + makeZFuncCode(method, r, p,isInerClass) + "}\n";
        strbuf.append(st); 
      }

    } 



    //============================开始构造内部类===============
    Set<String> inerClassSet=luaTable.keySet();
    inerClassSet.remove("super");
    inerClassSet.remove("method"); 
    for (String inerClass:inerClassSet)
    {

      LuaTable luaTable4=(LuaTable) luaTable.get(inerClass);
      //递归
      makeAllCode(strbuf, luaTable4, inerClass, true); 

      strbuf.append("\n}\n");
    }
    //==================结束构造内部类======================

  } 






  private String makeCFuncCode(String funName, String funVar, boolean isInerClass)
  { 
    StringBuffer strb=new StringBuffer();
    strb.append("try{\n");
    if (!isInerClass)
    {
      strb.append("luaTable.setField(\"this\",this);\n");
      strb.append("luaTable.setField(\"class\",getClass());\n");
    }
    strb.append("LuaFunction luaFunc=(LuaFunction)luaTableX.get(\"" + funName + "\");\n");
    strb.append("if(luaFunc==null){\n throw new Exception(\"Runtime error：lua表中未声明<<" + funName + ">>函数\");\n }");
    strb.append("luaFunc.__call(new Object[]{" + funVar + "});");
    strb.append("}catch(Exception e){try{LuaState L=luaTableX.getLuaState();L.getGlobal(\"activity\"); \n LuaActivity luaActivity=(LuaActivity) L.toJavaObject(-1);\n com.androlua.Util.showError(luaActivity,com.androlua.ShowErrorActivity.class,\" Java回调的<<"+funName+">>Lua函数里有错误：\"+e.toString());luaActivity.finish();  System.exit(0);}catch(Exception ee){}}");
    return strb.toString();
  }

  private String makeFuncCode(String funName, String strReturn, String funVar, boolean isInerClass)
  {
    StringBuffer strb=new StringBuffer();
    strb.append("Object tmp=null;\n"); 
    if (!strReturn.equals("void"))
    strb.append("tmp=super." + funName + "(" + funVar + ");\n");
  else
    strb.append("super." + funName + "(" + funVar + ");\n"); 
    strb.append("Object obj=new Object();\n");
    strb.append("try{\n");
    if (!isInerClass)
    {
      strb.append("if(((LuaObject)luaTableX.getField(\"this\")).isNil()||((LuaObject)luaTableX.getField(\"class\")).isNil()){\n");
      strb.append("luaTableX.setField(\"this\",this);\n");
      strb.append("luaTableX.setField(\"class\",getClass());}\n");
    }
    strb.append("LuaFunction luaFunc=(LuaFunction)luaTableX.get(\"" + funName + "\");\n");
    strb.append("if(luaFunc==null){\n throw new Exception(\"Runtime error：lua表中未声明<<" + funName + ">>函数\");\n }");
    strb.append("obj=luaFunc.__call(new Object[]{" + funVar + "});\n");
    strb.append("}catch(Exception e){try{LuaState L=luaTableX.getLuaState();L.getGlobal(\"activity\"); \n LuaActivity luaActivity=(LuaActivity) L.toJavaObject(-1);\n com.androlua.Util.showError(luaActivity,com.androlua.ShowErrorActivity.class,\" Java回调的<<"+funName+">>Lua函数里有错误：\"+e.toString()); luaActivity.finish();  System.exit(0);}catch(Exception ee){}}");
    if (!strReturn.equals("void"))
    {
      strb.append("if(obj==null) return (" + strReturn + ")tmp; \n else \n return (" + strReturn + ")obj;");

    }
    return strb.toString();
  }



  private String makeZFuncCode(String funName, String strReturn, String funVar,boolean isInerClass)
  {
    StringBuffer strb=new StringBuffer();
    strb.append("Object obj=null;\n");
    strb.append("try{\n");
    if (!isInerClass)
    {
      strb.append("if(((LuaObject)luaTableX.getField(\"this\")).isNil()||((LuaObject)luaTableX.getField(\"class\")).isNil()){\n");
      strb.append("luaTableX.setField(\"this\",this);\n");
      strb.append("luaTableX.setField(\"class\",getClass());}\n");
    }
    strb.append("LuaFunction luaFunc=(LuaFunction)luaTableX.get(\"" + funName + "\");\n");
    strb.append("if(luaFunc==null){\n throw new Exception(\"Runtime error：lua表中未声明<<" + funName + ">>函数\");\n }");
    strb.append("obj=luaFunc.__call(new Object[]{" + funVar + "});\n");
    strb.append("}catch(Exception e){try{LuaState L=luaTableX.getLuaState();L.getGlobal(\"activity\"); \n LuaActivity luaActivity=(LuaActivity) L.toJavaObject(-1);\n com.androlua.Util.showError(luaActivity,com.androlua.ShowErrorActivity.class,\" Java回调的<<"+funName+">>Lua函数里有错误：\"+e.toString()); luaActivity.finish(); System.exit(0);}catch(Exception ee){}}");
    if (!(strReturn.equals("void") || strReturn.equals("")))
    strb.append("return (" + strReturn + ")obj;");
    return strb.toString();

  }

}