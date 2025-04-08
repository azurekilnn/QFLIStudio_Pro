package com.luastudio.azure;

import android.os.Bundle;
import android.content.Intent;
import com.androlua.*;
import com.androlua.Main;
import com.qflistudio.azure.R;

import android.app.Activity;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.io.InputStreamReader;
import java.io.BufferedReader;

public class StartInterface extends Activity {
    //根据init.lua中的welcome_time获取启动时间
    public int getWelcomeTime() {
        String config = getFromAssets("init.lua");
        try {
            Pattern pattern = Pattern.compile("welcome_time=\"(.*?)\"");
            Matcher matcher = pattern.matcher(config);

            while (matcher.find()) {
                String e = matcher.group(1);
                return Integer.valueOf(e);
            }

            return Integer.valueOf(0);
        } catch (Exception e) {
            return 1000;
        }
	}

    public String getFromAssets(String fileName) { 
        try { 
            InputStreamReader inputReader = new InputStreamReader(getResources().getAssets().open(fileName)); 
            BufferedReader bufReader = new BufferedReader(inputReader);
            String line="";
            String result = "";
            while ((line = bufReader.readLine()) != null)
                result += line;
            return result;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return "配置文件异常";
        }
	}
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.welcome);
        
        new Thread() {
            @Override
            public void run() {
                try {
                    Thread.sleep((long) getWelcomeTime());
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                Intent intent = new Intent();
                try {
                    intent.setClass(StartInterface.this, Class.forName("com.androlua.Welcome"));
                    startActivity(intent);
                    overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                    new Thread() {
                        @Override
                        public void run() {
                            try {
                                Thread.sleep((long) 500);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                            finish();
                        }
                    }.start();
                } catch (ClassNotFoundException e_2) {
                    throw new NoClassDefFoundError(e_2.getMessage());
                }
            }
        }.start();
    };
}

