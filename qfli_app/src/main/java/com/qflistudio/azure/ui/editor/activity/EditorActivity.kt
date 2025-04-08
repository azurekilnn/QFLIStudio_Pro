package com.qflistudio.azure.ui.editor.activity

import OnCodeListener
import OnColorSelectedListener
import OnCompleteListener
import OpGroupItem
import ProjectItem
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.Rect
import android.graphics.Typeface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import android.text.Editable
import android.text.TextWatcher
import android.text.method.DigitsKeyListener
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.KeyEvent
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.appcompat.widget.PopupMenu
import androidx.appcompat.widget.TooltipCompat
import androidx.core.graphics.toColorInt
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.DefaultItemAnimator
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.card.MaterialCardView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import com.luajava.LuaException
import com.luastudio.azure.widget.PhotoView
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.EditorFileListAdapter
import com.qflistudio.azure.adapter.ExpandedListAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.bean.EditorFileListItem
import com.qflistudio.azure.callback.OnEditorViewCreatedCallback
import com.qflistudio.azure.common.Dialogs
import com.qflistudio.azure.common.Keys
import com.qflistudio.azure.common.ktx.addLayoutTransition
import com.qflistudio.azure.common.ktx.getJavaClass
import com.qflistudio.azure.common.ktx.isColorLight
import com.qflistudio.azure.common.ktx.isLuaFile
import com.qflistudio.azure.common.ktx.isLuaIDE
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.common.ktx.setFullScreenBottomSheetDlg
import com.qflistudio.azure.common.ktx.setToolTip
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.common.ktx.startRotateInvertedAnim
import com.qflistudio.azure.common.ktx.startRotateStraightAnim
import com.qflistudio.azure.data.EditorData
import com.qflistudio.azure.databinding.ActivityEditorMainBinding
import com.qflistudio.azure.editor.CodeEditor
import com.qflistudio.azure.manager.EditorManager
import com.qflistudio.azure.ui.editor.EditorViewModel
import com.qflistudio.azure.ui.editor.adapter.EditorViewPagerAdapter
import com.qflistudio.azure.ui.termux.activity.TermuxActivity
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.EditorUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.LuaUtils
import com.qflistudio.azure.util.PathUtils
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.util.ResUtils
import com.qflistudio.azure.util.getSelectedText
import io.github.rosemoe.sora.event.ContentChangeEvent
import io.github.rosemoe.sora.event.EditorKeyEvent
import io.github.rosemoe.sora.event.KeyBindingEvent
import io.github.rosemoe.sora.event.LongPressEvent
import io.github.rosemoe.sora.event.PublishSearchResultEvent
import io.github.rosemoe.sora.event.SelectionChangeEvent
import io.github.rosemoe.sora.event.SideIconClickEvent
import io.github.rosemoe.sora.lang.EmptyLanguage
import io.github.rosemoe.sora.lang.diagnostic.DiagnosticRegion
import io.github.rosemoe.sora.lang.diagnostic.DiagnosticsContainer
import io.github.rosemoe.sora.langs.textmate.TextMateLanguage
import io.github.rosemoe.sora.langs.textmate.registry.ThemeRegistry
import io.github.rosemoe.sora.langs.textmate.registry.model.DefaultGrammarDefinition
import io.github.rosemoe.sora.text.ContentIO
import io.github.rosemoe.sora.text.LineSeparator
import io.github.rosemoe.sora.utils.codePointStringAt
import io.github.rosemoe.sora.utils.escapeCodePointIfNecessary
import io.github.rosemoe.sora.widget.EditorSearcher
import io.github.rosemoe.sora.widget.SelectionMovement
import io.github.rosemoe.sora.widget.component.EditorAutoCompletion
import io.github.rosemoe.sora.widget.component.EditorTextActionWindow
import io.github.rosemoe.sora.widget.ext.EditorSpanInteractionHandler
import io.github.rosemoe.sora.widget.schemes.EditorColorScheme
import io.github.rosemoe.sora.widget.schemes.SchemeDarcula
import io.github.rosemoe.sora.widget.schemes.SchemeEclipse
import io.github.rosemoe.sora.widget.schemes.SchemeGitHub
import io.github.rosemoe.sora.widget.schemes.SchemeNotepadXX
import io.github.rosemoe.sora.widget.schemes.SchemeVS2019
import io.github.rosemoe.sora.widget.style.LineInfoPanelPosition
import io.github.rosemoe.sora.widget.style.LineInfoPanelPositionMode
import io.github.rosemoe.sora.widget.subscribeAlways
import io.github.rosemoe.sora.widget.subscribeEvent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.eclipse.tm4e.core.registry.IGrammarSource
import org.eclipse.tm4e.core.registry.IThemeSource
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.regex.PatternSyntaxException

