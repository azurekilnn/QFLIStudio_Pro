package com.qflistudio.azure.ui

import FileCopyProgressCallback
import OnCompleteListener
import com.qflistudio.azure.util.PathUtils
import android.content.Context
import android.content.Intent
import android.graphics.RenderEffect
import android.graphics.Shader
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.view.View
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.SearchView
import androidx.fragment.app.Fragment
import androidx.viewpager.widget.ViewPager
import com.androlua.LuaUtil
import com.hzy.libp7zip.P7ZipApi
import com.luastudio.azure.AzureLibrary
import com.luastudio.azure.activity.LuaMainActivity
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.BaseViewPagerAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.common.AzureProgressDialog
import com.qflistudio.azure.common.Dialogs
import com.qflistudio.azure.common.datastore.SettingsDataStore
import com.qflistudio.azure.common.ktx.contactQQ
import com.qflistudio.azure.common.ktx.getJavaClass
import com.qflistudio.azure.common.ktx.showSnackBar
import com.qflistudio.azure.databinding.ActivityMainBinding
import com.qflistudio.azure.ui.fragment.pages.AccountFragment
import com.qflistudio.azure.ui.fragment.pages.BinFragment
import com.qflistudio.azure.ui.fragment.pages.HomeFragment
import com.qflistudio.azure.ui.fragment.pages.SecondFragment
import com.qflistudio.azure.ui.fragment.pages.ThirdFragment
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.LuaAppUtils
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.util.ResUtils
import com.qflistudio.azure.util.ZipUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File


class MainActivity : BaseActivity<ActivityMainBinding, MainViewModel>() {
    private var showMenuState = true // 控制菜单是否显示
    private lateinit var searchItem: MenuItem
    private lateinit var context: Context
    private lateinit var searchView: SearchView
    override val TAG = "MainActivity"
    private lateinit var resUtils: ResUtils
    private val fileUtils = FileUtils()
    private var dialogs = Dialogs()
    private val mainTitles = listOf(
        R.string.application_name,
        R.string.project,
        R.string.tools_text,
        R.string.recycle_bin_text,
        R.string.my_account
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        val startTime = System.currentTimeMillis()
        // 初始化 EventManager
        resUtils = ResUtils()
        context = this
        // 顶栏
        initActionBar(
            viewBinding.toolbarInclude.toolbar,
            R.string.application_name,
            R.string.application_name,
            false
        )

        dialogs.setTManager(themeManager)
        viewBinding.activityMainRoot.layoutTransition = resUtils.newLayoutTransition()
        initMainViewPager()
        initSurface()
        // initBusybox(this)
        // importCEnv()
        viewModel.runAsync { loadLuaAppList() }
        viewModel.runAsync { loadAllProjectsList() }
        viewModel.runAsync { checkOldLuaStudioDir() }
//        val endTime = System.currentTimeMillis()
//        Log.i(TAG, "Task duration: ${endTime - startTime} ms")

        // 格式化文件备份
        fileUtils.loadBinListWithView(this, viewModel, "format_file")
        // 自动保存文件备份
        fileUtils.loadBinListWithView(this, viewModel, "auto_save")
        // 回收站
        fileUtils.loadBinListWithView(this, viewModel, "bin")
//        loadBinList(this, "bin/projects_bin")
//        loadBinList(this, "bin/files_bin")

        // 获取通过 Intent 传递的异常信息
        val exceptionMessage = intent.getStringExtra("EXCEPTION_MESSAGE")
        val exceptionStackTrace = intent.getStringExtra("EXCEPTION_STACKTRACE")

        // 你可以在 UI 上显示异常信息，或做其他处理
        exceptionMessage?.let {
            Log.e("MainActivity", "Exception Message: $it")
        }

        exceptionStackTrace?.let {
            Log.e("MainActivity", "Exception Stacktrace: $it")
        }

        // 例如，显示一个 Toast 或 AlertDialog 来告知用户
        if (exceptionMessage != null) {
            val errorDialog = dialogs.createErrorDialog(
                this, exceptionMessage,
                object : OnCompleteListener {
                    override fun onSucceed() {
                    }

                    override fun onError(msg: String) {
                        AzureUtils().copyToClipboard(context, msg)
                        contactDev()
                    }
                })
            errorDialog.show()
        } else {
            historyManager.openLastOpenedProject()
        }

        PathUtils.getLuaEnvDir("res/templates")

        val luaStudioDir =
            context.getDir("luastudio", Context.MODE_PRIVATE).getAbsolutePath()
        val mixProjectRes = "$luaStudioDir/res.zip"

        val luaStudioRes = PathUtils.getLuaCustomDir("res")
        LuaUtil.unZip(mixProjectRes, luaStudioRes)


    }


