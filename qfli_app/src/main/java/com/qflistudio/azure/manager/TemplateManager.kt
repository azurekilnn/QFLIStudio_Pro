class TemplateManager {

    companion object {
        val mainCTemplate = """#include<stdio.h>
            
int main() {
    printf("HelloWorld");
    return 0;
}
            
        """
        val mainCppTemplate = """#include <iostream>

// TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
int main() {
    // TIP Press <shortcut actionId="RenameElement"/> when your caret is at the
    // <b>lang</b> variable name to see how CLion can help you rename it.
    auto lang = "C++";
    std::cout << "Hello and welcome to " << lang << "!\n";

    for (int i = 1; i <= 5; i++) {
        // TIP Press <shortcut actionId="Debug"/> to start debugging your code.
        // We have set one <icon src="AllIcons.Debugger.Db_set_breakpoint"/>
        // breakpoint for you, but you can always add more by pressing
        // <shortcut actionId="ToggleLineBreakpoint"/>.
        std::cout << "i = " << i << std::endl;
    }

    return 0;
}

// TIP See CLion help at <a
// href="https://www.jetbrains.com/help/clion/">jetbrains.com/help/clion/</a>.
//  Also, you can try interactive lessons for CLion by selecting
//  'Help | Learn IDE Features' from the main menu."""
        val mainPyTemplate = """# 这是一个示例 Python 脚本。

def print_hi(name):
    print(f'Hi, {name}') 

# 按装订区域中的绿色按钮以运行脚本。
if __name__ == '__main__':
    print_hi('QFLIStudio')

"""

        val newPyTemplate = """# 这是一个示例 Python 脚本。

print(f'Hi, {name}') 

"""

        // 存储不同模板的字符串
        val stringsTemplate = """<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">%s</string>
</resources>"""
val mainJavaTemplate = """public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}"""

        val mainAndroidJavaTemplate = """package %s;
import android.app.*;
import android.os.*;
public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);      
    }
}"""

        val mainContentTemplate = """require "import"
require "Azure"  
--require "chinese_funlib"--中文函数库，如需要使用请去除该行注释
import "androidx.appcompat.widget.*"
import "androidx.appcompat.app.*"
import "androidx.appcompat.view.*"
activity.setTitle("%s")
activity.setTheme(Theme_LuaStudio)
activity.setContentView(loadlayout("layout"))"""

        val newLuaTemplate = """require "import"
require "Azure"  
--require "chinese_funlib"--中文函数库，如需要使用请去除该行注释
import "androidx.appcompat.widget.*"
import "androidx.appcompat.app.*"
import "androidx.appcompat.view.*"
activity.setTitle("%s")
activity.setTheme(Theme_LuaStudio)"""

        val newMainContentTemplate = """require "system"
activity.setTitle("LuaStudio+")
activity.setTheme(R.style.Theme_LuaStudio)
%s"""

        val alyContentTemplate = """{
    LinearLayoutCompat;
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    {
        AppCompatTextView;
        layout_height="fill";
        gravity="center";
        layout_gravity="center";
        text="%s";
        textSize="18sp";
        layout_width="fill";
    };
};"""

        val buildLsInfoTemplate = """build_info={
    appname="%s",
    appver="1.0",
    appcode="1",
    appsdk="21",
    template="%s",
    packagename="%s",
}
user_permission={
    "INTERNET",
    "WRITE_EXTERNAL_STORAGE"
}"""

        val initLuaTemplate = """appname="%s"
debugmode=true"""

        val setLayoutCode = """activity.setContentView(loadlayout("layout"))"""

        val androidManifestTemplate = """<?xml version="1.0" encoding="utf-8"?>
<manifest
     xmlns:android="http://schemas.android.com/apk/res/android"
     xmlns:tools="http://schemas.android.com/tools"
     
     android:versionCode="1"
     android:versionName="1.0"
     
     package="%s">

     <uses-sdk
     android:minSdkVersion="21"
     android:targetSdkVersion="26"/>

     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   
     <application android:icon="@drawable/icon"
     android:label="@string/app_name"
     android:largeHeap="true"
     android:persistent="true"
     android:name="com.androlua.LuaApplication">
     
     <activity 
         android:name="com.androlua.Main"
         android:label="@string/app_name"
         android:theme="@android:style/Theme.Holo.Light.NoActionBar"
         android:launchMode="singleTask"
         android:screenOrientation="portrait"
         android:configChanges="orientation|screenSize|keyboardHidden">
     </activity>
     
     <activity 
         android:name="com.androlua.LuaActivity"
         android:label="@string/app_name"
         android:theme="@android:style/Theme.Holo.Light.NoActionBar"
         android:screenOrientation="portrait"
         android:configChanges='orientation|screenSize|keyboardHidden'>
     </activity>
     
     <activity
         android:name="com.androlua.Welcome"
         android:label="@string/app_name"
         android:theme="@style/welcome_theme"
         android:screenOrientation="portrait" >
         <intent-filter>
             <action android:name="android.intent.action.MAIN"/>
             <category android:name="android.intent.category.LAUNCHER"/>
         </intent-filter>
     </activity>
     
     <service
         android:name="com.androlua.LuaService"
         android:enabled="true" >
     </service>
     
 </application>
</manifest>"""
    }

    fun getMainTemplate(projectType: String): String {
        if (projectType == "common_lua" || projectType == "lua_java") {
            return mainContentTemplate
        } else if (projectType == "python") {
            return mainPyTemplate
        } else if (projectType == "c") {
            return mainCTemplate
        } else if (projectType == "cpp") {
            return mainCppTemplate
        } else if (projectType == "java") {
            return mainJavaTemplate
        } else {
            return ""
        }
    }

    fun getFileTemplate(fileType: String): String {
        if (fileType == "lua") {
            return newLuaTemplate
        } else if (fileType == "aly") {
            return alyContentTemplate
        } else if (fileType == "java") {
            return ""
        } else if (fileType == "xml") {
            return ""
        } else if (fileType == "py") {
            return newPyTemplate
        } else if (fileType == "c") {
            return mainCTemplate
        } else if (fileType == "cpp") {
            return mainCppTemplate
        } else if (fileType == "html") {
            return ""
        } else if (fileType == "css") {
            return ""
        } else if (fileType == "txt") {
            return ""
        } else if (fileType == "md") {
            return ""
        } else {
            return ""
        }
    }

    // 可以在这里定义方法获取模板，方便调用
    fun getStringsTemplate(appName: String): String {
        return stringsTemplate.format(appName)
    }

    fun getMainContentTemplate(appName: String): String {
        return mainContentTemplate.format(appName)
    }

    fun getAlyTemplate(appName: String): String {
        return alyContentTemplate.format(appName)
    }

    fun getInitLuaTemplate(appName: String): String {
        return initLuaTemplate.format(appName)
    }

    fun getMainJavaTemplate(packageName: String): String {
        return mainAndroidJavaTemplate.format(packageName)
    }

    fun getBuildLsInfoTemplate(appName: String, packageName: String, template: String): String {
        return buildLsInfoTemplate.format(appName, template, packageName)
    }

    fun getAndroidManifestTemplate(packageName: String): String {
        return androidManifestTemplate.format(packageName)
    }
}
