package com.qflistudio.azure.manager

import OnCompleteListener
import ProjectItem
import ProjectProcessCallback
import android.content.Context
import android.util.Log
import android.view.View
import androidx.lifecycle.ViewModel
import com.qflistudio.azure.common.Dialogs
import com.qflistudio.azure.common.ktx.isLuaIDE
import com.qflistudio.azure.common.ktx.runAsync
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.common.ktx.skipToActivity
import com.qflistudio.azure.ui.HelpRosterActivity
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import java.io.File

class EventManager private constructor() {
    private val TAG = "EventManager"
    // 存储事件的 Map
    private val eventMap = mutableMapOf<String, (Array<out Any?>) -> Any?>()
    private val azureUtils: AzureUtils by lazy { AzureUtils() }
    private val dialogs: Dialogs by lazy { Dialogs() }

    private var context: Context? = null
    private var globalView: View? = null
    private var luaAppManager: LuaAppManager? = null
    private var themeManager: ThemeManager? = null
    private lateinit var currViewModel: ViewModel

    fun init(initContext: Context) {
        initContext(initContext)
        runAsync { loadEvents() }
    }

    fun initContext(initContext: Context) {
        context = initContext
    }

    fun setTManager(tm: ThemeManager) {
        themeManager = tm
        dialogs.setTManager(tm)
    }

    fun setLAManager(initLuaAppManager: LuaAppManager) {
        luaAppManager = initLuaAppManager
    }

    // 注册事件
    fun registerEvent(key: String, event: (Array<out Any?>) -> Any?) {
        eventMap[key] = event
    }

    fun skipToLuaActivityEvent(key: String, vararg args: Any?): Any? {
        Log.i(TAG, args.toString())
        val event = eventMap[key]
        val checkAppExists = luaAppManager?.checkAppExists(key)
        if (checkAppExists == true) {
            var filePath = ""
            val projectItem = args[0] as ProjectItem
            val projectPath = projectItem.projectPath
            if (args.size > 1 && args[1] != null) {
                val file = args[1] as File
                filePath = file.absolutePath
                return skipToLuaApp(key, arrayOf(projectPath, filePath))
            } else {
                return skipToLuaApp(key, arrayOf(projectPath))
            }
        } else {
            val realEvent = event ?: return defaultTip("No event found for key: $key")
            return realEvent(args)
        }
    }

    // 执行事件
    fun triggerEvent(key: String, vararg args: Any?): Any? {
        val event = eventMap[key]
        // 编辑器模式
        val editorMode: String
        // 如果有传入编辑器模式 判断编辑器
        if (args.size == 3 && args[2] != null) {
            editorMode = args[2] as String
            if (editorMode.isLuaIDE() && luaAppManager != null) {
                Log.i(TAG, "editorMode LuaIDE")
                val checkAppExists = luaAppManager?.checkAppExists(key)
                if (checkAppExists == true) {
                    Log.i(TAG, "editorMode checkAppExists")
                    var filePath = ""
                    val projectItem = args[0] as ProjectItem
                    if (args[1] != null) {
                        val file = args[1] as File
                        filePath = file.absolutePath
                    }
                    return skipToLuaApp(key, arrayOf(projectItem.projectPath, filePath))
                }
            }
        }

        val realEvent = event ?: return defaultTip("No event found for key: $key")
        return realEvent(args)
    }


    fun triggerEventWithDefault(key: String, vararg args: Any?, default: () -> Any?): Any? {
        val event = eventMap[key] ?: return default()
        return event(args)
    }

    fun triggerEventWithException(key: String, vararg args: Any?): Any? {
        val event = eventMap[key] ?: throw IllegalArgumentException("No event found for key: $key")
        return event(args)
    }

    fun unregisterEvent(key: String) {
        eventMap.remove(key)
    }

    private fun defaultTip(message: String) {
        Log.i(TAG, "defaultEvent: $message")
        (globalView ?: context).showTip(message)
    }

    private fun skipToLuaApp(appNameKey: String, args: Array<Any>?) {
        Log.i(TAG, "skipToLuaApp: $appNameKey $args")
        if (args != null) {
            luaAppManager?.skipToActivity(appNameKey, args)
        } else {
            luaAppManager?.skipToActivity(appNameKey)
        }
    }

    private fun skipToLuaApp(appNameKey: String) {
        skipToLuaApp(appNameKey, null)
    }

    fun setGlobalView(view: View) {
        globalView = view
    }

    private fun loadEvents() {
        val projectUtils = ProjectUtils()

        registerEvent("open_by_new_window") { args ->
            val projectItem = args[0] as ProjectItem
            azureUtils.skipToNewEditorActivityX(context!!, projectItem)
        }

        registerEvent("project_info") { args ->
            when (args.size) {
                1 -> {
                    skipToLuaActivityEvent("project_info", args[0])
                }

                2 -> {
                    skipToLuaActivityEvent("project_info", args[0], args[1])
                }

                else -> {
                    defaultTip("No event found for key: project_info")
                }
            }
        }

        registerEvent("clone_project") { args ->
            val projectItem = args[0] as ProjectItem
            projectUtils.cloneProject(context!!, projectItem, object : ProjectProcessCallback {
                override fun onComplete(result: String) {
                    defaultTip("onComplete：$result")
                    if (::currViewModel.isInitialized) {
                        (currViewModel as MainViewModel).updateProjectsList(projectItem.projectType)
                    }
                }

                override fun onError(exception: Exception) {
                    defaultTip("onError：${exception.message}")
                }
            })
        }

        registerEvent("fix_project") { args ->
        }

        registerEvent("save_project") { args ->
            val projectItem = args[0] as ProjectItem
            projectUtils.backupProject(context!!, projectItem, object : ProjectProcessCallback {
                override fun onComplete(result: String) {
                    defaultTip("onComplete")
                }

                override fun onError(exception: Exception) {
                    defaultTip("onError：${exception.message}")
                }
            })
        }

        registerEvent("share_project") { args ->
            val projectItem = args[0] as ProjectItem
            projectUtils.shareProject(context!!, projectItem, object : ProjectProcessCallback {
                override fun onComplete(result: String) {
                    defaultTip("onComplete")
                }

                override fun onError(exception: Exception) {
                    defaultTip("onError：${exception.message}")
                }
            })
        }

        registerEvent("delete_project") { args ->
            val projectItem = args[0] as ProjectItem
            projectUtils.deleteProject(context!!, projectItem, object : ProjectProcessCallback {
                override fun onComplete(result: String) {
                    defaultTip("onComplete")
                    if (::currViewModel.isInitialized) {
                        (currViewModel as MainViewModel).updateProjectsList(projectItem.projectType)
                    }
                }

                override fun onError(exception: Exception) {
                    defaultTip("onError：${exception.message}")
                }
            })
        }

        registerEvent("rename_project") { args ->
            val projectItem = args[0] as ProjectItem
            val file = File(projectItem.projectPath)
            val renameFileDlg =
                dialogs.createRenameDialog(context!!, file, object : OnCompleteListener {
                    override fun onSucceed() {
                        if (::currViewModel.isInitialized) {
                            (currViewModel as MainViewModel).updateProjectsList(projectItem.projectType)
                        }
                    }

                    override fun onError(msg: String) {
                    }

                })
            renameFileDlg.show()
        }

        registerEvent("help_roster") { args ->
            context?.skipToActivity(HelpRosterActivity::class.java)
        }


    }

    fun setViewModel(viewModel: ViewModel) {
        currViewModel = viewModel
    }


    companion object {
        private val instance: EventManager by lazy { EventManager() }
        fun getEventManagerInstance(): EventManager = instance
    }
}