    fun checkOldLuaStudioDir() {
        val oldLuaStudioExtDir = AzureLibrary.luaExtDir
        val newLuaStudioExtDir = PathUtils.getLuaStudioExtDir()
        val oldLuaStudioExtDirFile = File(oldLuaStudioExtDir)
        val newLuaStudioExtDirFile = File(newLuaStudioExtDir)


        if (oldLuaStudioExtDirFile.exists() && !newLuaStudioExtDirFile.exists()) {
            // 如果原来的路径存在 新的路径不存在
            FileUtils().copyFolderWithProgress(
                this,
                oldLuaStudioExtDirFile,
                newLuaStudioExtDirFile,
                object : FileCopyProgressCallback {
                    override fun onProgressUpdate(
                        progress: Int,
                        fileName: String,
                        speed: String,
                        sourceFolder: String,
                        destinationFolder: String,
                    ) {
                        Log.d(
                            "CopyProgress", "Progress: $progress%, File: $fileName, Speed: $speed"
                        )
                    }

                    override fun onComplete() {
                        Log.d("CopyProgress", "Copy complete!")
                        File(oldLuaStudioExtDir).delete()
                    }

                    override fun onError(exception: Exception) {
                        Log.e("CopyProgress", "Error occurred: ${exception.message}")
                    }
                })
        }
    }

    fun initBusybox(context: Context) {
        val progressDialog = AzureProgressDialog(context).apply {
            setTitle(R.string.installing_busybox_text)
            setMessage(R.string.extracting_text)
            setIndeterminate(true)
            setCancelable(false)
            show()
        }

        CoroutineScope(Dispatchers.IO).launch {
            delay(1000)
            val installStatus = installBusybox(context)
            if (installStatus) {
                viewBinding.root.showSnackBar("安装Busybox成功！")
            } else {
                viewBinding.root.showSnackBar("安装Busybox失败！")
            }
            progressDialog.dismiss()
        }
    }

    fun installBusybox(context: Context): Boolean {
        // APK 中 assets 目录下的文件名
        val assetName = "busybox"
        // 获取解压后的文件路径
        val targetFile = File(context.filesDir, assetName)
        val symlinkPath = File(context.filesDir, "sh").absolutePath  // 符号链接路径
        // 如果目标文件存在
        if (targetFile.exists()) {
            return true
        }
        // 解压 busybox 文件到应用的内部存储文件目录
        val extractStatus =
            FileUtils().extractAssetToFile(context, assetName, targetFile.absolutePath)
        if (extractStatus) {
            FileUtils().setFilePermissions(targetFile)
            // 创建符号链接
            FileUtils().createSymlink(targetFile.absolutePath, symlinkPath)
            return true
        }
        return false
    }

    private fun loadLuaAppList() {
        // 加载项目列表
        val luaAppUtils = LuaAppUtils()
        val localDir = this.getDir("luastudio", Context.MODE_PRIVATE).absolutePath
        val luaAppDir = "$localDir/activity"
        val appItemsList = luaAppUtils.loadAllLuaAppInfo(this, luaAppDir)

        // 设置项目列表到 ViewModel
        viewModel.setMyLuaAppItems(appItemsList)
    }

    private fun loadProjectsList(projectType: String) {
        ProjectUtils().reloadLocalProjectsList(this, viewModel, projectType)
    }

    private fun loadAllProjectsList() {
        loadProjectsList("lua")
        loadProjectsList("java")
        loadProjectsList("python")
        loadProjectsList("c")
        loadProjectsList("cpp")
    }


