package com.qflistudio.azure.common.datastore

import android.content.Context
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.doublePreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.floatPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.qflistudio.azure.common.SettingsData
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

// 创建一个枚举类型来代表不同的数据类型
enum class PreferenceType {
    INT, DOUBLE, STRING, BOOLEAN, FLOAT, LONG
}

class SettingsDataStore(private val mContext: Context) {
    companion object {
        val Context.dataStore by preferencesDataStore(
            name = "Settings"
        )
    }

    private fun getKey(type: PreferenceType, key: String): Preferences.Key<*> {
        return when (type) {
            PreferenceType.INT -> intPreferencesKey(key)
            PreferenceType.DOUBLE -> doublePreferencesKey(key)
            PreferenceType.STRING -> stringPreferencesKey(key)
            PreferenceType.BOOLEAN -> booleanPreferencesKey(key)
            PreferenceType.FLOAT -> floatPreferencesKey(key)
            PreferenceType.LONG -> longPreferencesKey(key)
        }
    }

    fun getValue(key: String): Flow<Any?> {
        val data = SettingsData[key]
        val type = data?.first
        val defaultValue = data?.second
        return getValue(type!!, key, defaultValue)
    }

    fun getValue(type: PreferenceType, key: String, defaultValue: Any?): Flow<Any?> {
        val preferencesKey = getKey(type, key)
        return mContext.dataStore.data.map {
            val value = it[preferencesKey]

            // 如果值为 null，则保存默认值
            if (value == null && defaultValue != null) {
                // 通过调用 saveData 方法保存默认值
                saveData(key, defaultValue)
            }

            value ?: defaultValue
        }
    }

    suspend fun saveData(key: String, value: Any) {
        mContext.dataStore.edit { preferences ->
            when (value) {
                is Int -> preferences[intPreferencesKey(key)] = value
                is Double -> preferences[doublePreferencesKey(key)] = value
                is String -> preferences[stringPreferencesKey(key)] = value
                is Boolean -> preferences[booleanPreferencesKey(key)] = value
                is Float -> preferences[floatPreferencesKey(key)] = value
                is Long -> preferences[longPreferencesKey(key)] = value
                else -> throw IllegalArgumentException("Unsupported type")
            }
        }
    }
}