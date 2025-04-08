package com.qflistudio.azure.common

import OnCodeListener
import OnColorSelectedListener
import OnCompleteListener
import OnProjectCreatedListener
import TemplateManager
import android.app.ProgressDialog
import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.os.Build
import android.text.method.DigitsKeyListener
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.view.WindowMetrics
import android.widget.ArrayAdapter
import android.widget.ArrayExpandableListAdapter
import android.widget.ExpandableListView
import android.widget.SeekBar
import android.widget.Spinner
import android.widget.TextView
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.widget.addTextChangedListener
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.button.MaterialButton
import com.google.android.material.card.MaterialCardView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.qflistudio.azure.R
import com.qflistudio.azure.common.ktx.showSnackBar
import com.qflistudio.azure.editor.CodeEditor
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.LuaUtils.Companion.TAG
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.util.ResUtils
import com.qflistudio.azure.util.StringUtils
import com.qflistudio.azure.util.ViewUtils
import io.github.rosemoe.sora.text.ContentIO
import java.io.File

class Dialogs {
    // 主题管理器
    var fileUtils = FileUtils()
    lateinit var themeManager: ThemeManager
    lateinit var themeColors: ThemeManager.ThemeColors

    fun setTManager(tm: ThemeManager) {
        themeManager = tm
        themeColors = themeManager.themeColors
    }



    fun createWebDavConfigDialog(context: Context): MaterialAlertDialogBuilder {
        val webDavConfigDialog = MaterialAlertDialogBuilder(context)
        webDavConfigDialog.setTitle(R.string.webdav_config_text)
        webDavConfigDialog.setMessage(R.string.webdav_config_tips_text)
        webDavConfigDialog.setView(R.layout.layout_webdav_config_dlg)
        return webDavConfigDialog
    }

    fun createLoadingDialog(context: Context, title: String, message: String): ProgressDialog {
        val progressDialog = ProgressDialog(context)
        return progressDialog
    }

    fun createRenameDialog(
        context: Context,
        file: File,
        listener: OnCompleteListener?,
    ): BottomSheetDialog {
        val fileParent = file.parent
        val fileName = file.name

        val renameDlg = BottomSheetDialog(context)
        renameDlg.setContentView(R.layout.layout_file_rename_dlg)
        // 获取布局中的视图
        val backgroundView =
            renameDlg.findViewById<View>(R.id.layout_rename_file_dlg_root)

        val file_rename_dlg_til =
            renameDlg.findViewById<View>(R.id.file_rename_dlg_til) as TextInputLayout
        val file_rename_dlg_tiet =
            renameDlg.findViewById<View>(R.id.file_rename_dlg_tiet) as TextInputEditText
        val okButton = renameDlg.findViewById<View>(R.id.rename_dlg_button)

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        file_rename_dlg_tiet.setText(fileName)
        file_rename_dlg_tiet.keyListener =
            DigitsKeyListener.getInstance("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_.")
        file_rename_dlg_tiet.addTextChangedListener { s ->
            val inputText = s.toString()
            // 检查输入的文本是否包含非法字符
            if (StringUtils().checkInvalidSymbol(inputText)) {
                file_rename_dlg_til.helperText =
                    ResUtils().getString(context, "warning_symbols_tips")
                file_rename_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
            } else if (inputText.isEmpty()) {
                // 如果输入为空
                file_rename_dlg_til.helperText =
                    ResUtils().getString(context, "type_file_name_tips")
                file_rename_dlg_til.setHelperTextColor(themeColors.rightColorStateList)
            } else {
                // 输入合法并且非空
                file_rename_dlg_til.helperText = null
                file_rename_dlg_til.setHelperTextColor(themeColors.rightColorStateList)
            }
        }

        okButton?.setOnClickListener {
            val newFileName = file_rename_dlg_tiet.text.toString()
            if (newFileName != "") {
                val desFile = File("$fileParent/$newFileName")
                val renameState = fileUtils.renameFile(file, desFile)
                if (renameState) {
                    listener?.onSucceed()
                } else {
                    listener?.onError()
                }
                renameDlg.dismiss()
            } else {
                // 如果输入为空
                file_rename_dlg_til.helperText =
                    ResUtils().getString(context, "type_file_name_tips")
                file_rename_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
            }
        }

        return renameDlg
    }

