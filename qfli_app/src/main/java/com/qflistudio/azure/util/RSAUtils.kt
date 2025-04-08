package com.qflistudio.azure.util

import android.content.SharedPreferences
import android.util.Log
import androidx.core.content.edit
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.PrivateKey
import java.security.PublicKey
import java.util.Base64
import javax.crypto.Cipher

object RSAUtils {

    private val TAG = "RSAUtils"

    // 生成 RSA 密钥对
    fun generateKeyPair(): KeyPair {
        val keyPairGenerator = KeyPairGenerator.getInstance("RSA")
        keyPairGenerator.initialize(2048) // 2048位密钥
        return keyPairGenerator.generateKeyPair()
    }

    // 加密（使用公钥）
    fun encrypt(data: String, publicKey: PublicKey): String {
        val cipher = Cipher.getInstance("RSA")
        cipher.init(Cipher.ENCRYPT_MODE, publicKey)
        val encryptedBytes = cipher.doFinal(data.toByteArray())
        return Base64.getEncoder().encodeToString(encryptedBytes) // Base64 编码
    }

    // 解密（使用私钥）
    fun decrypt(encryptedData: String, privateKey: PrivateKey): String {
        val cipher = Cipher.getInstance("RSA")
        cipher.init(Cipher.DECRYPT_MODE, privateKey)
        val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData))
        return String(decryptedBytes)
    }

    // 安全解密
    fun safeDecrypt(encryptedData: String, privateKey: PrivateKey): String {
        return try {
            val cipher = Cipher.getInstance("RSA")
            cipher.init(Cipher.DECRYPT_MODE, privateKey)
            val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData))
            String(decryptedBytes)
        } catch (e: Exception) {
            Log.i(TAG, e.message.toString())// 打印异常日志
            "" // 返回 null 代表解密失败
        }
    }

    fun isPrivateKeyValid(publicKey: PublicKey, privateKey: PrivateKey): Boolean {
        return try {
            val testString = "test"
            val encrypted = encrypt(testString, publicKey)
            val decrypted = decrypt(encrypted, privateKey)
            decrypted == testString // 检查解密后是否正确
        } catch (e: Exception) {
            false // 解密失败，私钥不匹配
        }
    }

    // 公钥转换为 Base64 字符串
    fun publicKeyToBase64(publicKey: PublicKey): String {
        return Base64.getEncoder().encodeToString(publicKey.encoded)
    }

    // 私钥转换为 Base64 字符串
    fun privateKeyToBase64(privateKey: PrivateKey): String {
        return Base64.getEncoder().encodeToString(privateKey.encoded)
    }

    // Base64 转换回公钥
    fun base64ToPublicKey(base64Key: String): PublicKey {
        val keyFactory = java.security.KeyFactory.getInstance("RSA")
        val keySpec = java.security.spec.X509EncodedKeySpec(Base64.getDecoder().decode(base64Key))
        return keyFactory.generatePublic(keySpec)
    }

    // Base64 转换回私钥
    fun base64ToPrivateKey(base64Key: String): PrivateKey {
        val keyFactory = java.security.KeyFactory.getInstance("RSA")
        val keySpec = java.security.spec.PKCS8EncodedKeySpec(Base64.getDecoder().decode(base64Key))
        return keyFactory.generatePrivate(keySpec)
    }
}