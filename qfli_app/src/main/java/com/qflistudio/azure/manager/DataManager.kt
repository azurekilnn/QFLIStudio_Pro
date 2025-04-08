package com.qflistudio.azure.manager

import com.qflistudio.azure.data.AndroidClasses

class DataManager {

    fun getAndroidClasses(): List<String> {
        return AndroidClasses.classNames
    }
}