    fun createErrorDialog(
        context: Context,
        msg: String?,
        listener: OnCompleteListener?,
    ): BottomSheetDialog {
        val errorDialog = BottomSheetDialog(context)
        errorDialog.setContentView(R.layout.layout_error_dlg)
        // 获取布局中的视图
        val backgroundView =
            errorDialog.findViewById<View>(R.id.layout_error_dlg_root)
        val editor =
            errorDialog.findViewById<View>(R.id.code_editor) as CodeEditor
        val okButton = errorDialog.findViewById<View>(R.id.error_dialog_btn)

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        //setFullScreenBottomSheetDlg(errorDialog)
        editor.setText(msg)

        okButton?.setOnClickListener {
            val errorText = editor.text.toString()
            listener?.onError(errorText)
            errorDialog.dismiss()
        }

        return errorDialog
    }

    fun createEditorDialog(
        context: Context,
        title: String?,
        file: File,
    ): BottomSheetDialog {
        val editorDialog = BottomSheetDialog(context)
        editorDialog.setContentView(R.layout.layout_editor_dlg)
        val bottomSheetBehavior =
            BottomSheetBehavior.from(editorDialog.findViewById(com.google.android.material.R.id.design_bottom_sheet)!!)
        bottomSheetBehavior.isDraggable = false // 禁用拖动手势

        // 获取布局中的视图
        val backgroundView =
            editorDialog.findViewById<View>(R.id.layout_editor_dlg_root)
        val editorDialogTitle =
            editorDialog.findViewById<AppCompatTextView>(R.id.editor_dlg_title_tv)
        val editor =
            editorDialog.findViewById<CodeEditor>(R.id.code_editor)
        val okButton = editorDialog.findViewById<View>(R.id.editor_dialog_btn)

        editorDialogTitle?.text = title

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        //setFullScreenBottomSheetDlg(editorDialog)

        // 使用 'use' 来自动关闭 inputStream
        file.inputStream().use { inputStream ->
            val text = ContentIO.createFrom(inputStream)
            editor?.setText(text, null)
        }

        okButton?.setOnClickListener {
            editorDialog.dismiss()
        }
        return editorDialog
    }

    fun createNewFileDialog(
        context: Context,
        currentDir: String,
        listener: OnCompleteListener?,
    ): BottomSheetDialog {
        val createNewFileDlg = BottomSheetDialog(context)
        createNewFileDlg.setContentView(R.layout.layout_add_file_dlg)
        // 获取布局中的视图
        val backgroundView =
            createNewFileDlg.findViewById<View>(R.id.layout_add_file_dlg_root)
        val fileTypeList =
            createNewFileDlg.findViewById<View>(R.id.add_file_dlg_file_type_sp) as Spinner
        val add_file_dlg_til =
            createNewFileDlg.findViewById<View>(R.id.add_file_dlg_til) as TextInputLayout
        val add_file_dlg_tiet =
            createNewFileDlg.findViewById<View>(R.id.add_file_dlg_tiet) as TextInputEditText
        val okButton = createNewFileDlg.findViewById<View>(R.id.create_file_btn)
        val file_is_exists = context.getString(R.string.file_is_exists)
        val folder_string = context.getString(R.string.folder)
        val custom_suffix_string = context.getString(R.string.custom_suffix)

        val templateManager = TemplateManager()

        val fileTypeTable =
            listOf(
                "*.lua",
                "*.aly",
                "*.java",
                "*.xml",
                "*.py",
                "*.c",
                "*.cpp",
                "*.html",
                "*.css",
                "*.txt",
                "*.md",
                custom_suffix_string,
                folder_string
            )
        val newFileTypeTable = mapOf(
            "*.lua" to "lua",
            "*.aly" to "aly",
            "*.java" to "java",
            "*.xml" to "xml",
            "*.py" to "py",
            "*.c" to "c",
            "*.cpp" to "cpp",
            "*.html" to "html",
            "*.css" to "css",
            "*.txt" to "txt",
            "*.md" to "md"
        )

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        // 创建 ArrayAdapter 工程类型存入列表中
        val appTypeAdp =
            ArrayAdapter(context, android.R.layout.simple_list_item_1, fileTypeTable)
        // 设置适配器到 ListView
        fileTypeList.adapter = appTypeAdp
        add_file_dlg_tiet.keyListener =
            DigitsKeyListener.getInstance("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_.")
        add_file_dlg_tiet.addTextChangedListener { s ->
            val inputText = s.toString()
            // 检查输入的文本是否包含非法字符
            if (StringUtils().checkInvalidSymbol(inputText)) {
                add_file_dlg_til.helperText =
                    ResUtils().getString(context, "warning_symbols_tips")
                add_file_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
            } else if (inputText.isEmpty()) {
                // 如果输入为空
                add_file_dlg_til.helperText = ResUtils().getString(context, "type_appname_tips")
                add_file_dlg_til.setHelperTextColor(themeColors.rightColorStateList)
            } else {
                // 输入合法并且非空
                add_file_dlg_til.helperText = null
                add_file_dlg_til.setHelperTextColor(themeColors.rightColorStateList)
            }
        }

        okButton?.setOnClickListener {
            var defaultContent = ""

            val selectedType = fileTypeTable[fileTypeList.selectedItemPosition]
            val newFileExtensionName =
                newFileTypeTable[selectedType]
                    ?: ""
            val newFileName = add_file_dlg_tiet.text.toString()
            var newFilePath = "$currentDir/$newFileName"

            if (newFileName.isEmpty()) {
                // 如果输入为空
                add_file_dlg_til.helperText = ResUtils().getString(context, "type_appname_tips")
                add_file_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
            } else {
                if (selectedType == folder_string) {
                    val newFileDirPath = newFilePath
                    if (File(newFileDirPath).exists()) {
                        add_file_dlg_til.helperText = file_is_exists
                        add_file_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
                        listener?.onError(file_is_exists)
                    } else {
                        File(newFileDirPath).mkdirs()
                        listener?.onSucceed()
                        createNewFileDlg.dismiss()
                    }
                } else if (selectedType == custom_suffix_string) {
                    if (File(newFilePath).exists()) {
                        add_file_dlg_til.helperText = file_is_exists
                        add_file_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
                        listener?.onError(file_is_exists)
                    } else {
                        File(newFilePath).writeText("")
                        listener?.onSucceed()
                        createNewFileDlg.dismiss()
                    }
                } else {
                    newFilePath = "$currentDir/$newFileName.$newFileExtensionName"
                    if (File(newFilePath).exists()) {
                        add_file_dlg_til.helperText = file_is_exists
                        add_file_dlg_til.setHelperTextColor(themeColors.wrongColorStateList)
                        listener?.onError(file_is_exists)
                    } else {
                        defaultContent = templateManager.getFileTemplate(newFileExtensionName)
                        File(newFilePath).writeText(defaultContent)
                        listener?.onSucceed()
                        createNewFileDlg.dismiss()
                    }
                }

            }
        }

        return createNewFileDlg
    }

