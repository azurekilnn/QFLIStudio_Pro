package com.androlua;

import android.content.Intent;
import android.os.Bundle;

public class Main extends LuaActivity {
	private static final int REQUEST_CODE = 1024;
	private Bundle mSavedInstanceState;

	@Override
	public void onCreate(Bundle s) {
		super.onCreate(s);
		mSavedInstanceState = s;
		if (s == null && getIntent().getData() != null) {
			runFunc("onNewIntent", getIntent());
		}
		if (getIntent().getBooleanExtra("isVersionChanged", false) && (mSavedInstanceState == null))
		{
			onVersionChanged(getIntent().getStringExtra("newVersionName"), getIntent().getStringExtra("oldVersionName"));
		}
	}

	/*@Override
	public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults)
	{
		if (getIntent().getBooleanExtra("isVersionChanged", false) && (mSavedInstanceState == null))
		{
			onVersionChanged(getIntent().getStringExtra("newVersionName"), getIntent().getStringExtra("oldVersionName"));
		}
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);
	}
  */

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
