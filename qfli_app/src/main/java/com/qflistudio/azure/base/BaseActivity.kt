package com.qflistudio.azure.base

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.window.OnBackInvokedCallback
import androidx.activity.OnBackPressedCallback
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import com.qflistudio.azure.R
import com.qflistudio.azure.common.datastore.SettingsDataStore
import com.qflistudio.azure.common.ktx.setGlobalSettingsManager
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.manager.AccountManager
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.manager.HistoryManager
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.manager.LuaAppManager
import com.qflistudio.azure.manager.ManagerCenter
import com.qflistudio.azure.manager.SettingsManager
import com.qflistudio.azure.manager.ThemeManager


abstract class BaseActivity<V : ViewBinding, T : ViewModel>(private val useActionBar: Boolean = false) :
    AppCompatActivity() {

    open val TAG = "BaseActivity"
    private var pressedParameter: Long = 0
    private var onBackInvokedCallback: OnBackInvokedCallback? = null
    protected var lastBackTime = System.currentTimeMillis()
    protected var optionsMenu: Menu? = null
    private var rootView: View? = null

    lateinit var viewBinding: V
    lateinit var viewModel: T

    lateinit var settingsDataStore: SettingsDataStore
    lateinit var sharedPreferences: SharedPreferences

    // 主题管理器
    lateinit var settingsManager: SettingsManager

    // 事件管理器
    var historyManager = HistoryManager()

    // 事件管理器
    lateinit var eventManager: EventManager
    lateinit var managerCenter: ManagerCenter

    // LuaApp管理器
    lateinit var luaAppManager: LuaAppManager
    lateinit var httpManager: HttpManager
    lateinit var accountManager: AccountManager
    lateinit var themeManager: ThemeManager
    lateinit var themeColors: ThemeManager.ThemeColors


    // 双击退出间隔时间设置
    private val DOUBLE_BACK_PRESS_INTERVAL: Long = 2000  // 2秒钟
    var shouldHandleBackPress = true  // 控制是否执行父类的逻辑


    @SuppressLint("RestrictedApi")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 设置数据库初始化
        settingsDataStore = SettingsDataStore(this)
        // 获取 SharedPreferences 实例
        sharedPreferences = getSharedPreferences("appSettings", Context.MODE_PRIVATE)
        themeManager = ThemeManager()
        themeManager.init(this, useActionBar)
        // 设置布局
        setContentView(getViewBindingImp().root)

        viewModel = ViewModelProvider(
            this,
            ViewModelProvider.NewInstanceFactory.instance
        )[getViewModelClass()]

        observeViewModel()

        // 设置自定义的返回按键处理
        setOnBackPressedDispatcher()
        initManagers(this)
        viewModelStore
    }


    fun initActionBar(toolbar: Toolbar, mainTitle: Any, backBtnState: Boolean) {
        initActionBar(toolbar, mainTitle, null, backBtnState)
    }

    fun initActionBar(toolbar: Toolbar, mainTitle: Any) {
        initActionBar(toolbar, mainTitle, null, null)
    }

    fun initActionBar(toolbar: Toolbar, mainTitle: Any?, subTitle: Any?, backBtnState: Boolean?) {
        setSupportActionBar(toolbar)

        if (backBtnState != false) {
            // 默认启用返回按钮
            supportActionBar?.setDisplayHomeAsUpEnabled(true)
            supportActionBar?.setHomeButtonEnabled(true) // 可选，确保可点击
            val drawable = ContextCompat.getDrawable(this, R.drawable.twotone_arrow_back_black_24)
            drawable?.setTint(themeColors.colorAccent) // 设置颜色
            supportActionBar?.setHomeAsUpIndicator(drawable) // 应用新的返回图标
        }

        // 处理ActionBar标题
        var realMainTitle = ""
        var realSubTitle = ""

        if (mainTitle is String) {
            realMainTitle = mainTitle
        } else if (mainTitle is Int) {
            realMainTitle = getString(mainTitle)
        }

        if (subTitle is String) {
            realSubTitle = subTitle
        } else if (subTitle is Int) {
            realSubTitle = getString(subTitle)
        }

        supportActionBar?.apply {
            title = realMainTitle
            subtitle = realSubTitle
        }
    }

    fun initManagers(context: Context) {
        settingsManager = SettingsManager()
        managerCenter = ManagerCenter()
        settingsManager.init(context)
        httpManager = HttpManager()
        httpManager.init(5)
        accountManager = AccountManager()
        accountManager.init(context, httpManager)
        if (!::themeManager.isInitialized) {
            themeManager = ThemeManager()
        }
        themeColors = themeManager.themeColors
        // 初始化 EventManager
        eventManager = EventManager.getEventManagerInstance()
        eventManager.init(context)
        eventManager.setGlobalView(viewBinding.root)
        eventManager.setViewModel(viewModel)
        // 初始化Lua组件管理器
        luaAppManager = LuaAppManager.getLAManagerInstance()
        eventManager.setLAManager(luaAppManager)
        eventManager.setTManager(themeManager)

        historyManager.init(context)
        managerCenter.setThemeManager(themeManager)
        managerCenter.setEventManager(eventManager)

        setGlobalSettingsManager(settingsManager)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        initManagers(this)
        if ((newConfig.uiMode and Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES) {
            Log.d("ThemeChange", "切换到深色模式")
        } else {
            Log.d("ThemeChange", "切换到浅色模式")
        }
    }

    override fun onResume() {
        super.onResume()
        // 重新初始化事件管理器
        eventManager.initContext(this)
        eventManager.setViewModel(viewModel)
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        this.optionsMenu = menu
        //call iconColor when call support method
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                finish() // 关闭当前 Activity
                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun getViewBindingImp(): V {
        if (!this::viewBinding.isInitialized) {
            viewBinding = getViewBindingInstance()
        }
        return viewBinding
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onDestroy() {
        super.onDestroy()
    }

    open fun observeViewModel() {}

    abstract fun getViewModelClass(): Class<T>

    abstract fun getViewBindingInstance(): V

    fun setRootView(view: View) {
        rootView = view
    }

    // 双击返回键退出的处理逻辑
    private fun setOnBackPressedDispatcher() {
        // 创建 OnBackPressedCallback 并实现它的 handleOnBackPressed 方法
        val callback = object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                handleCustomBackPressed()

                if (shouldHandleBackPress) {
                    if (pressedParameter + DOUBLE_BACK_PRESS_INTERVAL > System.currentTimeMillis()) {
                        finish() // 退出活动
                    } else {
                        (rootView ?: this@BaseActivity).showTip(R.string.back_tip)
                        pressedParameter = System.currentTimeMillis()
                    }
                }
            }
        }

        // 将回调添加到 onBackPressedDispatcher 中
        onBackPressedDispatcher.addCallback(this, callback)
    }


    // 子类可以重写这个方法来添加自定义的返回按钮事件
    open fun handleCustomBackPressed() {
        shouldHandleBackPress = true  // 确保父类的逻辑在子类不阻止时执行
    }

    // 获取 EventManager 实例
    fun getEmInstance(): EventManager {
        if (!::eventManager.isInitialized) {
            initManagers(this)
        }
        return eventManager
    }

    // 获取 LuaAppManager 实例
    fun getLAmInstance(): LuaAppManager {
        return luaAppManager
    }

    // 获取 ThemeManager 实例
    fun getThmInstance(): ThemeManager {
        return themeManager
    }

    // 获取 SettingsManager 实例
    fun getSmInstance(): SettingsManager {
        return settingsManager
    }

    fun getHmInstance(): HttpManager {
        return httpManager
    }

    fun getAmInstance(): AccountManager {
        return accountManager
    }

    fun getMCInstance(): ManagerCenter {
        return managerCenter
    }

}