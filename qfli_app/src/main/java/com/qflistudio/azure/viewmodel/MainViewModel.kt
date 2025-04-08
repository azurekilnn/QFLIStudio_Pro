package com.qflistudio.azure.viewmodel

import ApkItem
import FileItem
import ProjectItem
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.qflistudio.azure.bean.MyLuaAppItem
import com.qflistudio.azure.bean.UserInfoItem
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class MainViewModel : ViewModel() {

    val luaProjectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val pyProjectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val cppProjectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val cProjectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val javaProjectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val projectItemsList = MutableLiveData<MutableList<ProjectItem>>()
    val luaAppItemsList = MutableLiveData<MutableList<MyLuaAppItem>>()
    val apkItemsList = MutableLiveData<MutableList<ApkItem>>()

    val listRefreshStatus = MutableLiveData<Boolean>()
    val projectsListSearchKey = MutableLiveData<String>()
    val reloadProjectType = MutableLiveData<String>()
    val mainPageChanged = MutableLiveData<Boolean>()

    val binFileRecycleList = MutableLiveData<MutableList<FileItem>>()
    val binFormatFileBackupList = MutableLiveData<MutableList<FileItem>>()
    val binHistFileBackupList = MutableLiveData<MutableList<FileItem>>()

    val currUserInfo = MutableLiveData<UserInfoItem>()

    fun setBinFilesList(list: MutableList<FileItem>, relativePath: String) {
        when (relativePath) {
            // 格式化文件备份
            "format_file" -> {
                binFormatFileBackupList.value = list
            }
            // 自动保存文件备份
            "auto_save" -> {
                binHistFileBackupList.value = list
            }
            // 回收站
            "bin" -> {
                binFileRecycleList.value = list
            }
        }
    }

    fun setCurrentUserInfo(userInfo: UserInfoItem) {
        currUserInfo.value = userInfo
    }

    fun setMainPageChanged(state: Boolean) {
        mainPageChanged.value = state
    }

    fun setProjectsListSearchKey(keyWord: String) {
        projectsListSearchKey.value = keyWord
    }

    fun updateProjectsList(projectType: String) {
        reloadProjectType.value = projectType
    }

    fun setLuaProjectItems(items: MutableList<ProjectItem>) {
        luaProjectItemsList.value = items
    }

    fun setPyProjectItems(items: MutableList<ProjectItem>) {
        pyProjectItemsList.value = items
    }

    fun setCProjectItems(items: MutableList<ProjectItem>) {
        cProjectItemsList.value = items
    }

    fun setCppProjectItems(items: MutableList<ProjectItem>) {
        cppProjectItemsList.value = items
    }

    fun setJavaProjectItems(items: MutableList<ProjectItem>) {
        javaProjectItemsList.value = items
    }

    fun setProjectItems(items: MutableList<ProjectItem>) {
        projectItemsList.value = items
    }

    fun setMyLuaAppItems(items: MutableList<MyLuaAppItem>) {
        luaAppItemsList.value = items
    }

    fun setApkItems(items: MutableList<ApkItem>) {
        apkItemsList.value = items
    }

    // 设置布尔值的函数
    fun setListRefreshStatus(value: Boolean) {
        listRefreshStatus.value = value
    }

    fun runAsync(block: suspend CoroutineScope.() -> Unit) {
        viewModelScope.launch {
            block()
        }
    }


}