package com.paul623.wdsyncer.api;

/**
 * Created by Android Studio.
 * User: paul623
 * Date: 2021/2/2
 * Time: 18:35
 * Email:zhubaoluo@outlook.com
 */
public interface Encryption {
    //加密
    public String encode(String key);
    //解密
    public String decode(String password);
}