    // 新建工程对话框
    fun createProjectDialog(
        context: Context,
        view: View?,
        listener: OnProjectCreatedListener?,
        projectTypeTable: List<String>,
        newProjectTypeTable: Map<String, String>,
    ): BottomSheetDialog {
        var createProjectStatus: Boolean
        val createProjectDlg = BottomSheetDialog(context)
        createProjectDlg.setContentView(R.layout.layout_create_project_dlg)
        // 获取布局中的视图
        val backgroundView =
            createProjectDlg.findViewById<View>(R.id.layout_create_proj_dlg_root)
        val app_name_til =
            createProjectDlg.findViewById<View>(R.id.app_name_til) as TextInputLayout
        val app_name_tiet =
            createProjectDlg.findViewById<View>(R.id.app_name_tiet) as TextInputEditText
        val app_packagename_til =
            createProjectDlg.findViewById<View>(R.id.app_packagename_til) as TextInputLayout
        val app_packagename_tiet =
            createProjectDlg.findViewById<View>(R.id.app_packagename_tiet) as TextInputEditText
        val appTypeList = createProjectDlg.findViewById<View>(R.id.project_type_sp) as Spinner
        val okButton = createProjectDlg.findViewById<View>(R.id.create_project_btn)

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        // 创建 ArrayAdapter 工程类型存入列表中
        val appTypeAdp =
            ArrayAdapter(context, android.R.layout.simple_list_item_1, projectTypeTable)
        // 设置适配器到 ListView
        appTypeList.adapter = appTypeAdp
        app_name_tiet.addTextChangedListener { s ->
            val inputText = s.toString()
            // 检查输入的文本是否包含非法字符
            if (StringUtils().checkInvalidSymbol(inputText)) {
                app_name_til.helperText =
                    ResUtils().getString(context, "warning_symbols_tips")
                app_name_til.setHelperTextColor(themeColors.wrongColorStateList)
            } else if (inputText.isEmpty()) {
                // 如果输入为空
                app_name_til.helperText = ResUtils().getString(context, "type_appname_tips")
                app_name_til.setHelperTextColor(themeColors.rightColorStateList)
            } else {
                // 输入合法并且非空
                app_name_til.helperText = null
                app_name_til.setHelperTextColor(themeColors.rightColorStateList)
            }
        }

        app_packagename_tiet.addTextChangedListener { s ->
            val inputText = s.toString()
            // 检查输入的文本是否包含非法字符
            if (StringUtils().checkInvalidSymbol(inputText)) {
                app_packagename_til.helperText =
                    ResUtils().getString(context, "warning_symbols_tips")
                app_packagename_til.setHelperTextColor(themeColors.wrongColorStateList)
            } else if (inputText.isEmpty()) {
                // 如果输入为空
                app_packagename_til.helperText =
                    ResUtils().getString(context, "type_apppackagename_tips")
                app_packagename_til.setHelperTextColor(themeColors.rightColorStateList)
            } else {
                // 输入合法并且非空
                app_packagename_til.helperText = null
                app_packagename_til.setHelperTextColor(themeColors.rightColorStateList)
            }
        }

        okButton?.setOnClickListener {
            // 工程类型 common_lua / lua_java
            val projectType =
                newProjectTypeTable[projectTypeTable[appTypeList.selectedItemPosition]]
                    ?: "common_lua"
            if (app_name_tiet.text.toString().isEmpty() || app_packagename_tiet.text.toString()
                    .isEmpty()
            ) {
                if (app_name_tiet.text.toString().isEmpty()) {
                    // 如果输入为空
                    app_name_til.helperText = ResUtils().getString(context, "type_appname_tips")
                    app_name_til.setHelperTextColor(themeColors.wrongColorStateList)
                }
                if (app_packagename_tiet.text.toString().isEmpty()) {
                    // 如果输入为空
                    app_packagename_til.helperText =
                        ResUtils().getString(context, "type_apppackagename_tips")
                    app_packagename_til.setHelperTextColor(themeColors.wrongColorStateList)
                }
            }

            createProjectStatus = ProjectUtils().createLocalProject(
                context,
                app_name_tiet.text.toString(),
                app_packagename_tiet.text.toString(),
                projectType
            )

            listener?.onProjectCreated(createProjectStatus, projectType)
            if (createProjectStatus) {
                // 创建工程成功
                (view ?: backgroundView).showSnackBar(R.string.create_project_succeed)
                createProjectDlg.dismiss()
            } else {
                // 创建工程失败
                backgroundView.showSnackBar(R.string.create_project_error, true)
            }
        }
        return createProjectDlg
    }