open class EditorActivity : BaseActivity<ActivityEditorMainBinding, EditorViewModel>(),
    OnEditorViewCreatedCallback {
    override val TAG = "EditorActivity"
    private lateinit var editorViewPagerAdapter: EditorViewPagerAdapter
    private lateinit var context: Context
    private lateinit var currentEditorViewType: String
    private lateinit var currentEditor: CodeEditor
    private lateinit var currentPhotoView: PhotoView
    private var currentOpenedFile: File? = null
    private var dialogs = Dialogs()
    private lateinit var fileListAdapter: EditorFileListAdapter
    private var isFirstResume = true

    // 懒加载初始化模块
    private val editorUtils: EditorUtils by lazy { EditorUtils() }
    private lateinit var editorManager: EditorManager
    private val resUtils: ResUtils by lazy { ResUtils() }
    private val luaUtils: LuaUtils by lazy { LuaUtils() }
    private val fileUtils: FileUtils by lazy { FileUtils() }
    private val projectUtils: ProjectUtils by lazy { ProjectUtils() }

    private lateinit var editorMode: String
    private var argbDialog: BottomSheetDialog? = null
    private var insertCodeDlg: BottomSheetDialog? = null
    private lateinit var currOpenedProjPath: String
    private var editorSearchMode: Boolean = false
    private var editorSearchOptions = EditorSearcher.SearchOptions(true, false)

    private var editorSearchOptionRegex: Boolean = false
    private var editorSearchOptionWholeWord: Boolean = false
    private var editorSearchOptionCaseInsensitive: Boolean = true

    private lateinit var editorToolBar: LinearLayoutCompat
    private lateinit var editorControlBar: LinearLayoutCompat
    private lateinit var editorSearchBar: LinearLayoutCompat
    private lateinit var editorEditBar: LinearLayoutCompat
    private lateinit var messageBar: LinearLayoutCompat
    private lateinit var errorBar: MaterialCardView

    private lateinit var projectPath: String
    private lateinit var projectDirPath: String
    private lateinit var mainFilePath: String
    private lateinit var editBarMode: String
    private var initState: Boolean = false
    private var fileUpdateState: Boolean = true

    private lateinit var currOpenedProjectItem: ProjectItem
    private var currentOpenedDir: String = PathUtils.getStudioExtDir()
    private lateinit var currentProjectsList: MutableList<EditorFileListItem>

    private lateinit var filePickerLauncher: ActivityResultLauncher<Intent>

    @RequiresApi(Build.VERSION_CODES.M)
    @SuppressLint("RtlHardcoded")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //CrashHandler.INSTANCE.init(this)
        dialogs.setTManager(themeManager)
        context = this
        editorManager = EditorManager(this, fileUtils)
        editorManager.init()
        // 获取编辑器模式
        initSurface()
        initViewPager()
        initLeftSideBar()

        initEditorMode(intent)
        loadSymbolsBarAsync()
        loadOperationsBarAsync()
        // Configure symbol input view
//        val inputView = viewBinding.symbolInput
//        inputView.bindEditor(binding.editor)
//        inputView.addSymbols(SYMBOLS, SYMBOL_INSERT_TEXT)
//        inputView.forEachButton { it.typeface = typeface }

        initIncidents()

        val windowMetrics =
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                // 对于 Android 11（API 级别 30）及以上版本使用 WindowMetrics
                val windowInsets = windowManager.currentWindowMetrics
                windowInsets.bounds
            } else {
                // 对于低版本设备仍使用旧方法
                val metric = DisplayMetrics()
                windowManager.defaultDisplay.getMetrics(metric)
                Rect(0, 0, metric.widthPixels, metric.heightPixels)
            }
        val windowsWidth = windowMetrics.width()
        val windowsHeight = windowMetrics.height()
        val leftMenu: View = findViewById(R.id.right_sidebar)
        val leftParams = leftMenu.layoutParams
        leftParams.height = windowsHeight
        leftParams.width = windowsWidth
        leftMenu.layoutParams = leftParams


        // 初始化文件选择器
        filePickerLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result: ActivityResult ->
                if (result.resultCode == Activity.RESULT_OK) {
                    result.data?.data?.let { uri ->
                        val filePath = getFilePathFromUri(uri)
                        Log.d("FilePicker", "选中文件路径: $filePath")
                    }
                }
            }


    }


    private fun initLeftSideBar() {
        val fileRv = viewBinding.editorLeftSidebar.editorFileRv
        val leftRefreshLayout = viewBinding.editorLeftSidebar.leftSidebarRefreshLayout
        val fileAddBtn = viewBinding.editorLeftSidebar.chAddFile
        val projListButton = viewBinding.editorLeftSidebar.projListButton
        viewBinding.editorLeftSidebar.apply {
            searchEdit.addTextChangedListener(object : TextWatcher {
                override fun afterTextChanged(s: Editable?) {
                    // 用户输入后触发
                    val searchText = s?.toString() ?: ""  // 如果 s 为 null，则返回空字符串
                    loadFilesListAsync(currentOpenedDir, searchText)
                }

                override fun beforeTextChanged(
                    s: CharSequence?,
                    start: Int,
                    count: Int,
                    after: Int,
                ) {
                    // 输入前触发
                }

                override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                    // 监听输入时的变化
                    Log.d("Search", "User typed: $s")
                }
            })
        }
        fileListAdapter = EditorFileListAdapter(themeManager)
        // 文件列表
        fileListAdapter.setOnItemClick { holder, position ->
            val file = holder.fileItem.file
            if (file.isDirectory) {
                loadFilesList(file.absolutePath)
            } else if (file.isFile) {
                viewBinding.drawerLayout.closeDrawers()
                openFileByEditor(file.absolutePath)
            }
        }

        fileListAdapter.setOnItemLongClick { holder, position ->
            val file = holder.fileItem.file
            val fileItemRoot = holder.itemView
            val fileCheckboxRoot = holder.fileCheckboxRoot
            // 创建 PopupMenu
            val popupMenu = PopupMenu(this, fileItemRoot)
            // 获取 MenuInflater
            val inflater = popupMenu.menuInflater
            inflater.inflate(R.menu.menu_editor_file_op_popup, popupMenu.menu)

            if (checkMainFilePath(file, editorMode)) {
                popupMenu.menu.findItem(R.id.editor_file_rename)?.isVisible = false
                popupMenu.menu.findItem(R.id.editor_file_delete)?.isVisible = false
            } else {
                popupMenu.menu.findItem(R.id.editor_file_rename)?.isVisible = true
                popupMenu.menu.findItem(R.id.editor_file_delete)?.isVisible = true
            }
            if (fileUtils.isLuaFile(file.absolutePath)) {
                popupMenu.menu.findItem(R.id.editor_compile_lua)?.isVisible = true
            } else {
                popupMenu.menu.findItem(R.id.editor_compile_lua)?.isVisible = false
            }

            // 设置菜单项点击监听器
            popupMenu.setOnMenuItemClickListener { menuItem ->
                when (menuItem.itemId) {
                    R.id.editor_file_rename -> {
                        fileRename(file)
                        true
                    }

                    R.id.editor_file_share -> {
                        fileUtils.shareFile(this, file)
                        true
                    }

                    R.id.editor_file_delete -> {
                        val filePosition = editorViewPagerAdapter.checkFileExists(file)
                        if (filePosition != -1) {
                            closeEditorTab(filePosition)
                        }
                        deleteFile(file)
                        true
                    }

                    else -> false
                }
            }
            popupMenu.show()
            true
        }
        fileRv.adapter = fileListAdapter
        fileRv.layoutManager = LinearLayoutManager(this)
        // 观察 luaAppItemsList 的变化
        viewModel.fileItemsList.observe(this) { items ->
            // 使用项目列表数据
            fileListAdapter.updateList(items)
            leftRefreshLayout.isRefreshing = false
        }

        leftRefreshLayout.setColorSchemeColors(themeColors.colorPrimary)
        leftRefreshLayout.setOnRefreshListener {
            loadFilesListAsync(currentOpenedDir)
        }

        fileAddBtn.setOnClickListener {
            createNewFile()
        }

        projListButton.setOnClickListener {
            projectDirPath = PathUtils.getProjectsDir(editorMode)
            if (currentOpenedDir != projectDirPath) {
                loadFilesListAsync(projectDirPath)
            } else {
                loadFilesListAsync(projectPath)
            }
        }
    }

    private fun fileRename(file: File) {
        val renameFileDlg =
            dialogs.createRenameDialog(this, file, object : OnCompleteListener {
                override fun onSucceed() {
                    loadFilesListAsync(currentOpenedDir)
                    showTip(R.string.rename_succeed_tips)
                }

                override fun onError(msg: String) {
                }

            })
        renameFileDlg.show()
    }


    private fun loadOperationsBar() {
        editorEditBar = viewBinding.editBarInclude.editBar
        val editorOperationsBar = viewBinding.editorOperationsBar
        val operations = listOf(
            "cursor_actions",
            "line_info_panel_position",
            "switch_language",
            "switch_color_scheme",
            "add_file",
            "layout_helper",
            "code_format",
            "bin_project",
            "insert_code",
            "code_check",
            "import_analysis",
            "code_navigation",
            "search_code",
            "global_search_code",
            "jump_line",//"project_list",
            "project_import",
            "project_recovery",
            "project_info",
            "import_resources",
            "create_project",
            "compile_lua_file",
            "lua_course",
            "lua_explain",
            "argb_tool",
            "java_api",
            "color_reference",
            "logcat"//help_roster",
        )
        operations.forEach { operation ->
            val newTab = editorOperationsBar.newTab().setText(resUtils.getString(this, operation))
                .setTag(operation)
            editorOperationsBar.addTab(newTab, false);
            newTab.view.setOnClickListener {
                operationsBarActions(newTab, newTab.tag.toString())
            }
        }
    }


    private fun loadFilesListWithDefaultAsync() {
        loadFilesListAsync(PathUtils.getStudioExtDir())
    }

    private fun loadFilesListAsync(fileDir: String) {
        CoroutineScope(Dispatchers.Main).launch {
            loadFilesList(fileDir)
        }
    }

    private fun loadFilesListAsync(fileDir: String, keyWord: String) {
        CoroutineScope(Dispatchers.Main).launch {
            loadFilesList(fileDir, keyWord)
        }
    }

    private fun loadOperationsBarAsync() {
        // 使用协程来加载符号栏
        CoroutineScope(Dispatchers.Main).launch {
            loadOperationsBar()
        }
    }


    private fun loadSymbolsBarAsync() {
        CoroutineScope(Dispatchers.Main).launch {
            loadSymbolsBar()
        }
    }

    private fun operationsBarActions(tab: TabLayout.Tab, actionKey: String) {
        val tabView = tab.view
        val editor = currentEditor

        when (actionKey) {
            "cursor_actions" -> {
                // 创建 PopupMenu
                val popupMenu = PopupMenu(this, tabView)
                // 获取 MenuInflater
                val inflater = popupMenu.menuInflater
                inflater.inflate(R.menu.menu_editor_cursor_actions, popupMenu.menu)
                // 设置菜单项点击监听器
                popupMenu.setOnMenuItemClickListener { menuItem ->
                    when (menuItem.itemId) {
                        R.id.goto_end -> {
                            editor.setSelection(
                                editor.text.lineCount - 1,
                                editor.text.getColumnCount(editor.text.lineCount - 1)
                            )
                            true
                        }

                        R.id.move_up -> {
                            editor.moveSelection(SelectionMovement.UP)
                            true
                        }

                        R.id.move_down -> {
                            editor.moveSelection(SelectionMovement.DOWN)
                            true
                        }

                        R.id.move_left -> {
                            editor.moveSelection(SelectionMovement.LEFT)
                            true
                        }

                        R.id.move_right -> {
                            editor.moveSelection(SelectionMovement.RIGHT)
                            true
                        }

                        R.id.home -> {
                            editor.moveSelection(SelectionMovement.LINE_START)
                            true
                        }

                        R.id.end -> {
                            editor.moveSelection(SelectionMovement.LINE_END)
                            true
                        }

                        else -> false
                    }
                }

                // 显示菜单
                popupMenu.show()
            }

            "line_info_panel_position" -> {
                // 创建 PopupMenu
                val popupMenu = PopupMenu(this, tabView)
                // 获取 MenuInflater
                val inflater = popupMenu.menuInflater
                inflater.inflate(R.menu.menu_editor_ln_panel, popupMenu.menu)
                // 设置菜单项点击监听器
                popupMenu.setOnMenuItemClickListener { menuItem ->
                    when (menuItem.itemId) {
                        R.id.ln_panel_fixed -> {
                            chooseLineNumberPanelPosition()
                            true
                        }

                        R.id.ln_panel_follow -> {
                            val themes = arrayOf(
                                getString(R.string.top),
                                getString(R.string.center),
                                getString(R.string.bottom)
                            )
                            MaterialAlertDialogBuilder(this)
                                .setTitle(R.string.fixed)
                                .setSingleChoiceItems(
                                    themes,
                                    -1
                                ) { dialog: DialogInterface, which: Int ->
                                    editor.lnPanelPositionMode = LineInfoPanelPositionMode.FOLLOW
                                    when (which) {
                                        0 -> editor.lnPanelPosition = LineInfoPanelPosition.TOP
                                        1 -> editor.lnPanelPosition = LineInfoPanelPosition.CENTER
                                        2 -> editor.lnPanelPosition = LineInfoPanelPosition.BOTTOM
                                    }
                                    dialog.dismiss()
                                }
                                .setNegativeButton(android.R.string.cancel, null)
                                .show()
                            true
                        }

                        else -> false
                    }
                }

                // 显示菜单
                popupMenu.show()
            }

            "switch_language" -> {
                chooseLanguage()
            }

            "switch_color_scheme" -> {
                chooseTheme()
            }

            else -> eventManager.triggerEvent(
                actionKey,
                currOpenedProjectItem,
                currentOpenedFile,
                editorMode
            )
        }
    }


    fun setSelectedColorToCv(colorCode: String) {
        val hexColorRegex = Regex("^#?[0-9A-Fa-f]{6,8}$")  // 匹配 8 位颜色（如 ff5d6eff）
        val intColorRegex = Regex("^0x[0-9A-Fa-f]{8}$") // 匹配 0xff5d6eff 格式
        var colorInt: Int
        var isHexColor = false
        val colorString = when {
            hexColorRegex.matches(colorCode) -> {
                isHexColor = true
                colorCode.removePrefix("#")
            }
            intColorRegex.matches(colorCode) -> {
                isHexColor = false
                colorCode.removePrefix("0x")
            }
            else -> null
        }
        val defaultColor = themeColors.backgroundColor
        colorInt = defaultColor
        colorString?.let {
            val formattedColor = if (it.length == 6) "FF$it" else it // 6位颜色自动补上 Alpha 值
            try {
                colorInt = "#$formattedColor".toColorInt() // 转换为颜色
            } catch (e: IllegalArgumentException) {
                Log.e(TAG, "setSelectedColorToCv ${e.message}")
            }
        }
        viewBinding.editorInfoBarInclude.infoBar.setCardBackgroundColor(colorInt) // 设置背景颜色
        // 计算颜色亮度
        val textColor = if (colorInt.isColorLight()) Color.BLACK else Color.WHITE
        viewBinding.editorInfoBarInclude.cvBarTv.setTextColor(textColor) // 设置字体颜色

        if (defaultColor != colorInt) {
            viewBinding.editorInfoBarInclude.infoBar.setOnClickListener {
                if (argbDialog == null) {
                    argbDialog =
                        dialogs.createArgbDialog(this, colorInt, object : OnColorSelectedListener {
                            override fun onColorSelected(color: Int) {
                                val colorHex = String.format("#%08X", color) // 转换为 16 进制颜色
                                val colorValue = colorHex.removePrefix("#")
                                val realColorString: String
                                if (isHexColor) {
                                    realColorString = colorValue
                                } else {
                                    realColorString = "0x$colorValue"
                                }
                                currentEditor.pasteText(realColorString)
                            }
                        })
                }
                argbDialog!!.show()
            }
        } else {
            viewBinding.editorInfoBarInclude.infoBar.setOnClickListener {

            }
        }
    }


    fun registerEditorService(codeEditor: CodeEditor) {
        Log.i(TAG, "registerEditorService")
        viewBinding.editorViewPager.offscreenPageLimit = editorViewPagerAdapter.getEditorCount() + 1
        if (!codeEditor.getEditorInitStatus()) {
            val defaultTypeface = Typeface.MONOSPACE

            codeEditor.apply {
                typefaceText = defaultTypeface
                props.stickyScroll = true
                setLineSpacing(2f, 1.1f)
                nonPrintablePaintingFlags =
                    CodeEditor.FLAG_DRAW_WHITESPACE_LEADING or CodeEditor.FLAG_DRAW_LINE_SEPARATOR or CodeEditor.FLAG_DRAW_WHITESPACE_IN_SELECTION
                subscribeAlways<PublishSearchResultEvent> { updateEditorPositionText() }
                subscribeAlways<ContentChangeEvent> {
                    autoSaveFile()
                    postDelayedInLifecycle(
                        ::updateBtnState,
                        50
                    )
                }
                subscribeAlways<SideIconClickEvent> {
                    //toast(R.string.tip_side_icon)
                }
                subscribeEvent<LongPressEvent> { event, unsubscribe ->
                    if (editorSearchMode) {
                        hideAllBar()
                    }
                }
                subscribeEvent<SelectionChangeEvent> { event, unsubscribe ->
                    if (!editorSearchMode) {
                        if (event.isSelected) {
                            showControlBar(true)

                        } else {
                            showControlBar(false)
                        }
                    }
                    val selectedText = codeEditor.getSelectedText()
                    setSelectedColorToCv(selectedText)
                    updateEditorPositionText()
                }
                subscribeAlways<KeyBindingEvent> { event ->
                    if (event.eventType == EditorKeyEvent.Type.DOWN) {
                        Log.i(TAG, "Keybinding event: " + generateKeybindingString(event))
                    }
                }
                subscribeEvent<ContentChangeEvent> { event, unsubscribe ->
                    var errorInfo = Pair<Boolean?, String?>(true, "No Error")
                    var errorStatus = errorInfo.first  //false 有错误 true 正常
                    var errorMessage = errorInfo.second

                    if (editorMode.isLuaIDE()) {
                        errorInfo = luaUtils.checkCodeError(text.toString())
                        errorStatus = errorInfo.first  //false 有错误 true 正常
                        errorMessage = errorInfo.second
                    }

                    viewBinding.editorInfoBarInclude.errorBarTv.text = errorMessage
                    // 设置长按提示框
                    TooltipCompat.setTooltipText(errorBar, errorMessage)
                    if (errorStatus == true) {
                        viewBinding.editorInfoBarInclude.errorBarTv.setTextColor(themeColors.rightColorStateList)
                    } else {
                        viewBinding.editorInfoBarInclude.errorBarTv.setTextColor(themeColors.wrongColorStateList)
                    }

                    when (event.action) {
                        ContentChangeEvent.ACTION_SET_NEW_TEXT -> {

                        }
                    }
                }

                // Handle span interactions
                EditorSpanInteractionHandler(this)
                getComponent(EditorAutoCompletion::class.java)
                    .setEnabledAnimation(true)
            }

            //隐藏自带操作栏
            val editorTextActionWindow = codeEditor.getComponent(EditorTextActionWindow::class.java)
            editorTextActionWindow.setEnabled(false);

            // setupEditorTextmate()
            // ensureEditorTextmateTheme(codeEditor)
            editorManager.initEditor(codeEditor, editorMode)

            //codeEditor.setEditorLanguage(editorManager.getEditorLanguage(codeEditor, editorMode))

            editorManager.switchThemeIfRequired(this, codeEditor)
            bindEditorIncidents(codeEditor)
            codeEditor.setEditorInitStatus(true)
        }
    }

    private fun runFile(file: File, editorMode: String) {
        runFile(file, editorMode, null)
    }

    private fun runFile(file: File, editorMode: String, mode: Boolean?) {
        saveFile()
        when (editorMode) {
            "editor" -> {

            }

            "lua" -> {
                if (mode == true) {
                    luaUtils.skipToActivity(this, file.absolutePath, true)
                } else {
                    luaUtils.skipToActivity(this, file.absolutePath)
                }
            }

            "python" -> {
                runPyFile(file)
            }

            "c" -> {

            }

            "cpp" -> {

            }

            else -> {
                // 如果没有特殊处理，使用默认处理
                Log.w("EditorActivity", "runFile error: Unknown editor mode: $editorMode")
            }
        }
    }

    fun outputMainFilePath(projectPath: String, language: String): String {
        return if (getLuaHistFilePathExists(projectPath)) {
            // 如果存在打开的文件记录直接打开
            getLuaHistFilePath(projectPath)
        } else {
            mainFilePath = PathUtils.outputMainFilePath(projectPath, language)
            mainFilePath
        }
    }

    fun checkMainFilePath(file: File, language: String): Boolean {
        val fileName = file.name
        val filePath = file.absolutePath
        val mainFilePath = PathUtils.outputMainFilePath(projectPath, language)
        val fileWhiteList = setOf("build.lsinfo", "AndroidManifest.xml", "init.lua")
        // 判断是否是主文件路径或在白名单内
        val isMainFile = (filePath == mainFilePath || fileName in fileWhiteList)
        return (isMainFile)
    }

    // 设置工程
    fun setProject(projectPath: String, language: String) {
        currOpenedProjPath = projectPath
        var projectName = ""
        val projectDirFile = File(projectPath)
        // 输出将要打开的文件
        val mainFilePath = outputMainFilePath(projectPath, language)
        Log.i(TAG, mainFilePath)

        // 初始化第一个编辑器
        if (File(mainFilePath).exists()) {
            openFileByEditor(mainFilePath)
        } else {
            editorViewPagerAdapter.addEditor("UnTitle", "txt")
        }

        initState = true

        if (language == "lua") {
            currOpenedProjectItem = ProjectUtils().loadLuaProjectInfo(context, projectPath)
            projectName = currOpenedProjectItem.appName
            // 用于标签栏捕获相对路径
            fileUtils.setFolderPath(PathUtils.outputMainDir(projectPath, language))
        } else {
            currOpenedProjectItem = ProjectUtils().createProjectItem(
                this,
                projectDirFile.name,
                projectDirFile.absolutePath,
                editorMode
            )
            projectName = projectDirFile.name
        }
        updateOpenedProjName(projectName)
        setProgressBarVisibility(View.GONE)
    }

    private fun initEditorMode(intent: Intent) {
        historyManager.setLastOpenedProject(intent)
        editorMode = intent.getStringExtra("editorMode") ?: "editor"
        if (intent.hasExtra("projectPath")) {
            projectPath = intent.getStringExtra("projectPath").toString()
        } else {
            projectPath = PathUtils.getProjectsDir(editorMode)
        }

        if (editorMode.isLuaIDE()) {
            val subPath = PathUtils.outputMainDir(projectPath, editorMode)
            if (File(subPath).exists()) {
                loadFilesList(subPath)
            } else {
                loadFilesList(projectPath)
            }
        } else {
            loadFilesList(projectPath)
        }

        when (editorMode) {
            "editor" -> editorViewPagerAdapter.addEditor("UnTitle", "txt")
            "lua" -> {
                loadLuaProjectsListAsync(this)
                setProject(projectPath, editorMode)
            }

            else -> setProject(projectPath, editorMode)
        }

    }

    fun removeEditor() {
        reloadTabLayout()
    }

    // 回调方法，当新的编辑器视图被创建时会被调用
    override fun onEditorViewCreated(view: Any, file: File) {
        if (view is CodeEditor) {
            // 处理 CodeEditor 的视图
            currentEditorViewType = "CodeEditor"
            currentEditor = view
            currentEditor.setCurrOpenedFile(file)
            Log.i("onEditorViewCreated", file.path);
            registerEditorService(currentEditor, file)
            reloadTabLayout()
        } else {
            println("Unexpected view type")
        }
    }

    override fun onEditorViewCreated(view: Any) {
        if (view is CodeEditor) {
            // 处理 CodeEditor 的视图
            currentEditorViewType = "CodeEditor"
            currentEditor = view
            registerEditorService(currentEditor)
            reloadTabLayout()
        } else {
            println("Unexpected view type")
        }
    }

    private fun searchInLuaProjectsList(keyWord: String): MutableList<EditorFileListItem> {
        val newProjectList = mutableListOf<EditorFileListItem>()
        currentProjectsList.forEach { projectItem ->
            if (projectItem.name.searchKeyWord(keyWord) || projectItem.packageName.searchKeyWord(
                    keyWord
                )
            ) {
                newProjectList.add(projectItem)
            }
        }
        return newProjectList
    }

    private fun loadLuaProjectsListAsync(context: Context) {
        // 使用协程来加载符号栏
        CoroutineScope(Dispatchers.Main).launch {
            currentProjectsList = projectUtils.getLuaProjectsInfoAsFileItem(context)
        }
    }

    private fun loadFilesList(fileDir: String) {
        loadFilesList(fileDir, null)
    }

    private fun loadFilesList(fileDir: String, keyWord: String?) {
        if (File(fileDir).exists()) {
            val projFilesList = fileUtils.getFilesList(fileDir)
            // 创建一个列表来存储 projectItem
            var projFileItemsList = mutableListOf<EditorFileListItem>()

            val luaProjectMode = (fileDir == PathUtils.getLuaProjectsDir())

            if (luaProjectMode) {
                if (keyWord == null) {
                    projFileItemsList = currentProjectsList
                } else {
                    projFileItemsList = searchInLuaProjectsList(keyWord)
                }
            } else {
                projFilesList.forEach {
                    val fileSizeText: String
                    val fileItem: EditorFileListItem
                    if (it.isDirectory) {
                        fileSizeText = getString(R.string.folder)
                    } else {
                        fileSizeText = fileUtils.getFileSizeWithFormat(this, it)
                    }
                    if (keyWord == null || it.name.searchKeyWord(keyWord)) {
                        fileItem = EditorFileListItem(
                            it.name,
                            it,
                            it.isDirectory,
                            fileUtils.getFileExtension(it.absolutePath) ?: "text",
                            fileSizeText
                        )
                        projFileItemsList.add(fileItem)
                    }
                }
            }
            // 获取 ViewModel
            val editorViewModel = ViewModelProvider(this)[EditorViewModel::class.java]
            editorViewModel.setFileItems(projFileItemsList)
            updateOpenedDir(fileDir)
        }

    }


    fun getLuaHistFilePathExists(projectPath: String): Boolean {
        return false
    }

    fun getLuaHistFilePath(projectPath: String): String {
        return ""
    }

    fun loadLuaHistConfig(): Boolean {
        return false
    }

    private fun runPyFile(file: File) {
        if (file.exists()) {
            runPyFile(file.absolutePath)
        } else {
            showTip(R.string.file_is_not_exists)
        }
    }

    private fun runPyFile(filePath: String) {
        intent.setClass(this, TermuxActivity::class.java)
        intent.putExtra(Keys.KEY_FILE_PATH, filePath)
        startActivity(intent)
    }

    private fun updateOpenedDir(dir: String) {
        currentOpenedDir = dir
        viewBinding.editorLeftSidebar.drawerProjPathTv.text = dir
    }

    private fun isRootDir(): Boolean {
        return (currentOpenedDir == PathUtils.getStudioExtDir())
    }

    private fun updateOpenedFilePath(filePath: String) {
        viewBinding.toolbarInclude.openedFilePathTv.text = filePath

        val file = File(filePath)
        val lastModified = file.lastModified()
        val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        viewBinding.editorInfoBarInclude.fileInfoBarTv.text =
            "最后修改时间: ${sdf.format(Date(lastModified))}"
    }

    private fun updateOpenedProjName(projectName: String) {
        viewBinding.editorLeftSidebar.drawerProjTv.text = projectName
        viewBinding.toolbarInclude.mainTitleTv.text = projectName
    }

    /**
     * Update buttons state for undo/redo
     */
    private fun updateBtnState() {
        viewBinding.toolbarInclude.undoButton.isEnabled = currentEditor.canUndo()
        viewBinding.bottombarInclude.fredoButton.isEnabled = currentEditor.canRedo()
    }


    fun bindEditorIncidents(editor: CodeEditor) {

    }

    private fun deleteFile(file: File) {
        editorUtils.backupFile(this, file, "bin/files_bin")
        fileUtils.deleteFile(file)
        loadFilesListAsync(currentOpenedDir)
    }

    private fun autoSaveFile() {
        currentOpenedFile?.let {
            editorUtils.backupFile(this, it, "auto_save")
            saveFile(currentEditor, false)
            updateOpenedFilePath(it.path)
        }

    }

    private fun saveFile() {
        saveFile(currentEditor, false)
    }

    private fun saveFile(state: Boolean) {
        saveFile(currentEditor, state)
    }


    private fun saveFile(editor: CodeEditor, state: Boolean) {
        val fos = FileOutputStream(editor.getCurrOpenedFile())
        CoroutineScope(Dispatchers.IO).run {
            fos.write(editor.text.toString().toByteArray())
            fos.close()
        }
        if (state) {
            showTip(R.string.save_succeed)
        }
    }

    fun autoSwitchEditorLanguage() {

    }

    fun registerEditorService(codeEditor: CodeEditor, file: File) {
        registerEditorService(codeEditor)
        openFileByEditor(codeEditor, file)
    }

    fun registerEditorService(codeEditor: CodeEditor, filePath: String) {
        val file = File(filePath)
        registerEditorService(codeEditor, file)
    }


    private fun openAssetsFileByEditor(codeEditor: CodeEditor, name: String) {
        Thread {
            try {
                val text = ContentIO.createFrom(assets.open(name))
                runOnUiThread {
                    codeEditor.setText(text, null)
                    setupDiagnostics()
                }
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }.start()

        updateOpenedFilePath("assets:$name")
        updateEditorPositionText()
        updateBtnState()
    }


    private fun openFileByEditor(filePath: String) {
        val file = File(filePath)
        if (!file.exists()) {
            return
        }
        if (editorUtils.isFileEditorCanOpen(file)) {
            openFileByEditor(file)
        } else {
            // showTip(R.string.cannot_open_compiled_file_tip)
            showTip(R.string.cannot_open_file_tip)
        }
    }

    private fun openFileByEditor(file: File) {
        val fileEditorPosition = editorViewPagerAdapter.checkFileExists(file)
        if (fileEditorPosition == -1) {
            lifecycleScope.launch(Dispatchers.IO) {
                withContext(Dispatchers.Main) {
                    editorViewPagerAdapter.addEditor(file)
                    viewBinding.editorViewPager.currentItem =
                        editorViewPagerAdapter.getEditorCount()
                    currentOpenedFile = file
                    updateOpenedFilePath(file.path)
                }
            }
        } else {
            viewBinding.editorViewPager.currentItem = fileEditorPosition
        }
    }

    private fun openFileByEditor(codeEditor: CodeEditor, file: File) {
        if (!file.exists()) {
            return
        }
        currentOpenedFile = file
        codeEditor.setCurrOpenedFile(file)
        lifecycleScope.launch(Dispatchers.IO) {
            // 使用 'use' 来自动关闭 inputStream
            file.inputStream().use { inputStream ->
                val text = ContentIO.createFrom(inputStream)
                withContext(Dispatchers.Main) {
                    codeEditor.setText(text, null)
                    updateOpenedFilePath(file.path)
                    updateEditorPositionText()
                }
            }
        }
    }


    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        editorManager.switchThemeIfRequired(this, currentEditor)
    }

    // 主页右上角更多菜单
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
//        menuInflater.inflate(R.menu.menu_editor_popup, menu)
//        // 获取菜单项
//        val playButtonItem = menu?.findItem(R.id.editor_play_btn)
//        playButtonItem?.actionView?.background =
//            resUtils.getRippleDrawable(context, "circular", 0x3f000000)
//        // 获取 actionView
//        playButtonItem?.actionView?.setOnLongClickListener {
//            // 处理长按事件
//            true // 返回 true 表示事件已处理
//        }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        super.onOptionsItemSelected(item)
        return true
    }

    fun setProgressBarVisibility(visibility: Int) {
        viewBinding.mainProgressbar.visibility = visibility
    }

    // 初始化界面
    fun initSurface() {
        //binding.drawerLayout.addLayoutTransition()
        // 顶栏
//        setSupportActionBar(binding.toolbarInclude.toolbar)
//        supportActionBar?.apply {
//            title = getString(R.string.application_name)
//            subtitle = AzureLibrary.luaExtDir
//        }
//        viewBinding.toolbarInclude.toolbar.setNavigationIcon(R.drawable.twotone_folder_black_24)
//        viewBinding.toolbarInclude.toolbar.setNavigationOnClickListener {
//            // 处理按钮点击事件
//            viewBinding.drawerLayout.openDrawer(Gravity.LEFT)
//        }
//        // 自定义按钮颜色
//        val navigationIcon = viewBinding.toolbarInclude.toolbar.navigationIcon
//        navigationIcon?.setTint(themeColors.colorAccent)
//        viewBinding.toolbarInclude.toolbar.navigationIcon = navigationIcon
//
//        viewBinding.toolbarInclude.editorMoreBtn.setOnClickListener {
//            viewBinding.drawerLayout.openDrawer(Gravity.RIGHT)
//        }
//        var toolbar = viewBinding.toolbarInclude.toolbar

        viewBinding.drawerLayout.setScrimColor(themeColors.backgroundColor)
        viewBinding.editorViewPager.setUserInputEnabled(false)

        initAllBar()
        initBottomModePart()

        initRightSidebar(viewBinding)

        lifecycleScope.launch {
            settingsDataStore.getValue("drawerLockStatus").collect {
                Log.i(TAG, "drawerLockStatus ${it.toString()}")
                if (it == true) {
                    viewBinding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
                }
            }
        }

        // leftSidebarRecyclerView.autoLockDrawerLayout(binding.drawerLayout)
        // rightSidebarRecyclerView.autoLockDrawerLayout(binding.drawerLayout)
    }

    private fun backParentDir() {
        loadFilesList(
            File(currentOpenedDir).parentFile?.absolutePath ?: PathUtils.getStudioExtDir()
        )
    }

    // 返回键监听
    override fun handleCustomBackPressed() {
        // 判断侧滑栏是否打开
        if (viewBinding.drawerLayout.isDrawerOpen(GravityCompat.START)) {
            shouldHandleBackPress = false
            if (isRootDir()) {
                // 如果已经是根目录，则关闭左侧滑栏
                viewBinding.drawerLayout.closeDrawers()
                return
            } else {
                // 如果不是根目录，返回上一级
                backParentDir()
                shouldHandleBackPress = false
                return
            }
        } else if (viewBinding.drawerLayout.isDrawerOpen(GravityCompat.END)) {
            viewBinding.drawerLayout.closeDrawers()
            shouldHandleBackPress = false
            return
        } else {
            shouldHandleBackPress = true
        }
        super.handleCustomBackPressed()
    }


    fun checkCodeError() {
        var errorInfo = Pair<Boolean?, String?>(true, "No Error")
        var errorStatus = errorInfo.first  //false 有错误 true 正常
        var errorMessage = errorInfo.second
        if (currentEditor.getCurrOpenedFile().isLuaFile()) {
            errorInfo = luaUtils.checkCodeError(currentEditor.text.toString())
            errorStatus = errorInfo.first
            errorMessage = errorInfo.second
            if (errorStatus == true) {
                showTip(R.string.noerror_tips)
            } else {
                val regex = """:(\d+):(.+)""".toRegex()

                val matchResult = regex.find(errorMessage.toString())
                if (matchResult != null) {
                    val (line, extractedData) = matchResult.destructured

                    showTip("第 $line 行 出错: $extractedData")
                } else {
                    showTip(errorMessage.toString())
                }
            }
        }
    }

    // 新建文件/文件夹
    fun createNewFile() {
        val newFileDlg =
            dialogs.createNewFileDialog(this, currentOpenedDir, object : OnCompleteListener {
                override fun onSucceed() {
                    loadFilesListAsync(currentOpenedDir)
                }

                override fun onError(msg: String) {
                    loadFilesListAsync(currentOpenedDir)
                    showTip(msg)
                }
            })
        newFileDlg.show()
    }

    private fun createInsertCodeDlg() {
        val quickCodesFilePath = PathUtils.getLuaApplicationDir(this, "codes/quick_codes.lua")
        val quickCodes = LuaUtils().loadLuaTableFromFile(quickCodesFilePath, "quick_codes")
        if (insertCodeDlg == null) {
            insertCodeDlg =
                dialogs.createInsertCodeDialog(this, quickCodes, object : OnCodeListener {
                    override fun onCodeSelected(code: String) {
                        editorUtils.insertText(currentEditor, code)
                    }
                })

        }
        insertCodeDlg?.let {
            it.show()
            it.setFullScreenBottomSheetDlg()
        }
    }


    fun initIncidents() {
        eventManager.registerEvent("add_file") { args ->
            createNewFile()
        }

        eventManager.registerEvent("code_format") { args ->
            currentOpenedFile?.let {
                editorUtils.backupFile(this, it, "format_file")
                editorUtils.formatCode(currentEditor)
            }
        }

        eventManager.registerEvent("bin_project") { args ->
            if (editorMode.isLuaIDE()) {
                eventManager.skipToLuaActivityEvent("bin_module", args[0], args[1])
            }
        }


        eventManager.registerEvent("insert_code") { args ->
            createInsertCodeDlg()
        }

        eventManager.registerEvent("code_check") { args ->
            checkCodeError()
        }

        eventManager.registerEvent("import_analysis") { args ->

        }

        eventManager.registerEvent("code_navigation") { args ->

        }

        eventManager.registerEvent("search_code") { args ->
            openEditorSearchBar()
        }

        eventManager.registerEvent("global_search_code") { args ->
        }

        eventManager.registerEvent("jump_line") { args ->
            openEditBar("goto_line")
        }



        eventManager.registerEvent("compile_lua_file") { args ->
            if (editorMode == "lua") {
                currentOpenedFile?.let {
                    val callback = luaUtils.consoleBuild(it.path)
                    if (callback is String) {
                        showTip("编译完成：$callback")
                    } else if (callback is LuaException) {
                        showTip("编译出错：${callback.message}")
                    }
                }
            }
        }

        eventManager.registerEvent("argb_tool") { args ->
            if (argbDialog == null) {
                argbDialog = dialogs.createArgbDialog(this, object : OnColorSelectedListener {
                    override fun onColorSelected(color: Int) {
                        val colorHex = String.format("#%08X", color) // 转换为 16 进制颜色
                        editorUtils.insertText(currentEditor, colorHex)
                    }
                })
            }
            argbDialog!!.show()
        }

        eventManager.registerEvent("create_project") { args ->
            val createProjectDialog = dialogs.createLocalProjectDialog(
                this, viewBinding.editorViewPager
            ) { createProjectStatus, projectType ->
                if (createProjectStatus) {
                    showTip(R.string.create_project_succeed)
                }
            }
            createProjectDialog.show()
        }


    }

    fun initRightSidebar(binding: ActivityEditorMainBinding) {
        val rightSidebarRecyclerView = viewBinding.editorRightSidebar.rightSidebarRecyclerView
        rightSidebarRecyclerView.layoutManager = LinearLayoutManager(this)
        rightSidebarRecyclerView.itemAnimator = DefaultItemAnimator()
        // rightSidebarRecyclerView.setRecycledViewPool(null);

        val rightSidebarRecyclerViewAdapter = ExpandedListAdapter(this)
        // 设置全局点击事件
        rightSidebarRecyclerViewAdapter.setGlobalChildOnItemClick { item, position ->
            val opKey = item.opKey
            viewBinding.drawerLayout.closeDrawers()
            eventManager.triggerEvent(opKey, currOpenedProjectItem, currentOpenedFile, editorMode)
        }

        rightSidebarRecyclerView.adapter = rightSidebarRecyclerViewAdapter

        EditorData.initAllOpGroups()

        val opGroups = mutableListOf<OpGroupItem>()
        // 代码操作栏
        opGroups.add(EditorData.getOpGroup("code_op"))
        opGroups.add(EditorData.getOpGroup("proj_op"))
        opGroups.add(EditorData.getOpGroup("file_op"))
        opGroups.add(EditorData.getOpGroup("tools"))
        opGroups.add(EditorData.getOpGroup("others"))

        rightSidebarRecyclerViewAdapter.setOpGroups(opGroups)

        viewBinding.editorRightSidebar.dlBtmNightmodeBtn.setOnClickListener {

        }
        viewBinding.editorRightSidebar.dlBtmAboutBtn.setOnClickListener {

        }
        viewBinding.editorRightSidebar.dlBtmSettingsBtn.setOnClickListener {

        }
        viewBinding.editorRightSidebar.dlBtmExitBtn.setOnClickListener {
            finish()
        }
    }

    fun setLayoutHelperBtnVisibility(boolean: Boolean) {
        if (boolean) {
            viewBinding.toolbarInclude.layoutHelperButton.visibility = View.VISIBLE
        } else {
            viewBinding.toolbarInclude.layoutHelperButton.visibility = View.GONE
        }
    }

    //初始化所有工具栏
    @SuppressLint("RtlHardcoded")
    fun initAllBar() {
        // 标题栏
        editorToolBar = viewBinding.toolbarInclude.toolBar
        // 操作栏
        editorControlBar = viewBinding.controlBarInclude.controlBar
        // 消息栏
        messageBar = viewBinding.editorInfoBarInclude.cvBar
        // 错误栏
        errorBar = viewBinding.editorInfoBarInclude.errorBar
        // 跳转栏

        viewBinding.apply {
            editBarInclude.apply {
                cancelButton.setOnClickListener {
                    closeEditBar()
                }
                editBarEt.keyListener = DigitsKeyListener.getInstance("0123456789")
                jumpButton.setOnClickListener {
                    val edText = editBarEt.text.toString()
                    if (editBarMode == "goto_line") {
                        val line = edText.toInt()
                        editorUtils.gotoLine(currentEditor, line)
                    }
                }
            }
            // 标题栏
            toolbarInclude.apply {
                folderButton.setOnClickListener {
                    viewBinding.drawerLayout.openDrawer(Gravity.LEFT)
                }
                layoutHelperButton.setOnClickListener {
                    eventManager.triggerEvent(
                        "layout_helper",
                        currOpenedProjectItem,
                        currentOpenedFile,
                        editorMode
                    )
                }
                playButton.setOnClickListener {
                    if (editorMode.isLuaIDE()) {
                        runFile(File(mainFilePath), editorMode)
                    } else {
                        currentOpenedFile?.let {
                            runFile(it, editorMode)
                        }
                    }
                }
                playButton.setOnLongClickListener { view ->
                    currentOpenedFile?.let {
                        runFile(it, editorMode, true)
                    }
                    true
                }
                undoButton.setOnClickListener {
                    editorUtils.undo(currentEditor)
                }
                moreButton.setOnClickListener {
                    viewBinding.drawerLayout.openDrawer(Gravity.RIGHT)
                }
            }
            // 操作栏
            controlBarInclude.apply {
                cancelButton.setOnClickListener {
                    hideAllBar()
                }
                selectAllButton.setOnClickListener {
                    editorUtils.selectAllText(currentEditor)
                }
                cutButton.setOnClickListener {
                    editorUtils.cutText(currentEditor)
                }
                copyButton.setOnClickListener {
                    editorUtils.copyText(currentEditor)
                }
                pasteButton.setOnClickListener {
                    editorUtils.pasteText(currentEditor)
                }
            }
        }
    }

    fun hideAllBar() {
        editorToolBar.visibility = View.VISIBLE
        editorControlBar.visibility = View.GONE
        // editorSearchBar.visibility = View.GONE
    }

    fun showControlBar(status: Boolean) {
        if (status) {
            //传入true时显示操作栏
            editorToolBar.visibility = View.GONE
            editorControlBar.visibility = View.VISIBLE
            // editorSearchBar.visibility = View.GONE
        } else {
            editorToolBar.visibility = View.VISIBLE
            editorControlBar.visibility = View.GONE
            // editorSearchBar.visibility = View.GONE
        }
    }

    // 初始化ViewPager
    fun initViewPager() {
        // Editor ViewPager
        editorViewPagerAdapter = EditorViewPagerAdapter(this, fileUtils)
        viewBinding.editorViewPager.adapter = editorViewPagerAdapter
        viewBinding.editorViewPager.offscreenPageLimit = editorViewPagerAdapter.getEditorCount() + 1
        // 绑定 TabLayout 和 ViewPager2
        TabLayoutMediator(
            viewBinding.editorTabLayout,
            viewBinding.editorViewPager
        ) { tab, position ->
            tab.text = editorViewPagerAdapter.getTitle(position) // 设置 Tab 的标题
            tab.tag = editorViewPagerAdapter.getEditorFile(position)
        }.attach()

        viewBinding.editorViewPager.registerOnPageChangeCallback(object :
            ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                val editorView = editorViewPagerAdapter.getEditorView(position)
                Log.i("editorViewPager", "" + position)
                if (editorView is CodeEditor) {
                    currentEditor = editorView
                    currentEditor.invalidate()
                    Log.i("editorViewPager", "CodeEditor$currentEditor")
                    updateEditorPositionText()
//                    isAlyFile
                } else if (editorView is PhotoView) {
                    currentPhotoView = editorView
                    Log.i("editorViewPager", "PhotoView$currentPhotoView")
                }
                hideAllBar()
                editorViewPagerAdapter.getEditorFile(position)?.let {
                    currentOpenedFile = it
                    updateOpenedFilePath(it.absolutePath)
                    currentOpenedFile?.let { file ->
                        setLayoutHelperBtnVisibility(fileUtils.isAlyFile(file))
                    }
                }
            }
        })
        reloadTabLayout()
    }

    private fun closeEditorTab(index: Int) {
        editorViewPagerAdapter.removeEditor(index)
        reloadTabLayout()
    }


    // TabLayout 长按事件
    fun reloadTabLayout() {
        Log.i(TAG, "reloadTabLayout")
        // 设置每个 Tab 的长按监听事件
        for (i in 0 until viewBinding.editorTabLayout.tabCount) {
            val tab = viewBinding.editorTabLayout.getTabAt(i)
            tab?.view?.setOnLongClickListener { v ->
                // 长按事件处理
                val tabTitle = tab.text
                val tabTag = tab.tag
                var tagFile: File? = null
                Log.i(TAG, "tabTag:$tabTag")
                // 创建 PopupMenu
                val popupMenu = PopupMenu(this, v)
                // 获取 MenuInflater
                val inflater = popupMenu.menuInflater
                inflater.inflate(R.menu.menu_editor_tab_popup, popupMenu.menu)
                if (tabTag != null) {
                    tagFile = tabTag as File
                    // 当选中文件为主文件时 隐藏相应选项
                    popupMenu.menu.findItem(R.id.editor_close_tab)?.isVisible =
                        tagFile.absolutePath != mainFilePath
                    popupMenu.menu.findItem(R.id.editor_close_other_tab)?.isVisible =
                        tagFile.absolutePath != mainFilePath

                    if (checkMainFilePath(tagFile, editorMode)) {
                        popupMenu.menu.findItem(R.id.editor_file_rename)?.isVisible = false
                        popupMenu.menu.findItem(R.id.editor_file_delete)?.isVisible = false
                    } else {
                        popupMenu.menu.findItem(R.id.editor_file_rename)?.isVisible = true
                        popupMenu.menu.findItem(R.id.editor_file_delete)?.isVisible = true
                    }
                    if (fileUtils.isLuaFile(tagFile.absolutePath)) {
                        popupMenu.menu.findItem(R.id.editor_compile_lua)?.isVisible = true
                    } else {
                        popupMenu.menu.findItem(R.id.editor_compile_lua)?.isVisible = false
                    }
                    popupMenu.menu.findItem(R.id.editor_file_java_compile)?.isVisible = false

                }

                // 设置菜单项点击监听器
                popupMenu.setOnMenuItemClickListener { menuItem ->
                    when (menuItem.itemId) {
                        R.id.editor_close_all_tab -> {
                            editorViewPagerAdapter.removeAllEditor(File(mainFilePath))
                            reloadTabLayout()
                            true
                        }

                        R.id.editor_close_tab -> {
                            closeEditorTab(i)
                            true
                        }

                        R.id.editor_close_other_tab -> {
                            if (tagFile != null) {
                                editorViewPagerAdapter.removeAllEditor(File(mainFilePath), tagFile)
                            } else {
                                editorViewPagerAdapter.removeAllEditor(File(mainFilePath))
                            }
                            reloadTabLayout()
                            true
                        }

                        R.id.editor_save_file -> {
                            saveFile(true)
                            true
                        }

                        R.id.editor_copy_file_name -> {
                            if (tagFile != null) {
                                AzureUtils().copyToClipboard(this, tagFile.name)
                            }
                            true
                        }

                        R.id.editor_copy_file_path -> {
                            if (tagFile != null) {
                                AzureUtils().copyToClipboard(this, tagFile.absolutePath)
                            }
                            true
                        }

                        R.id.editor_file_rename -> {
                            if (tagFile != null) {
                                fileRename(tagFile)
                            }
                            true
                        }

                        R.id.editor_file_share -> {
                            if (tagFile != null) {
                                fileUtils.shareFile(this, tagFile)
                            }
                            true
                        }

                        R.id.editor_file_delete -> {
                            val deleteDialog =
                                MaterialAlertDialogBuilder(context, R.style.AlertDialogTheme)
                            deleteDialog.setTitle(R.string.delete)
                            deleteDialog.setMessage(R.string.delete_tips)
                            deleteDialog.setPositiveButton(context.getString(R.string.ok_button)) { _, _ ->
                                closeEditorTab(i)
                                if (tagFile != null) {
                                    deleteFile(tagFile)
                                }
                            }
                            deleteDialog.setNegativeButton(context.getString(R.string.cancel_button)) { _, _ ->
                            }
                            deleteDialog.show()
                            true
                        }

                        R.id.editor_file_backup -> {
                            true
                        }

                        R.id.editor_compile_lua -> {
                            if (tagFile != null) {
                                val callback = luaUtils.consoleBuild(tagFile.absolutePath)
                                if (callback is String) {
                                    showTip("编译完成：$callback")
                                } else if (callback is LuaException) {
                                    showTip("编译出错：${callback.message}")
                                }
                            }
                            true
                        }

                        R.id.editor_file_hist_version -> {
                            true
                        }

                        R.id.editor_file_upload_to_public_cloud -> {
                            true
                        }

                        R.id.editor_file_java_compile -> {
                            true
                        }

                        else -> false
                    }
                }
                popupMenu.show()
                true  // 返回 true 表示消费了长按事件，不会传递给其他监听器
            }
        }
    }

    fun loadSymbolsBar() {
        viewBinding.bottombarInclude.editorSymbolsBar.addLayoutTransition()

        val editorSymbols = editorManager.getSymbolsData()
        editorSymbols.forEach { symbolText ->
            val button = TextView(this).apply {
                text = symbolText
                isSingleLine = true
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.MATCH_PARENT
                ).apply {
                    background = resUtils.getRippleDrawable(context, themeColors.rippleColorAccent)
                    setPadding(dp2px(context, 15), 0, dp2px(context, 15), 0)
                }
                gravity = Gravity.CENTER
                //typeface = Typeface.createFromAsset(context.assets, "fonts/common.ttf")
                setTextColor(themeColors.toolBarTitleColor)
            }
            // Add the button to the bar
            viewBinding.bottombarInclude.editorSymbolsBar.addView(button)
            // Set onClick listener
            button.setOnClickListener {
                if (::currentEditorViewType.isInitialized) {
                    when (currentEditorViewType) {
                        "CodeEditor" -> {
                            val selectedText = currentEditor.getSelectedText()
                            val (newSymbol, newSelectionOffset) = editorUtils.symbolHandler(
                                symbolText,
                                selectedText
                            )
                            currentEditor.insertText(newSymbol, newSelectionOffset)
                        }
                    }
                }

            }
        }
    }

    fun isCurrEditorInit(): Boolean {
        return (::currentEditor.isInitialized)
    }

    // 初始化底部
    fun initBottomModePart() {
        val bottomBar = viewBinding.bottombarInclude
        val bottomBarRoot = bottomBar.bottomLayoutRoot
        bottomBarRoot.addLayoutTransition()
        // 搜索栏
        editorSearchBar = bottomBar.searchBarInclude.searchBar
        // 更多菜单收起展开按钮
        val fastOperationBar = bottomBar.fastOperationBar
        // 按钮状态
        var fastButtonCloseStatus = false
        val backgroundColor = themeColors.backgroundColor
        val selectedBackgroundColor = themeColors.rippleColorAccent
        bottomBar.apply {
            fsearchCodeButton.setToolTip(R.string.search_code)
            fsearchCodeButton.setOnClickListener {
                openEditorSearchBar()
            }
            fastButtonCloseBtn.setOnClickListener {
                if (fastButtonCloseStatus) {
                    fastButtonCloseStatus = false
                    fastOperationBar.visibility = View.GONE
                    bottomBar.fastButtonCloseIcon.startRotateInvertedAnim()
                } else {
                    fastButtonCloseStatus = true
                    fastOperationBar.visibility = View.VISIBLE
                    bottomBar.fastButtonCloseIcon.startRotateStraightAnim()
                }
            }

            finsertCodeButton.setToolTip(R.string.insert_code)
            finsertCodeButton.setOnClickListener {
                createInsertCodeDlg()
            }
            fcodeOperationButton.setToolTip(R.string.code_operation)
            fcodeOperationButton.setOnClickListener {
                val popupMenu = PopupMenu(context, fcodeOperationButton)
                val inflater = popupMenu.menuInflater
                inflater.inflate(R.menu.menu_editor_code_ops, popupMenu.menu)
                popupMenu.setOnMenuItemClickListener { menuItem ->
                    when (menuItem.itemId) {
                        R.id.choose_line_tab -> {

                            true
                        }

                        R.id.copy_line_tab -> {

                            true
                        }

                        R.id.cut_line_tab -> {
                            currentEditor.cutLine()
                            true
                        }

                        R.id.delete_line_tab -> {

                            true
                        }

                        R.id.repeat_line_tab -> {

                            true
                        }

                        R.id.clear_line_tab -> {

                            true
                        }

                        R.id.comment_line_tab -> {
                            currentOpenedFile?.let {
                                if (it.isLuaFile()) {

                                }
                            }
                            true
                        }

                        else -> false
                    }
                }
                popupMenu.show()
            }
            fformatButton.setToolTip(R.string.code_format)
            fformatButton.setOnClickListener {
                if (isCurrEditorInit()) {
                    editorUtils.formatCode(currentEditor)
                }
            }
            fpasteButton.setToolTip(R.string.paste_text)
            fpasteButton.setOnClickListener {
                if (isCurrEditorInit()) {
                    editorUtils.pasteText(currentEditor)
                }
            }
            fredoButton.setToolTip(R.string.redo)
            fredoButton.setOnClickListener {
                if (isCurrEditorInit()) {
                    editorUtils.redo(currentEditor)
                }
            }
            searchBarInclude.apply {
                searchBarSearchEt.addTextChangedListener(object : TextWatcher {
                    override fun beforeTextChanged(
                        charSequence: CharSequence,
                        i: Int,
                        i1: Int,
                        i2: Int,
                    ) {
                    }

                    override fun onTextChanged(
                        charSequence: CharSequence,
                        i: Int,
                        i1: Int,
                        i2: Int,
                    ) {
                    }

                    override fun afterTextChanged(editable: Editable) {
                        tryCommitSearch()
                    }
                })
                searchBarCancelBtn.setOnClickListener {
                    editorSearchBar.visibility = View.GONE
                }
                btnGotoPrev.setOnClickListener(::editorGotoPrev)
                btnGotoNext.setOnClickListener(::editorGotoNext)
                btnReplace.setOnClickListener(::editorReplace)
                btnReplaceAll.setOnClickListener(::editorReplaceAll)
                searchOptionMatchCaseBtn.setToolTip(R.string.search_option_match_case)
                searchOptionMatchCaseBtn.setBackgroundColor(if (editorSearchOptionCaseInsensitive) backgroundColor else selectedBackgroundColor)
                searchOptionMatchCaseBtn.setOnClickListener {
                    // 区分大小写 true 不区分 false 区分
                    if (editorSearchOptionCaseInsensitive) {
                        editorSearchOptionCaseInsensitive = false
                        searchOptionMatchCaseBtn.setBackgroundColor(selectedBackgroundColor)
                    } else {
                        editorSearchOptionCaseInsensitive = true
                        searchOptionMatchCaseBtn.setBackgroundColor(backgroundColor)
                    }
                    refreshSearchOptions()
                    tryCommitSearch()
                }
                searchOptionRegexBtn.setToolTip(R.string.search_option_regex)
                searchOptionRegexBtn.setBackgroundColor(if (editorSearchOptionRegex) selectedBackgroundColor else backgroundColor)
                searchOptionRegexBtn.setOnClickListener {
                    // 正则匹配
                    if (editorSearchOptionRegex) {
                        editorSearchOptionRegex = false
                        searchOptionRegexBtn.setBackgroundColor(backgroundColor)
                    } else {
                        editorSearchOptionRegex = true
                        searchOptionRegexBtn.setBackgroundColor(selectedBackgroundColor)
                    }
                    refreshSearchOptions()
                    tryCommitSearch()
                }
                searchOptionWholeWordBtn.setToolTip(R.string.search_option_whole_word)
                searchOptionWholeWordBtn.setBackgroundColor(if (editorSearchOptionWholeWord) selectedBackgroundColor else backgroundColor)
                searchOptionWholeWordBtn.setOnClickListener {
                    if (editorSearchOptionWholeWord) {
                        editorSearchOptionWholeWord = false
                        searchOptionWholeWordBtn.setBackgroundColor(backgroundColor)
                    } else {
                        editorSearchOptionWholeWord = true
                        searchOptionWholeWordBtn.setBackgroundColor(selectedBackgroundColor)
                    }
                    refreshSearchOptions()
                    tryCommitSearch()
                }
            }
        }

        // 设置按钮波纹效果
        resUtils.setRippleDrawable(
            context,
            listOf(
                bottomBar.fastButtonCloseBtn,
                bottomBar.finsertCodeButton,
                bottomBar.fcodeOperationButton,
                bottomBar.fformatButton,
                bottomBar.fpasteButton,
                bottomBar.fredoButton
            ), themeColors.rippleColorAccent
        )

    }

    private fun openEditBar(mode: String) {
        editorEditBar.visibility = View.VISIBLE
        editBarMode = mode
        if (mode == "goto_line") {
            viewBinding.editBarInclude.editBarEt.hint = getString(R.string.toline_tip)
        }
    }

    private fun closeEditBar() {
        editorEditBar.visibility = View.GONE
    }

    private fun openEditorSearchBar() {
        if (editorSearchBar.visibility == View.GONE) {
            editorSearchBar.visibility = View.VISIBLE
        } else {
            editorSearchBar.visibility = View.GONE
        }
        if (isCurrEditorInit()) {
            currentEditor.searcher.stopSearch()
        }
        //currentEditor.beginSearchMode()
    }

    private fun refreshSearchOptions() {
        val caseInsensitive = editorSearchOptionCaseInsensitive
        var type = EditorSearcher.SearchOptions.TYPE_NORMAL
        val regex = editorSearchOptionRegex
        if (regex) {
            type = EditorSearcher.SearchOptions.TYPE_REGULAR_EXPRESSION
        }
        val wholeWord = editorSearchOptionWholeWord
        if (wholeWord) {
            type = EditorSearcher.SearchOptions.TYPE_WHOLE_WORD
        }
        editorSearchOptions = EditorSearcher.SearchOptions(type, caseInsensitive)
    }

    private fun tryCommitSearch() {
        val searchBarInclude = viewBinding.bottombarInclude.searchBarInclude
        val searchEditText = searchBarInclude.searchBarSearchEt
        val query = searchEditText.editableText
        if (query.isNotEmpty()) {
            try {
                currentEditor.searcher.search(query.toString(), editorSearchOptions)
            } catch (e: PatternSyntaxException) {
                // Regex error
            }
        } else {
            currentEditor.searcher.stopSearch()
        }
    }

    fun editorGotoNext(view: View) {
        try {
            currentEditor.searcher.gotoNext()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    fun editorGotoPrev(view: View) {
        try {
            currentEditor.searcher.gotoPrevious()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    fun editorReplace(view: View) {
        val searchBarInclude = viewBinding.bottombarInclude.searchBarInclude
        val replaceEditText = searchBarInclude.searchBarReplaceEt
        try {
            currentEditor.searcher.replaceThis(replaceEditText.text.toString())
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    fun editorReplaceAll(view: View) {
        val searchBarInclude = viewBinding.bottombarInclude.searchBarInclude
        val searchEditText = searchBarInclude.searchBarSearchEt
        val replaceEditText = searchBarInclude.searchBarReplaceEt
        try {
            currentEditor.searcher.replaceAll(replaceEditText.text.toString())
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    private fun updateEditorPositionText() {
        val cursor = currentEditor.cursor
        var text =
            (1 + cursor.leftLine).toString() + ":" + cursor.leftColumn + ";" + cursor.left + " "

        text += if (cursor.isSelected) {
            "(" + (cursor.right - cursor.left) + " chars)"
        } else {
            val content = currentEditor.text
            if (content.getColumnCount(cursor.leftLine) == cursor.leftColumn) {
                "(<" + content.getLine(cursor.leftLine).lineSeparator.let {
                    if (it == LineSeparator.NONE) {
                        "EOF"
                    } else {
                        it.name
                    }
                } + ">)"
            } else {
                "(" + content.getLine(cursor.leftLine)
                    .codePointStringAt(cursor.leftColumn)
                    .escapeCodePointIfNecessary() + ")"
            }
        }

        // Indicator for text matching
        val searcher = currentEditor.searcher
        if (searcher.hasQuery()) {
            val idx = searcher.currentMatchedPositionIndex
            val count = searcher.matchedPositionCount
            val matchText = if (count == 0) {
                "no match"
            } else if (count == 1) {
                "1 match"
            } else {
                "$count matches"
            }
            text += if (idx == -1) {
                "($matchText)"
            } else {
                "(${idx + 1} of $matchText)"
            }
        }

        viewBinding.editorInfoBarInclude.cvBarTv.text = text
        // 设置长按提示框
        TooltipCompat.setTooltipText(viewBinding.editorInfoBarInclude.cvBar, text)
    }

    private fun generateKeybindingString(event: KeyBindingEvent): String {
        val sb = StringBuilder()
        if (event.isCtrlPressed) {
            sb.append("Ctrl + ")
        }

        if (event.isAltPressed) {
            sb.append("Alt + ")
        }

        if (event.isShiftPressed) {
            sb.append("Shift + ")
        }

        sb.append(KeyEvent.keyCodeToString(event.keyCode))
        return sb.toString()
    }


    /**
     * Add diagnostic items to editor. For debug only.
     */
    private fun setupDiagnostics() {
        val editor = currentEditor
        val container = DiagnosticsContainer()
        for (i in 0 until editor.text.lineCount) {
            val index = editor.text.getCharIndex(i, 0)
            container.addDiagnostic(
                DiagnosticRegion(
                    index,
                    index + editor.text.getColumnCount(i),
                    DiagnosticRegion.SEVERITY_ERROR
                )
            )
        }
        editor.diagnostics = container
    }


    /**
     * Re-apply color scheme
     */
    private fun resetEditorColorScheme() {
        editorUtils.resetColorScheme(currentEditor)
    }


//    private fun openLogs() {
//        runCatching {
//            openFileInput(LOG_FILE).reader().readText()
//        }.onSuccess {
//            viewBinding.editor.setText(it)
//        }.onFailure {
//            toast(it.toString())
//        }
//    }
//
//    private fun clearLogs() {
//        runCatching {
//            openFileOutput(LOG_FILE, MODE_PRIVATE)?.use {}
//        }.onFailure {
//            toast(it.toString())
//        }.onSuccess {
//            toast(R.string.deleting_log_success)
//        }
//    }

    private fun chooseLineNumberPanelPosition() {
        val editor = currentEditor
        val themes = arrayOf(
            getString(R.string.top),
            getString(R.string.bottom),
            getString(R.string.left),
            getString(R.string.right),
            getString(R.string.center),
            getString(R.string.top_left),
            getString(R.string.top_right),
            getString(R.string.bottom_left),
            getString(R.string.bottom_right)
        )
        MaterialAlertDialogBuilder(this)
            .setTitle(R.string.fixed)
            .setSingleChoiceItems(themes, -1) { dialog: DialogInterface, which: Int ->
                editor.lnPanelPositionMode = LineInfoPanelPositionMode.FIXED
                when (which) {
                    0 -> editor.lnPanelPosition = LineInfoPanelPosition.TOP
                    1 -> editor.lnPanelPosition = LineInfoPanelPosition.BOTTOM
                    2 -> editor.lnPanelPosition = LineInfoPanelPosition.LEFT
                    3 -> editor.lnPanelPosition = LineInfoPanelPosition.RIGHT
                    4 -> editor.lnPanelPosition = LineInfoPanelPosition.CENTER
                    5 -> editor.lnPanelPosition =
                        LineInfoPanelPosition.TOP or LineInfoPanelPosition.LEFT

                    6 -> editor.lnPanelPosition =
                        LineInfoPanelPosition.TOP or LineInfoPanelPosition.RIGHT

                    7 -> editor.lnPanelPosition =
                        LineInfoPanelPosition.BOTTOM or LineInfoPanelPosition.LEFT

                    8 -> editor.lnPanelPosition =
                        LineInfoPanelPosition.BOTTOM or LineInfoPanelPosition.RIGHT
                }
                dialog.dismiss()
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun chooseLanguage() {
        val editor = currentEditor
        val languageOptions = arrayOf(
            "Java",
            "TextMate C",
            "TextMate Lua",
            "TextMate Java",
            "TextMate Kotlin",
            "TextMate Python",
            "TextMate Html",
            "TextMate JavaScript",
            "TextMate MarkDown",
            "TM Language from file",
            "Tree-sitter Java",
            "Text"
        )
        val tmLanguages = mapOf(
            "TextMate C" to Pair("source.c", "source.c"),
            "TextMate Lua" to Pair("source.lua", "source.lua"),
            "TextMate Java" to Pair("source.java", "source.java"),
            "TextMate Kotlin" to Pair("source.kotlin", "source.kotlin"),
            "TextMate Python" to Pair("source.java", "source.java"),
            "TextMate Html" to Pair("text.html.basic", "text.html.basic"),
            "TextMate JavaScript" to Pair("source.js", "source.js"),
            "TextMate MarkDown" to Pair("text.html.markdown", "text.html.markdown")
        )
        MaterialAlertDialogBuilder(this)
            .setTitle(R.string.switch_language)
            .setSingleChoiceItems(languageOptions, -1) { dialog: DialogInterface, which: Int ->
                val selected = languageOptions[which]
                if (selected in tmLanguages) {
                    val info = tmLanguages[selected]!!
                    try {
                        editorManager.ensureEditorTextmateTheme(editor)
                        val editorLanguage = editor.editorLanguage
                        val language = if (editorLanguage is TextMateLanguage) {
                            editorLanguage.updateLanguage(info.first)
                            editorLanguage
                        } else {
                            TextMateLanguage.create(info.second, true)
                        }
                        editor.setEditorLanguage(language)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                } else {
                    when (selected) {
//                        "Java" -> editor.setEditorLanguage(JavaLanguage())
                        "Text" -> editor.setEditorLanguage(EmptyLanguage())
                        "TM Language from file" -> loadTMLLauncher.launch("*/*")
//                        "Tree-sitter Java" -> {
//                            editor.setEditorLanguage(
//                                TsLanguageJava(
//                                    JavaLanguageSpec(
//                                        highlightScmSource = assets.open("tree-sitter-queries/java/highlights.scm")
//                                            .reader().readText(),
//                                        codeBlocksScmSource = assets.open("tree-sitter-queries/java/blocks.scm")
//                                            .reader().readText(),
//                                        bracketsScmSource = assets.open("tree-sitter-queries/java/brackets.scm")
//                                            .reader().readText(),
//                                        localsScmSource = assets.open("tree-sitter-queries/java/locals.scm")
//                                            .reader().readText()
//                                    )
//                                )
//                            )
//                        }
                    }
                }
                dialog.dismiss()
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun chooseTheme() {
        val editor = currentEditor
        val themes = arrayOf(
            "Default",
            "GitHub",
            "Eclipse",
            "Darcula",
            "VS2019",
            "NotepadXX",
            "QuietLight for TM(VSCode)",
            "Darcula for TM",
            "Abyss for TM",
            "Solarized(Dark) for TM(VSCode)",
            "TM theme from file"
        )
        MaterialAlertDialogBuilder(this)
            .setTitle(R.string.color_scheme)
            .setSingleChoiceItems(themes, -1) { dialog: DialogInterface, which: Int ->
                when (which) {
                    0 -> editor.colorScheme = EditorColorScheme()
                    1 -> editor.colorScheme = SchemeGitHub()
                    2 -> editor.colorScheme = SchemeEclipse()
                    3 -> editor.colorScheme = SchemeDarcula()
                    4 -> editor.colorScheme = SchemeVS2019()
                    5 -> editor.colorScheme = SchemeNotepadXX()
                    6 -> try {
                        editorManager.ensureEditorTextmateTheme(currentEditor)
                        ThemeRegistry.getInstance().setTheme("quietlight")
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                    7 -> try {
                        editorManager.ensureEditorTextmateTheme(currentEditor)
                        ThemeRegistry.getInstance().setTheme("darcula")
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                    8 -> try {
                        editorManager.ensureEditorTextmateTheme(currentEditor)
                        ThemeRegistry.getInstance().setTheme("abyss")
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                    9 -> try {
                        editorManager.ensureEditorTextmateTheme(currentEditor)
                        ThemeRegistry.getInstance().setTheme("solarized_drak")
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                    10 -> loadTMTLauncher.launch("*/*")
                }
                resetEditorColorScheme()
                dialog.dismiss()
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }


    private val loadTMLLauncher =
        registerForActivityResult(ActivityResultContracts.GetContent()) { result: Uri? ->
            try {
                if (result == null) return@registerForActivityResult
                val editorLanguage = currentEditor.editorLanguage

                val language = if (editorLanguage is TextMateLanguage) {
                    editorLanguage.updateLanguage(
                        DefaultGrammarDefinition.withGrammarSource(
                            IGrammarSource.fromInputStream(
                                contentResolver.openInputStream(result),
                                result.path, null
                            ),
                        )
                    )
                    editorLanguage
                } else {
                    TextMateLanguage.create(
                        DefaultGrammarDefinition.withGrammarSource(
                            IGrammarSource.fromInputStream(
                                contentResolver.openInputStream(result),
                                result.path, null
                            ),
                        ), true
                    )
                }
                currentEditor.setEditorLanguage(language)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }


    private val loadTMTLauncher =
        registerForActivityResult(ActivityResultContracts.GetContent()) { result: Uri? ->
            try {
                if (result == null) return@registerForActivityResult

                editorManager.ensureEditorTextmateTheme(currentEditor)

                ThemeRegistry.getInstance().loadTheme(
                    IThemeSource.fromInputStream(
                        contentResolver.openInputStream(result), result.path,
                        null
                    )
                )

                resetEditorColorScheme()

            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

    private fun autoBackup() {
        currentOpenedFile?.let {
            editorUtils.backupFile(this, it, "auto_save")
        }
    }

    private fun checkFileUpdate(editor: CodeEditor, file: File) {
        autoBackup()
        if (editor.editorInitState && fileUpdateState) {
            // 使用 'use' 来自动关闭 inputStream
            file.inputStream().use { inputStream ->
                val text = ContentIO.createFrom(inputStream)
                if (editor.text != text) {
                    val checkFileUpdateDialog =
                        MaterialAlertDialogBuilder(context, R.style.AlertDialogTheme)
                    checkFileUpdateDialog.setTitle(R.string.tip_text)
                    checkFileUpdateDialog.setMessage(R.string.file_content_update_tips)
                    checkFileUpdateDialog.setPositiveButton(context.getString(R.string.ok_button)) { _, _ ->
                        lifecycleScope.launch(Dispatchers.IO) {
                            withContext(Dispatchers.Main) {
                                editor.setText(text, null)
                                updateOpenedFilePath(file.path)
                                updateEditorPositionText()
                            }
                        }
                    }
                    checkFileUpdateDialog.setNegativeButton(context.getString(R.string.cancel_button)) { _, _ ->
                    }
                    checkFileUpdateDialog.show()
                }
            }
        }
    }


    override fun onResume() {
        super.onResume()
        currentProjectsList = projectUtils.getLuaProjectsInfoAsFileItem(this)
        loadFilesListAsync(currentOpenedDir)

        if (isFirstResume) {
            isFirstResume = false
        } else {
            if (initState && ::currentEditor.isInitialized) {
                currentOpenedFile?.let { file ->
                    checkFileUpdate(currentEditor, file)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        historyManager.saveAutoOpen(false)
        // viewBinding.editor.release()
    }


    /**
     * Convert dp to pixels.
     *
     * @param context the context used to access resources
     * @param dp the value in dp to convert to pixels
     * @return the corresponding value in pixels
     */
    fun dp2px(context: Context, dp: Int): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            dp.toFloat(),
            context.resources.displayMetrics
        ).toInt()
    }


    /** 打开系统文件选择器 */
    private fun openFilePicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*" // 可更改为 "image/*"、"application/pdf" 等
        }
        filePickerLauncher.launch(intent)
    }

    /** 获取文件路径 */
    private fun getFilePathFromUri(uri: Uri): String {
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            if (nameIndex >= 0 && cursor.moveToFirst()) {
                return cursor.getString(nameIndex)
            }
        }
        return uri.path ?: "未知文件"
    }

    override fun getViewModelClass(): Class<EditorViewModel> {
        return getJavaClass()
    }

    override fun getViewBindingInstance(): ActivityEditorMainBinding {
        return ActivityEditorMainBinding.inflate(layoutInflater)
    }
//    override fun onBackPressed() {
//        super.onBackPressed()

//        // 添加返回动画
//        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right)
//    }
}