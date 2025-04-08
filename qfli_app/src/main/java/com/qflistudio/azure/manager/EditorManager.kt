package com.qflistudio.azure.manager

import android.content.Context
import android.content.res.Configuration
import android.util.Log
import com.luastudio.azure.AzureLibrary
import com.qflistudio.azure.bean.EditorInfo
import com.qflistudio.azure.editor.CodeEditor
import com.qflistudio.azure.util.EditorUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.JsonUtils
import io.github.rosemoe.sora.lang.Language
import io.github.rosemoe.sora.langs.textmate.TextMateColorScheme
import io.github.rosemoe.sora.langs.textmate.TextMateLanguage
import io.github.rosemoe.sora.langs.textmate.registry.FileProviderRegistry
import io.github.rosemoe.sora.langs.textmate.registry.GrammarRegistry
import io.github.rosemoe.sora.langs.textmate.registry.ThemeRegistry
import io.github.rosemoe.sora.langs.textmate.registry.model.ThemeModel
import io.github.rosemoe.sora.langs.textmate.registry.provider.AssetsFileResolver
import io.github.rosemoe.sora.widget.schemes.EditorColorScheme
import io.github.rosemoe.sora.widget.schemes.SchemeDarcula
import org.eclipse.tm4e.core.registry.IThemeSource
import java.io.File

class EditorManager(private val context: Context, private val fileUtils: FileUtils) {
    private val TAG = "EditorManager"
    private val studioExtDir = AzureLibrary.studioExtDir
    private val customSettingsDir = "$studioExtDir/qflistudio_custom"
    private val symbolsRecordFilePath = "$customSettingsDir/editor_symbols.json"  // JSON文件名
    private var symbolsData: MutableList<String>? = null
    private val jsonUtils: JsonUtils by lazy { JsonUtils() }
    private val editorUtils: EditorUtils by lazy { EditorUtils() }

    private lateinit var editors: MutableMap<CodeEditor, EditorInfo>

    private var isEditorTMSetup = false

    private var defaultSymbolsData = mutableListOf(
        "FUN", "(", ")", "[", "]",
        "{", "}", "<", ">", "=", """"""", "'", ",", ".", ";", "_",
        "+", "-", "*", "/", "|", "\\", "%", "#", "?"
    )

    fun init() {
        initSymbolsData()
        editors = mutableMapOf<CodeEditor, EditorInfo>()
    }

    /**
     * Setup Textmate. Load our grammars and themes from assets
     */
    private fun setupEditorTextmate() {
        if (!isEditorTMSetup) {
            // Add assets file provider so that files in assets can be loaded
            FileProviderRegistry.getInstance().addFileProvider(
                AssetsFileResolver(
                    context.applicationContext.assets // use application context
                )
            )
            loadEditorDefaultThemes()
            loadEditorDefaultLanguages()
            isEditorTMSetup = true
        }
    }

    private /*suspend*/ fun loadEditorDefaultThemes() /*= withContext(Dispatchers.IO)*/ {
        val themes = arrayOf("darcula", "abyss", "quietlight", "solarized_drak")
        val themeRegistry = ThemeRegistry.getInstance()
        themes.forEach { name ->
            val path = "textmate/$name.json"
            themeRegistry.loadTheme(
                ThemeModel(
                    IThemeSource.fromInputStream(
                        FileProviderRegistry.getInstance().tryGetInputStream(path), path, null
                    ), name
                ).apply {
                    if (name != "quietlight") {
                        isDark = true
                    }
                }
            )
        }

        themeRegistry.setTheme("quietlight")
    }

    private /*suspend*/ fun loadEditorDefaultLanguages() /*= withContext(Dispatchers.Main)*/ {
        GrammarRegistry.getInstance().loadGrammars("textmate/languages.json")
    }

    private fun getEditorTextmateTheme(codeEditor: CodeEditor): EditorColorScheme {
        var editorColorScheme = codeEditor.colorScheme
        if (editorColorScheme !is TextMateColorScheme) {
            editorColorScheme = TextMateColorScheme.create(ThemeRegistry.getInstance())
        }
        return editorColorScheme
    }

    fun ensureEditorTextmateTheme(codeEditor: CodeEditor) {
        val colorScheme = getEditorTextmateTheme(codeEditor)
        codeEditor.colorScheme = colorScheme
    }

    fun switchThemeIfRequired(context: Context, editor: CodeEditor) {
        if ((context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES) {
            if (editor.colorScheme is TextMateColorScheme) {
                ThemeRegistry.getInstance().setTheme("darcula")
            } else {
                editor.colorScheme = SchemeDarcula()
            }
        } else {
            if (editor.colorScheme is TextMateColorScheme) {
                ThemeRegistry.getInstance().setTheme("quietlight")
            } else {
                editor.colorScheme = EditorColorScheme()
            }
        }
        editor.invalidate()
    }

    fun getEditors(): MutableMap<CodeEditor, EditorInfo>? {
        if (::editors.isInitialized) {
            return editors
        }
        return null
    }

    fun initEditor(codeEditor: CodeEditor, editorMode: String) {
        setupEditorTextmate()
        val data = editors[codeEditor]
        val language: Language
        val colorScheme = getEditorTextmateTheme(codeEditor)
        if (data != null) {
            language = data.editorLanguage
        } else {
            val currentFile = codeEditor.getCurrOpenedFile()
            if (currentFile != null) {
                Log.i(TAG, "currentFile: ${currentFile.absolutePath}")
                language = editorUtils.getFileLanguage(currentFile, editorMode)
                editors[codeEditor] = EditorInfo(language, editorMode)
            } else {
                language = TextMateLanguage.create("text.html.markdown", true)
                editors[codeEditor] = EditorInfo(language, editorMode)
            }
        }
        // 设置 colorScheme
        codeEditor.colorScheme = colorScheme
        // 设置编辑器语言
        codeEditor.setEditorLanguage(language)
    }


    fun initSymbolsData() {
        val newSymbolsData = defaultSymbolsData
        val symbolsRecordFile = File(symbolsRecordFilePath)
        if (symbolsRecordFile.exists()) {
            symbolsData = jsonUtils.loadArrayFromJsonFile(symbolsRecordFile)
            if (symbolsData == null) {
                symbolsData = newSymbolsData
            }
        } else {
            symbolsData = newSymbolsData
        }
        Log.i(TAG, symbolsData.toString())
    }

    fun getSymbolsData(): MutableList<String> {
        return symbolsData ?: defaultSymbolsData
    }


}