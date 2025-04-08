package com.luastudio.azure;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.androlua.LuaUtil;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import com.qflistudio.azure.R;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class QuickBootActivity extends AppCompatActivity {
    private static final int REQUEST_CODE = 1024;

    private MaterialAlertDialogBuilder permission_dlg;
    private MaterialAlertDialogBuilder user_agreement_dlg;
    private MaterialAlertDialogBuilder verify_signature_dlg;
    private TextView welcome_tips_textview2;
    public boolean isUpdata;
    public boolean update_status;

    public LuaApplication app;
    public long mLastTime;
    public long mOldLastTime;
    public boolean isVersionChanged;
    public String mVersionName;
    public String mOldVersionName;
    public ArrayList<String> permissions;
    private Bundle mSavedInstanceState;
    private String luaMdDir;
    private String localDir;
    public String MySignature;
    public String environment_root_path;
    public String custom_path;
    private String quick_boot_string;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setTheme(R.style.Theme_LuaStudio_NoActionBar);
        setContentView(R.layout.layout_boot_activity);
        // 透明状态栏
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        // 透明导航栏
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        // 状态栏高亮
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
        }

        welcome_tips_textview2 = findViewById(R.id.welcome_tips_textview);
        welcome_tips_textview2.setText(R.string.loading_tip);
        String MyApplicationDataDir = getFilesDir().getAbsolutePath();
        String TestTablePath = MyApplicationDataDir + "/test.conf";
        LuaState luaState = LuaStateFactory.newLuaState();
        //AzureLibrary.toast(this,SystemLibrary.getProjectList());


        // Signature
        MySignature = AzureLibrary.MySignature;
        app = (LuaApplication) getApplication();
        luaMdDir = app.getMdDir();
        localDir = app.getLocalDir();
        environment_root_path = AzureLibrary.environment_root_path;
        custom_path = AzureLibrary.luaCustomDir;
        welcome_tips_textview2.setText("Checking...");
        create_verify_signature_dlg();
        create_user_agreement_dlg();
        update_status = checkInfo2();

        Object quick_boot = LuaApplication.getInstance().getSharedData("settings_quick_boot");

        if (quick_boot != null) {
            quick_boot_string = String.valueOf(quick_boot);
        } else {
            quick_boot_string = "false";
        }



        /*if (checkPermission()) {
            check_application();
        } else {
            create_permission_dlg();
            permission_dlg.show();
        }*/
        if (update_status) {
            if (checkPermission()) {
                check_application();
            } else {
                create_permission_dlg();
                permission_dlg.show();
            }
        } else {
            startMainActivity2();
        }
    }

    private void unZipAssetsFile(String OriginPath,String ToPath) throws IOException {
        AssetManager assetManager = getAssets();
        InputStream is = assetManager.open(OriginPath);
        File newFile = new File(ToPath, OriginPath);
        FileOutputStream fos = new FileOutputStream(newFile);

        int len = -1;
        byte[] buffer = new byte[1024];
        while ((len = is.read(buffer)) != -1) {
            fos.write(buffer, 0, len);
        }
        fos.close();
        is.close();
    }

    private void unZipTemplates() {
        File origin_res2 = new File(localDir + "/activities/bin_moudle/resources/templates/androlua_lite");
        File origin_res3 = new File(localDir + "/activities/bin_moudle/resources/templates/androlua_lite_x5");
        File origin_res4 = new File(localDir + "/activities/bin_module/resources/templates/luastudio_demo");

        File output_res2 = new File(environment_root_path + "/AndroLua/lite");
        File output_res3 = new File(environment_root_path + "/AndroLua/lite_x5");
        File output_res4 = new File(environment_root_path + "/AndroLua/luastudio_demo");

        if (origin_res2.exists() && (!output_res2.exists())) {
            LuaUtil.unZip(origin_res2.getPath(), output_res2.getPath());
            welcome_tips_textview2.setText(origin_res2.getPath());
        }
        if (origin_res3.exists() && (!output_res3.exists())) {
            LuaUtil.unZip(origin_res3.getPath(), output_res3.getPath());
            welcome_tips_textview2.setText(origin_res3.getPath());
        }
        if (origin_res4.exists() && (!output_res4.exists())) {
            LuaUtil.unZip(origin_res4.getPath(), output_res4.getPath());
            welcome_tips_textview2.setText(origin_res4.getPath());
        }
    }

    private void unZipResources() {
        // 释放资源
        File res = new File(environment_root_path + "/Android");
        if (!res.exists()) {
            try {
                unZipAssetsFile("resources.zip",environment_root_path+"/");
                AzureLibrary.unZip(environment_root_path+"/resources.zip",environment_root_path+"/");
                new File(environment_root_path+"/resources.zip").delete();
            } catch (IOException e) {
                e.printStackTrace();
            }
            //File origin_res = new File(localDir + "/android.zip");
            unZipTemplates();
        }
    }

    private void unZipIcons() {
        File icons_res = new File(custom_path + "/res");
        if (!icons_res.exists() || icons_res.listFiles() == null) {
            //若本地目录不存在
            if (!icons_res.mkdirs()) {
                throw new RuntimeException("create file " + icons_res.getName() + " fail");
            } else {
                try {
                    unZipAssetsFile("res.zip",custom_path+"/");
                    File origin_icons_res = new File(custom_path + "/res.zip");
                    if (origin_icons_res.exists()) {
                        AzureLibrary.unZip(custom_path + "/res.zip",custom_path+"/res/");
                        //new File(custom_path + "/res.zip").delete();
                        welcome_tips_textview2.setText("解压图标库...");
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        }


        /*释放图标资源
        File origin_icons_res = new File(localDir + "/res.zip");
        File icons_res = new File(custom_path + "/res");
        if (!icons_res.exists() || icons_res.listFiles() == null) {
            //若本地目录不存在
            if (!icons_res.mkdirs()) {
                throw new RuntimeException("create file " + icons_res.getName() + " fail");
            } else {
                if (origin_icons_res.exists()) {
                    welcome_tips_textview2.setText("解压图标库...");
                    LuaUtil.unZip(origin_icons_res.getPath(), icons_res.getPath());
                }
            }
        }*/

    }

    public void startMainActivity() {
        if (quick_boot_string.equals("true")) {
            startMainActivity2();
        } else {
            new Handler().postDelayed(new Runnable() {
                public void run() {
                    Intent intent = new Intent(QuickBootActivity.this, MainActivity.class);
                    if (isVersionChanged) {
                        intent.putExtra("isVersionChanged", isVersionChanged);
                        intent.putExtra("newVersionName", mVersionName);
                        intent.putExtra("oldVersionName", mOldVersionName);
                    }
                    startActivity(intent);
                    //overridePendingTransition(android.R.anim.slide_in_left,android.R.anim.slide_out_right);
                    overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                    finish();
                }
            }, 0);
        }
    }

    public void startMainActivity2() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        finish();
    }

    //Dialogs
    private void create_permission_dlg() {
        permission_dlg = new MaterialAlertDialogBuilder(this,R.style.AlertDialogTheme);
        permission_dlg.setTitle(R.string.tip_text);
        permission_dlg.setMessage(R.string.get_permission_message);
        permission_dlg.setCancelable(false);
        permission_dlg.setPositiveButton(R.string.ok_button, (dialog, which) -> {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestPermission();
            } else {
                // 一般情况下如果用户不授权的话，功能是无法运行的，做退出处理
                Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                intent.setData(Uri.fromParts("package", getPackageName(), null));
                startActivity(intent);
                finish();
            }
        });
        permission_dlg.setNeutralButton(R.string.go_to_settings, (dialog, which) -> {
            // 一般情况下如果用户不授权的话，功能是无法运行的，做退出处理
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.fromParts("package", getPackageName(), null));
            startActivity(intent);
            finish();
        });
        permission_dlg.setNegativeButton(R.string.exit, (dialog, which) -> finish());
    }
    private void create_user_agreement_dlg() {
        user_agreement_dlg = new MaterialAlertDialogBuilder(this,R.style.AlertDialogTheme);
        user_agreement_dlg.setTitle("用户协议");
        user_agreement_dlg.setMessage(R.string.user_agreement);
        user_agreement_dlg.setCancelable(false);
        user_agreement_dlg.setPositiveButton(R.string.ok_button, (dialog, which) -> startMainActivity());
        user_agreement_dlg.setNegativeButton(R.string.exit, (dialog, which) -> finish());
    }

    private void create_verify_signature_dlg() {
        verify_signature_dlg = new MaterialAlertDialogBuilder(this,R.style.AlertDialogTheme);
        verify_signature_dlg.setTitle(R.string.tip_text);
        verify_signature_dlg.setMessage(R.string.verify_signature_error_tips);
        //verify_signature_dlg.setCancelable(false);
        verify_signature_dlg.setPositiveButton(R.string.exit, (dialog, which) -> finish());
    }
    private void check_application() {
        new BootTask().execute();
    }

    private boolean checkSignature(String Signature) {
        try {
            @SuppressLint("PackageManagerGetSignatures") PackageInfo AppPackageInfo = getPackageManager().getPackageInfo(this.getPackageName(), PackageManager.GET_SIGNATURES);
            String AppSignature = AppPackageInfo.signatures[0].toCharsString();
            if (Signature == null) {
                return false;
            } else if (Signature.equals("")) {
                return false;
            } else if (Signature.equals(AppSignature)) {
                return true;
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // @SuppressLint("StaticFieldLeak")
    private class BootTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String[] p1) {
            onCheck();
            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            welcome_tips_textview2.setText("正在启动...");
            if (update_status) {
                user_agreement_dlg.show();
            } else {
                welcome_tips_textview2.setVisibility(View.INVISIBLE);
                startMainActivity();
            }
        }

        private void onCheck() {
            welcome_tips_textview2.setText("检查应用签名...");
            if (checkSignature(MySignature)) {
                welcome_tips_textview2.setText("检查应用权限...");
                if (checkPermission()) {
                    if (quick_boot_string.equals("true")) {
                        welcome_tips_textview2.setVisibility(View.INVISIBLE);
                    } else {
                        buildNewDir(localDir + "/memory_file");
                        buildNewDir(localDir + "/memory_file/swtich_record");
                        buildNewDir(localDir + "/memory_file/project_info");

                        buildNewDir(AzureLibrary.environment_root_path);
                        buildNewDir(AzureLibrary.cachesDir);
                        buildNewDir(AzureLibrary.luaCustomDir);
                        buildNewDir(AzureLibrary.pluginsDir);
                        buildNewDir(AzureLibrary.projectsDir);
                        welcome_tips_textview2.setText("检查图标库...");
                        unZipIcons();
                        welcome_tips_textview2.setText("检查资源...");
                        unZipResources();
                        welcome_tips_textview2.setText("检查应用信息...");
                    }

                    if (checkInfo()) {
                        welcome_tips_textview2.setText("解压运行库...");
                        buildNewDir(AzureLibrary.environment_root_path);
                        buildNewDir(AzureLibrary.environment_root_path + "/runtime_files");
                        try {
                            unApk("lib", environment_root_path + "/runtime_files");
                            //更新主程序
                            welcome_tips_textview2.setText("解压程序...");
                            unApk("lua", luaMdDir);
                            //公用lua文件
                            unApk("public_library/byo_public_library", luaMdDir);
                            unApk("public_library/custom_public_library", luaMdDir);
                            //luastudio程序路径
                            unApk("ls_res", localDir);
                            unApk("src", localDir);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        welcome_tips_textview2.setText("正在启动...");
                    } else {
                        welcome_tips_textview2.setVisibility(View.INVISIBLE);
                    }

                }
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

    public void buildNewDir(String path) {
        File file_object = new File(path);
        if (!file_object.exists()) {
            if (!file_object.mkdirs()) {
                AzureLibrary.toast(this, "创建 ：" + path + "出错！");
            }
        }
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
    public boolean checkInfo2() {
        try {
            PackageInfo packageInfo = getPackageManager().getPackageInfo(this.getPackageName(), 0);
            long lastTime = packageInfo.lastUpdateTime;
            String versionName = packageInfo.versionName;
            SharedPreferences info = getSharedPreferences("appInfo", 0);
            String oldVersionName = info.getString("versionName", "");
            if (!versionName.equals(oldVersionName)) {
                isVersionChanged = true;
                mVersionName = versionName;
                mOldVersionName = oldVersionName;
            }
            long oldLastTime = info.getLong("lastUpdateTime", 0);
            if (oldLastTime != lastTime) {
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

    private void requestPermission() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_CODE);
    }

    private boolean checkPermission() {
        // 先判断有没有权限
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE) {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED &&
                    ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                check_application();
            } else {
                permission_dlg.show();
            }
        }
    }
}
