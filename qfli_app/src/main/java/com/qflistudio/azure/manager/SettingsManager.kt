package com.qflistudio.azure.manager

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import com.qflistudio.azure.common.datastore.PreferenceType
import com.qflistudio.azure.util.JsonUtils
import com.qflistudio.azure.util.RSAUtils
import com.qflistudio.azure.util.RSAUtils.base64ToPrivateKey
import com.qflistudio.azure.util.RSAUtils.base64ToPublicKey
import com.qflistudio.azure.util.RSAUtils.generateKeyPair
import com.qflistudio.azure.util.RSAUtils.privateKeyToBase64
import com.qflistudio.azure.util.RSAUtils.publicKeyToBase64
import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.security.PrivateKey
import java.security.PublicKey
import android.util.Log

class SettingsManager: BaseManager {
    private val TAG = "SettingsManager"
    private lateinit var appSettingsSP: SharedPreferences
    private lateinit var currPrivateKey: PrivateKey
    private lateinit var currPublicKey: PublicKey
    private var jsonUtils = JsonUtils()
    private var rsaUtils = RSAUtils

    // 创建一个包含数据类型和默认值的 Map
    private val appSettings = mapOf(
        // 侧滑手势锁定
        "systemTheme" to Pair(PreferenceType.STRING, "Theme_LuaStudio"),
        "drawerLockStatus" to Pair(PreferenceType.BOOLEAN, false),
        "drawerTitle" to Pair(PreferenceType.STRING, "Test"),
        "autoSaveWhenDeleteProject" to Pair(PreferenceType.BOOLEAN, true),
        "autoRefreshProjList" to Pair(PreferenceType.BOOLEAN, false),
        "ignoreCaseWhenSearch" to Pair(PreferenceType.BOOLEAN, true),
    )


   override fun init(context: Context) {
        appSettingsSP = context.getSharedPreferences("appSettings", Context.MODE_PRIVATE)
        val appKeySp = context.getSharedPreferences("appKey", Context.MODE_PRIVATE)
        val privateKeyString = appKeySp.getString("privateKey", null)
        val publicKeyString = appKeySp.getString("publicKey", null)

        if (privateKeyString != null && publicKeyString != null) {
            // 还原密钥
            currPublicKey = base64ToPublicKey(publicKeyString)
            currPrivateKey = base64ToPrivateKey(privateKeyString)

        } else {
            // 生成密钥对
            val keyPair = generateKeyPair()
            currPublicKey = keyPair.public
            currPrivateKey = keyPair.private

            // 转换成 Base64
            val publicKeyBase64 = publicKeyToBase64(currPublicKey)
            val privateKeyBase64 = privateKeyToBase64(currPrivateKey)
            appKeySp.edit {
                putString("publicKey", publicKeyBase64)
                putString("privateKey", privateKeyBase64)
            } // 异步提交（推荐，速度快）
        }
    }

    fun getAppSettingsSP(): SharedPreferences {
        return appSettingsSP
    }

    // 获取应用内部存储的文件路径
    fun getSetting(key: String): Any {
        val data = appSettings[key]
        val type = data?.first
        val defaultValue = data?.second
        return when (type) {
            PreferenceType.INT -> appSettingsSP.getInt(key, defaultValue as Int)
            PreferenceType.STRING -> appSettingsSP.getString(key, defaultValue as String) ?: ""
            PreferenceType.BOOLEAN -> appSettingsSP.getBoolean(key, defaultValue as Boolean)
            PreferenceType.FLOAT -> appSettingsSP.getFloat(key, defaultValue as Float)
            PreferenceType.LONG -> appSettingsSP.getLong(key, defaultValue as Long)
            else -> false
        }
    }

    fun readSysFile(file: File): String? {
        FileReader(file).use { reader ->
            if (::currPublicKey.isInitialized && ::currPrivateKey.isInitialized) {
                val json = reader.let { rsaUtils.safeDecrypt(it.readText(), currPrivateKey) }
                Log.i(TAG, "loadArrayToJsonFile: $json")
                return json
            }
        }
        return null
    }

    fun writeSysFile(file: File, content: String?) {
        var realContent = ""

        if (::currPublicKey.isInitialized && ::currPrivateKey.isInitialized) {
            realContent = content?.let { rsaUtils.encrypt(it, currPublicKey) } ?: ""
        }

        // 获取应用的私有存储目录
        FileWriter(file).use { writer ->
            writer.write(realContent)
        }
    }

    // 保存数组为JSON文件
    fun saveArrayToJsonFile(data: MutableList<String>?, file: File) {
        val json = jsonUtils.arrayToJson(data)
        writeSysFile(file, json)
    }

    // 保存数组为JSON文件
    fun loadArrayToJsonFile(file: File): MutableList<String>? {
        FileReader(file).use { reader ->
            if (::currPublicKey.isInitialized && ::currPrivateKey.isInitialized) {
                val json = reader.let { rsaUtils.safeDecrypt(it.readText(), currPrivateKey) }
                Log.i(TAG, "loadArrayToJsonFile: $json")
                return jsonUtils.jsonToArray(json)
            }
        }
        return null
    }

}