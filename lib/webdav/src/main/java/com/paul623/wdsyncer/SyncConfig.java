package com.paul623.wdsyncer;

import android.content.Context;
import android.content.SharedPreferences;

import com.paul623.wdsyncer.api.Encryption;
import com.paul623.wdsyncer.utils.DefaultEncryption;

import org.jetbrains.annotations.NotNull;

/**
 * 配置类
 * 2020.5.18
 * TODO
 * 目前get和set不符合规范
 * */
public class SyncConfig {
    private String userAccount;
    private final String USERACCOUNT="account";

    private String passWord;
    private final String PASSWORD="password";

    private String serverUrl;
    private final String SERVERURL="server_url";

    private boolean diyEncryption;
    private static final String DIVENCRYPTION="diy_encryption";

    private Context context;
    private SharedPreferences sp;
    private Encryption encryption;


    private static final String dataBaseName="wdsyncer_config_dataBase";

    public SyncConfig(Context context,@NotNull Encryption encryption){
        this.context=context;
        sp=context.getSharedPreferences(dataBaseName,Context.MODE_PRIVATE);
        this.encryption = encryption;
        setDiyEncryption(true);
    }
    public SyncConfig(Context context){
        this.context=context;
        sp=context.getSharedPreferences(dataBaseName,Context.MODE_PRIVATE);
        this.encryption =new DefaultEncryption();
        setDiyEncryption(false);
    }

    private void setDiyEncryption(Boolean flag){
        SharedPreferences.Editor editor=sp.edit();
        editor.putBoolean(DIVENCRYPTION,flag);
        editor.apply();
    }
    public static boolean getDiyEncryption(Context context){
        SharedPreferences sp=context.getSharedPreferences(dataBaseName,Context.MODE_PRIVATE);
        return sp.getBoolean(DIVENCRYPTION,false);
    }
    public String getUserAccount() {
        userAccount=sp.getString(USERACCOUNT,"");
        userAccount= encryption.decode(this.userAccount);
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
        SharedPreferences.Editor editor=sp.edit();
        editor.putString(USERACCOUNT, encryption.encode(userAccount));
        editor.apply();
    }

    public String getPassWord() {
        passWord=sp.getString(PASSWORD,"");
        passWord= encryption.decode(passWord);
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
        SharedPreferences.Editor editor=sp.edit();
        editor.putString(PASSWORD, encryption.encode(this.passWord));
        editor.apply();
    }

    public String getServerUrl() {
        serverUrl=sp.getString(SERVERURL,"https://dav.jianguoyun.com/dav/");
        return serverUrl;
    }

    public void setServerUrl(String serverUrl) {
        this.serverUrl = serverUrl;
        SharedPreferences.Editor editor=sp.edit();
        editor.putString(SERVERURL,serverUrl);
        editor.apply();
    }

    public boolean canLogin(){
        return !getUserAccount().equals("") && !getPassWord().equals("") && !getServerUrl().equals("");
    }
    public void clean(){
        SharedPreferences.Editor editor=sp.edit();
        editor.clear();
        editor.apply();
    }
}
