package com.luastudio.azure.activity;

import android.content.Intent;
import android.os.Bundle;
import com.luastudio.azure.LuaAppActivity;

public class LuaMainActivity extends LuaAppActivity {
    private static final int REQUEST_CODE = 1024;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState == null && getIntent().getData() != null)
            runFunc("onNewIntent", getIntent());
        if (getIntent().getBooleanExtra("isVersionChanged", false) && (savedInstanceState == null)) {
            onVersionChanged(getIntent().getStringExtra("newVersionName"), getIntent().getStringExtra("oldVersionName"));
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        runFunc("onNewIntent", intent);
        super.onNewIntent(intent);
    }

    @Override
    public String getLuaDir() {
        return getLocalDir();
    }


    @Override
    public String getLuaPath() {
        initMain();
        return getLocalDir() + "/main.lua";
    }

    private void onVersionChanged(String newVersionName, String oldVersionName) {
        runFunc("onVersionChanged", newVersionName, oldVersionName);
    }


}
