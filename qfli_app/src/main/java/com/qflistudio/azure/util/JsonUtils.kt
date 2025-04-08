package com.qflistudio.azure.util

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File
import java.io.FileReader
import java.io.FileWriter

class JsonUtils {
   private val gson = Gson()

    fun arrayToJson(data: MutableList<String>?): String? {
        return gson.toJson(data)
    }

    fun jsonToArray(jsonContent: String): MutableList<String> {
        val newData = mutableListOf<String>()
        val listType = object : TypeToken<MutableList<String>>() {}.type
        return gson.fromJson<MutableList<String>>(jsonContent, listType) ?: newData
    }


    // 保存数组为JSON文件
    fun saveArrayToJsonFile(data: MutableList<String>?, file: File) {
        val json = arrayToJson(data)

        // 获取应用的私有存储目录
        FileWriter(file).use { writer ->
            writer.write(json)
        }
    }

    // 从JSON文件读取并转换为数组
    fun loadArrayFromJsonFile(file: File): MutableList<String>? {
        val newData = mutableListOf<String>()
        if (!file.exists()) {
            // 文件不存在，返回空数组并保存空数组为 JSON
            saveArrayToJsonFile(newData, file)  // 保存空数组
            return newData
        }

        val listType = object : TypeToken<MutableList<String>>() {}.type
        FileReader(file).use { reader ->
            return gson.fromJson<MutableList<String>>(reader, listType)
        }
    }
}