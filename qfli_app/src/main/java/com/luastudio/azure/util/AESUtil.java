package com.luastudio.azure.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

public class AESUtil {
    public static String generateKey() throws NoSuchAlgorithmException {
        // 生成密钥
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(128); // 使用128位密钥
        SecretKey secretKey = keyGen.generateKey();

        return secretKey.getEncoded().toString();
    }

    public static String generateIV() {
        // 生成初始化向量 (IV)
        byte[] iv = new byte[16]; // 16字节的IV对于AES来说是标准的
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);

        return ivSpec.getIV().toString();
    }
}
