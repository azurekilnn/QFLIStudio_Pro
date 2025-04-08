package com.qflistudio.azure.manager

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File
import java.io.FileReader
import java.io.FileWriter

class CollectionManager(private val context: Context) {
    private val TAG = "CollectionManager"
    private val filesDir = context.filesDir
    private val fileName = "collected_projects.json"  // JSON文件名
    private var collectionData: MutableList<String>? = null

    fun init() {
        collectionData = loadArrayFromJson()
        if (collectionData == null) {
            collectionData = mutableListOf()
        }
        Log.i(TAG, collectionData.toString());
    }

    // 保存数组为JSON文件
    fun saveArrayToJson() {
        Log.i(TAG, collectionData.toString());
        val gson = Gson()
        val json = gson.toJson(collectionData)

        // 获取应用的私有存储目录
        val file = File(filesDir, fileName)
        FileWriter(file).use { writer ->
            writer.write(json)
        }
    }

    // 从JSON文件读取并转换为数组
    fun loadArrayFromJson(): MutableList<String>? {
        val gson = Gson()
        val file = File(filesDir, fileName)

        if (!file.exists()) {
            // 文件不存在，返回空数组并保存空数组为 JSON
            collectionData = mutableListOf()
            saveArrayToJson()  // 保存空数组
            return collectionData
        }

        val listType = object : TypeToken<MutableList<String>>() {}.type
        FileReader(file).use { reader ->
            return gson.fromJson<MutableList<String>>(reader, listType)
        }
    }

    // 遍历方法，判断输入值是否在数组中
    fun isValueInArray(value: String): Boolean {
        if (collectionData == null) {
            init()
        }
        return collectionData?.contains(value) ?: false
    }

    fun addNewCollectionToArray(projectPath: String): Boolean {
        if (collectionData == null) {
            init()
        }
        return if (!isValueInArray(projectPath)) {
            collectionData?.add(projectPath)
            true
        } else {
            false
        }
    }

    fun removeCollectionFromArray(projectPath: String): Boolean {
        if (collectionData == null) {
            init()
        }
        // 如果数组中存在该元素，删除并保存
        return if (collectionData?.contains(projectPath) == true) {
            collectionData?.remove(projectPath)
            true
        } else {
            false
        }
    }

    fun addAndSaveNewCollection(projectPath: String): Boolean {
        val addStatus = addNewCollectionToArray(projectPath)
        if (addStatus) {
            saveArrayToJson()
            Log.i(TAG, "收藏添加成功！")
            return true
        }
        return false
    }

    fun removeAndSaveCollection(projectPath: String): Boolean {
        val removeStatus = removeCollectionFromArray(projectPath)
        if (removeStatus) {
            saveArrayToJson()
            Log.i(TAG, "收藏删除成功！")
            return true
        }
        return false
    }

}