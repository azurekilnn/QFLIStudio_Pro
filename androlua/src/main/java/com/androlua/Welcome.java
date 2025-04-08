package com.androlua;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.NonNull;

import androidx.annotation.RequiresApi;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;


public class Welcome extends Activity {

    public static Activity activity;

    public boolean isUpdata;

    public LuaApplication app;

    public long mLastTime;

    public long mOldLastTime;

    public boolean isVersionChanged;

    public String mVersionName;

    public String mOldVersionName;

    public ArrayList<String> permissions;



    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        activity = this;

        activity.getWindow().setStatusBarColor(0xFFFAFAFA);



        //安装解压
        if (checkInfo()) {
            if (Build.VERSION.SDK_INT >= 23) {
                try {
                    permissions = new ArrayList<String>();
                    String[] ps2 = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_PERMISSIONS).requestedPermissions;
                    for (String p : ps2) {
                        try {
                            checkPermission(p);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    if (!permissions.isEmpty()) {
                        String[] ps = new String[permissions.size()];
                        permissions.toArray(ps);
                        requestPermissions(ps,
                                0);
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            new UpdateTask().execute();

        } else {

            startActivity();

        }





    }


    //延迟启动
    public void startActivity() {
        new Handler().postDelayed(new Runnable() {
            public void run() {
                Intent intent = new Intent(Welcome.this, Main.class);
                if (isVersionChanged) {
                    intent.putExtra("isVersionChanged", isVersionChanged);
                    intent.putExtra("newVersionName", mVersionName);
                    intent.putExtra("oldVersionName", mOldVersionName);
                }
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
            }
        }, getWelcomeTime());
    }


    public boolean checkInfo() {
        try {
            PackageInfo packageInfo = getPackageManager().getPackageInfo(this.getPackageName(), 0);
            long lastTime = packageInfo.lastUpdateTime;
            String versionName = packageInfo.versionName;
            SharedPreferences info = getSharedPreferences("appInfo", 0);
            String oldVersionName = info.getString("versionName", "");
            if (!versionName.equals(oldVersionName)) {
                SharedPreferences.Editor edit = info.edit();
                edit.putString("versionName", versionName);
                edit.apply();
                isVersionChanged = true;
                mVersionName = versionName;
                mOldVersionName = oldVersionName;
            }
            long oldLastTime = info.getLong("lastUpdateTime", 0);
            if (oldLastTime != lastTime) {
                SharedPreferences.Editor edit = info.edit();
                edit.putLong("lastUpdateTime", lastTime);
                edit.apply();
                isUpdata = true;
                mLastTime = lastTime;
                mOldLastTime = oldLastTime;
                return true;
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return false;
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
            return 0;
        }
    }

    private void checkPermission(String permission) {
        if (checkCallingOrSelfPermission(permission)
                != PackageManager.PERMISSION_GRANTED) {
            permissions.add(permission);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        new UpdateTask().execute();
    }


    public void pr() {
        if (Build.VERSION.SDK_INT >= 23) {
            try {
                permissions = new ArrayList<String>();
                String[] ps2 = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_PERMISSIONS).requestedPermissions;
                for (String p : ps2) {
                    try {
                        checkPermission(p);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (!permissions.isEmpty()) {
                    String[] ps = new String[permissions.size()];
                    permissions.toArray(ps);
                    requestPermissions(ps,
                            0);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }


    // @SuppressLint("StaticFieldLeak")
    private class UpdateTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String[] p1) {
            onUpdate(mLastTime, mOldLastTime);
            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            startActivity();
        }

        private void onUpdate(long lastTime, long oldLastTime) {
            try {
                app = (LuaApplication) getApplication();
                String luaMdDir = app.getMdDir();
                String localDir = app.getLocalDir();
                //原有
                unApk("assets", localDir);
                unApk("lua", luaMdDir);
                //luastudio程序路径
                unApk("src", localDir);
                //公用lua文件
                unApk("public_library/byo_public_library", luaMdDir);
                unApk("public_library/custom_public_library", luaMdDir);

            } catch (IOException e) {

            }
        }

        private void unApk(String dir, String extDir) throws IOException {
            int i = dir.length() + 1;
            ZipFile zip = new ZipFile(getApplicationInfo().publicSourceDir);
            Enumeration<? extends ZipEntry> entries = zip.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = entries.nextElement();
                String name = entry.getName();
                if (name.indexOf(dir) != 0)
                    continue;
                String path = name.substring(i);
                if (entry.isDirectory()) {
                    File f = new File(extDir + File.separator + path);
                    if (!f.exists()) {
                        f.mkdirs();
                    }
                } else {
                    String fname = extDir + File.separator + path;
                    File ff = new File(fname);
                    File temp = new File(fname).getParentFile();
                    if (!temp.exists()) {
                        if (!temp.mkdirs()) {
                            throw new RuntimeException("create file " + temp.getName() + " fail");
                        }
                    }
                    try {
                        if (ff.exists() && entry.getSize() == ff.length() && LuaUtil.getFileMD5(zip.getInputStream(entry)).equals(LuaUtil.getFileMD5(ff)))
                            continue;
                    } catch (NullPointerException ignored) {
                    }
                    FileOutputStream out = new FileOutputStream(extDir + File.separator + path);
                    InputStream in = zip.getInputStream(entry);
                    byte[] buf = new byte[4096];
                    int count = 0;
                    while ((count = in.read(buf)) != -1) {
                        out.write(buf, 0, count);
                    }
                    out.close();
                    in.close();
                }
            }
            zip.close();
        }

    }


}