    fun applyBlurEffect(view: View) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // 使用 RenderEffect 进行模糊效果
            val renderEffect: RenderEffect =
                RenderEffect.createBlurEffect(25f, 25f, Shader.TileMode.CLAMP)
            view.setRenderEffect(renderEffect)
        }
    }

    override fun observeViewModel() {
        super.observeViewModel()
    }

    fun initMainViewPager() {
        // 外层主页
        val mainFragments = listOf(
            HomeFragment(), SecondFragment(), ThirdFragment(), BinFragment(), AccountFragment()
        )
        val mainViewPagerAdapter = createViewPagerAdapter(mainFragments, mainTitles)
        viewBinding.mainViewPager.adapter = mainViewPagerAdapter
        // 将 BottomNavigationView 与 ViewPager 绑定
        setupViewPagerWithBottomNav()
        viewBinding.mainViewPager.currentItem = 1
        viewBinding.mainViewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int,
            ) {
                // 这里是页面正在滑动时的回调
                if (::searchItem.isInitialized) {
                    closeSearchBar()
                }
                if (position == 0 || position == 1) {
                    toggleMenuVisibility(true)
                } else {
                    toggleMenuVisibility(false)
                }
            }

            override fun onPageSelected(position: Int) {
                // 这里是新页面选中后的回调
                Log.d("ViewPager", "当前页面: $position")
            }

            override fun onPageScrollStateChanged(state: Int) {
                // 这里是滑动状态变化时的回调
                when (state) {
                    ViewPager.SCROLL_STATE_IDLE -> Log.d("ViewPager", "停止滑动")
                    ViewPager.SCROLL_STATE_DRAGGING -> Log.d("ViewPager", "用户正在拖动")
                    ViewPager.SCROLL_STATE_SETTLING -> Log.d("ViewPager", "正在自动滑动")
                }
            }
        })

