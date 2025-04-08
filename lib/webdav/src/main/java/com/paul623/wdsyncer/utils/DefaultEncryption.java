package com.paul623.wdsyncer.utils;

import com.paul623.wdsyncer.api.Encryption;

/**
 * Created by Android Studio.
 * User: paul623
 * Date: 2021/2/2
 * Time: 18:37
 * Email:zhubaoluo@outlook.com
 */
public class DefaultEncryption implements Encryption {
    @Override
    public String encode(String key) {
        return Base64Util.encodeToString(key);
    }

    @Override
    public String decode(String password) {
        return Base64Util.decodeToString(password);
    }
}