    fun createLocalProjectDialog(
        context: Context,
        view: View?,
        listener: OnProjectCreatedListener?,
    ): BottomSheetDialog {
        val lua_common_project_string = context.getString(R.string.lua_common_project)
        val luajava_mix_project_string = context.getString(R.string.luajava_mix_project)

        val projectTypeTable =
            listOf(
                lua_common_project_string,
                luajava_mix_project_string,
                "Java",
                "Python",
                "C",
                "C++"
            )
        val newProjectTypeTable = mapOf(
            lua_common_project_string to "common_lua",
            luajava_mix_project_string to "lua_java",
            "Java" to "java",
            "Python" to "python",
            "C" to "c",
            "C++" to "cpp"
        )
        val createProjectDlg =
            createProjectDialog(context, view, listener, projectTypeTable, newProjectTypeTable)
        return createProjectDlg
    }

    fun createArgbDialog(context: Context, listener: OnColorSelectedListener): BottomSheetDialog {
       return createArgbDialog(context, null, listener)
    }

    fun createArgbDialog(context: Context, colorInt: Int?, listener: OnColorSelectedListener): BottomSheetDialog {
        val createArgbDlg = BottomSheetDialog(context)
        createArgbDlg.setContentView(R.layout.layout_argb_dlg)
        val colorCard = createArgbDlg.findViewById<View>(R.id.color_cv) as MaterialCardView
        val colorText = createArgbDlg.findViewById<TextView>(R.id.color_tv)!!
        val seekBarA = createArgbDlg.findViewById<SeekBar>(R.id.color_sb_1)!!
        val seekBarR = createArgbDlg.findViewById<SeekBar>(R.id.color_sb_2)!!
        val seekBarG = createArgbDlg.findViewById<SeekBar>(R.id.color_sb_3)!!
        val seekBarB = createArgbDlg.findViewById<SeekBar>(R.id.color_sb_4)!!
        val confirmButton = createArgbDlg.findViewById<MaterialButton>(R.id.argb_tool_ok_btn)!!
        val backgroundView =
            createArgbDlg.findViewById<View>(R.id.layout_argb_dlg_root)

        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)

        var alpha: Int = 255
        var red: Int = 0
        var green: Int = 0
        var blue: Int = 0