//        val navView: BottomNavigationView = binding.navView
//        val navController = findNavController(R.id.nav_host_fragment_activity_main)
//        val appBarConfiguration = AppBarConfiguration(
//            setOf(
//                R.id.navigation_home, R.id.navigation_widgets, R.id.navigation_recycle_bin, R.id.navigation_cloud, R.id.navigation_account
//            )
//        )
//        setupActionBarWithNavController(navController, appBarConfiguration)
//        navView.setupWithNavController(navController)
    }


    fun initSurface() {
        //自定义更多按钮颜色
        val overflowIcon = viewBinding.toolbarInclude.toolbar.overflowIcon
        overflowIcon?.setTint(themeColors.colorAccent)
        viewBinding.toolbarInclude.toolbar.overflowIcon = overflowIcon
    }


    fun createProject() {
        val createProjectDialog = dialogs.createLocalProjectDialog(
            this, viewBinding.mainViewpagerRoot
        ) { createProjectStatus, projectType ->
            if (createProjectStatus) {
                loadProjectsList(projectType)
            }
        }
        createProjectDialog.show()
    }

    private fun createViewPagerAdapter(
        fragments: List<Fragment>, titles: List<Int>,
    ): BaseViewPagerAdapter {
        val adapter = BaseViewPagerAdapter(this, supportFragmentManager, fragments, titles)
        return adapter
    }

    fun closeSearchBar() {
        searchItem.collapseActionView()  // 折叠搜索框
        viewModel.setProjectsListSearchKey("")
    }

    fun contactDev() {
        context.contactQQ("1665673737")
    }

    // 主页右上角更多菜单
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        if (showMenuState) {

            menuInflater.inflate(R.menu.menu_main_popup, menu)
            // 获取搜索菜单项
            searchItem = menu?.findItem(R.id.action_search)!!
            searchView = searchItem.actionView as SearchView
            searchView.setIconifiedByDefault(true) // 默认展开
            // 监听 SearchView 折叠状态，确保按钮不会消失
            searchView.setOnCloseListener {
                closeSearchBar()
                invalidateOptionsMenu()  // 重新绘制 Menu，确保搜索按钮还在
                false
            }

            // 监听搜索输入
            searchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
                override fun onQueryTextSubmit(query: String?): Boolean {
                    Log.i(TAG, "onQueryTextSubmit" + query.toString())
                    viewModel.setProjectsListSearchKey(query.toString())
                    // 处理搜索提交逻辑
                    return true
                }

                override fun onQueryTextChange(newText: String?): Boolean {
                    Log.i(TAG, "onQueryTextChange" + newText.toString())
                    // 处理实时搜索
                    if (newText.toString() == "") {
                        viewModel.setProjectsListSearchKey(newText.toString())
                    }
                    return true
                }
            })

            return super.onCreateOptionsMenu(menu)
        }
        return false // 返回 false 表示不创建菜单
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        super.onOptionsItemSelected(item)
        closeSearchBar()
        when (item.itemId) {
            R.id.main_create_project -> createProject()
            R.id.main_donation -> donateDev()
            R.id.main_contact_dev -> contactDev()
            R.id.main_join_qqgroup -> donateDev()
            R.id.main_project_url -> donateDev()
            R.id.import_py_env -> importPyEnv()
        }
        return true
    }

    // 通过此方法切换菜单显隐
    fun toggleMenuVisibility(show: Boolean) {
        showMenuState = show
        invalidateOptionsMenu() // 强制刷新菜单
    }


    fun donateDev() {

    }

    private fun startLuaMainActivity() {
        val intent = Intent(
            this@MainActivity, LuaMainActivity::class.java
        )
        startActivity(intent)
    }


    private fun setupViewPagerWithBottomNav() {
        // 绑定 BottomNavigationView 的 item 选择监听器
        viewBinding.navView.setOnItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.navigation_home -> viewBinding.mainViewPager.currentItem = 0
                R.id.navigation_projects -> viewBinding.mainViewPager.currentItem = 1
                R.id.navigation_widgets -> viewBinding.mainViewPager.currentItem = 2
                R.id.navigation_recycle_bin -> viewBinding.mainViewPager.currentItem = 3
                R.id.navigation_account -> viewBinding.mainViewPager.currentItem = 4
            }
            true
        }

        // ViewPager 页面切换时，更新 BottomNavigationView 选中的 item
        viewBinding.mainViewPager.addOnPageChangeListener(object :
            ViewPager.SimpleOnPageChangeListener() {
            override fun onPageSelected(position: Int) {
                when (position) {
                    0 -> viewBinding.navView.selectedItemId = R.id.navigation_home
                    1 -> viewBinding.navView.selectedItemId = R.id.navigation_projects
                    2 -> viewBinding.navView.selectedItemId = R.id.navigation_widgets
                    3 -> viewBinding.navView.selectedItemId = R.id.navigation_recycle_bin
                    4 -> viewBinding.navView.selectedItemId = R.id.navigation_account
                }
                updateToolbarTitle(position)
            }
        })
    }

    private fun updateToolbarTitle(position: Int) {
        // 根据当前选中的 Fragment 更新 Toolbar 的标题
        val title = getString(mainTitles[position])
        supportActionBar?.title = title
        supportActionBar?.subtitle = when (position) {
            1 -> PathUtils.getLuaProjectsDir()
            else -> getString(R.string.application_name)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun importCEnv() {
        val envDir = PathUtils.getStudioENVDir("cppEnv")
        val envFilePath = "$envDir/llvm_arm64_v8a.tar.xz"
        Log.i(TAG, envFilePath)
        if (File(envFilePath).exists()) {
            CoroutineScope(Dispatchers.IO).launch {
                ZipUtils().unTarXz(envFilePath, filesDir.absolutePath)
            }
        }

    }

    private fun importPyEnv() {
        val envDir = PathUtils.getStudioENVDir("pyEnv")
        val envFilePath = "$envDir/python.7z"
        if (File(envFilePath).exists()) {
            extractPyEnvFiles(envFilePath)
        }
    }

    fun importEnvFile(fileDir: String, fileName: String) {

    }

    private fun extractPyEnvFiles(envFilePath: String) {
        val dataStore = SettingsDataStore(this)
        val progressDialog = AzureProgressDialog(this).apply {
            setTitle(R.string.import_py_env_text)
            setMessage(R.string.extracting_text)
            setIndeterminate(true)
            setCancelable(false)
            show()
        }

        CoroutineScope(Dispatchers.IO).launch {
            // dataStore.updateFileStatus(false)
            CoroutineScope(Dispatchers.IO).launch {
                val temp7zStream = File(envFilePath)
                val exitCode =
                    P7ZipApi.executeCommand("7z x ${temp7zStream.absolutePath} -o${filesDir.absolutePath}")
                Log.d(TAG, "extractFiles: $exitCode")
                CoroutineScope(Dispatchers.IO).launch {
                    // dataStore.updateFileStatus(true)
                    progressDialog.dismiss()
                }
            }
        }
    }

    override fun getViewModelClass(): Class<MainViewModel> {
        return getJavaClass()
    }

    override fun getViewBindingInstance(): ActivityMainBinding {
        return ActivityMainBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        viewModel.runAsync { loadAllProjectsList() }
        viewModel.runAsync { loadLuaAppList() }
    }


}