        if (colorInt != null) {
            // 解析 ARGB 值
             alpha = Color.alpha(colorInt)
             red = Color.red(colorInt)
             green = Color.green(colorInt)
             blue = Color.blue(colorInt)
        }

        // 设置默认值（完全不透明的红色）
        seekBarA.progress = alpha
        seekBarR.progress = red
        seekBarG.progress = green
        seekBarB.progress = blue


        fun updateArgb() {
            val a = seekBarA.progress
            val r = seekBarR.progress
            val g = seekBarG.progress
            val b = seekBarB.progress
            val color = Color.argb(a, r, g, b)

            // 设置颜色显示
            colorCard.setCardBackgroundColor(color)

            // 显示 ARGB 颜色值（16进制）
            colorText.text = String.format("#%02X%02X%02X%02X", a, r, g, b)
        }

        updateArgb()

        // 设置 SeekBar 监听器
        val seekBarListener = object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                updateArgb()
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
            override fun onStopTrackingTouch(seekBar: SeekBar?) {}
        }

        // 监听 SeekBar 变化
        seekBarA.setOnSeekBarChangeListener(seekBarListener)
        seekBarR.setOnSeekBarChangeListener(seekBarListener)
        seekBarG.setOnSeekBarChangeListener(seekBarListener)
        seekBarB.setOnSeekBarChangeListener(seekBarListener)

        // 初始化颜色
        updateArgb()

        // 确认按钮 - 触发回调并关闭对话框
        confirmButton.setOnClickListener {
            val selectedColor = Color.argb(
                seekBarA.progress,
                seekBarR.progress,
                seekBarG.progress,
                seekBarB.progress
            )
            listener.onColorSelected(selectedColor) // 触发回调
            createArgbDlg.dismiss()
        }

        return createArgbDlg
    }

    fun createInsertCodeDialog(
        context: Context,
        data: Map<String, *>?,
        listener: OnCodeListener,
    ): BottomSheetDialog {
        val insertCodeDlg = BottomSheetDialog(context)
        insertCodeDlg.setContentView(R.layout.layout_insert_code_dlg)
        // 获取底部Sheet布局
        val bottomSheet = insertCodeDlg.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)
        bottomSheet?.let { sheet ->
            val layoutParams = sheet.layoutParams
            layoutParams.height = ViewGroup.LayoutParams.MATCH_PARENT  // 设置为全屏高度
            sheet.layoutParams = layoutParams

            val bottomSheetBehavior = BottomSheetBehavior.from(sheet)
            bottomSheetBehavior.isDraggable = false  // 禁用拖动手势
            bottomSheetBehavior.state = BottomSheetBehavior.STATE_EXPANDED // 默认展开
            bottomSheetBehavior.peekHeight = Resources.getSystem().displayMetrics.heightPixels // 最大展开
        }

        val backgroundView = insertCodeDlg.findViewById<View>(R.id.layout_insert_code_dlg_root)
        ViewUtils().dialogCorner(backgroundView as View, themeColors.backgroundColor, 15f)
        val arrayExpandableListAdapter = ArrayExpandableListAdapter(context)
        val expandableLv =
            insertCodeDlg.findViewById<View>(R.id.insert_code_expandable_lv) as ExpandableListView
        expandableLv.setAdapter(arrayExpandableListAdapter)
        expandableLv.setOnGroupExpandListener {

        }
        expandableLv.setOnChildClickListener { parent, view, groupPosition, childPosition, id ->
            var code = ""
            if (data != null) {
                val groupKey = data.getValue((groupPosition + 1).toString()) as String
                val groupMap = data.getValue(groupKey) as Map<String, Any>
                val childKey = groupMap.getValue((childPosition + 1).toString()) as String
                code = groupMap.getValue(childKey) as String
                Log.i(TAG, "setOnChildClickListener $groupKey - $groupMap $childKey $code")
            }
            listener.onCodeSelected(code) // 触发回调
            insertCodeDlg.dismiss()
            true
        }
        if (data != null) {
            for ((key, value) in data) {
                if (key.toIntOrNull() != null && value is String) {
                    val groupKey = value
                    val groupMap = data.getValue(groupKey) as Map<String, Any>

                    if (groupMap is Map<String, Any>) {
                        val childList = mutableListOf<String>()
                        for ((subKey, subValue) in groupMap) {
                            if (subKey.toIntOrNull() != null && subValue is String) {
                                // Log.i(TAG, "createInsertCodeDialog $groupKey - $subValue")
                                childList.add(subValue)
                            }
                        }
                        arrayExpandableListAdapter.add(groupKey, childList)
                    }

                }
            }
        }
        return insertCodeDlg
    }

}