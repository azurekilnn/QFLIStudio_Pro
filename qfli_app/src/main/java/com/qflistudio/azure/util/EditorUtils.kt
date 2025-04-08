package com.qflistudio.azure.util

import android.content.Context
import android.util.Log
import com.luastudio.azure.MyEditor
import com.luastudio.azure.editor.textmate.LuaTextMateLanguage
import io.github.rosemoe.sora.lang.EmptyLanguage
import io.github.rosemoe.sora.lang.Language
import io.github.rosemoe.sora.langs.textmate.TextMateLanguage
import io.github.rosemoe.sora.langs.textmate.registry.GrammarRegistry
import io.github.rosemoe.sora.langs.textmate.registry.dsl.languages
import io.github.rosemoe.sora.text.ContentIO
import io.github.rosemoe.sora.widget.CodeEditor
import java.io.File

class EditorUtils {
    private val TAG = "EditorUtils"

    fun isFileEditorCanOpen(file: File): Boolean {
        val editorType = FileUtils().outputEditorType(file.path)
        val isEditorCanOpen = (editorType == "code" || editorType == "image")
        return isEditorCanOpen
    }

    fun isEditorCanOpen(file: File): Boolean {
        val editorType = FileUtils().outputEditorType(file.path)
        val isEditorCanOpen = (editorType == "code")
        return isEditorCanOpen
    }

    // 获取焦点
    fun requestEditorFocus(editor: CodeEditor) {
        editor.requestFocus()
    }

    fun gotoLine(editor: CodeEditor, line: Int) {
        var realLine = line - 1
        val maxLine = editor.text.lineCount - 1
        if (realLine > maxLine) {
            realLine = maxLine
        }
        editor.setSelection(realLine, 0)
    }

    fun formatCode(editor: CodeEditor) {
        editor.formatCodeAsync()
    }

    // 全选文本
    fun selectAllText(editor: CodeEditor) {
        editor.selectAll()
    }

    // 剪切文本
    fun cutText(editor: CodeEditor) {
        editor.cutText()
    }

    // 剪切文本
    fun cutText(editor: MyEditor) {
        editor.cut()
    }

    // 复制文本
    fun copyText(editor: CodeEditor) {
        editor.copyText()
    }

    // 粘贴文本
    fun pasteText(editor: CodeEditor) {
        editor.pasteText()
    }

    // 粘贴文本
    fun insertText(editor: CodeEditor, text: String) {
        editor.insertText(text, 1)
    }


    // 复制文本
    fun undo(editor: CodeEditor) {
        editor.undo()
    }

    // 复制文本
    fun redo(editor: CodeEditor) {
        editor.redo()
    }


    // 获取选中的文本
    fun getSelectedText(editor: CodeEditor): String {
        val cursor = editor.cursor
        return if (cursor.isSelected) {
            val leftLine = cursor.leftLine
            val rightLine = cursor.rightLine
            val leftColumn = cursor.leftColumn
            val rightColumn = cursor.rightColumn
            val selectedText = editor.text
                .subContent(leftLine, leftColumn, rightLine, rightColumn)
                .toString()
            selectedText
        } else {
            ""
        }
    }


    // 传入文件获取文件语言
    fun getFileLanguage(file: File?, editorMode: String): Language {
        if (file != null && file.exists()) {
            return getFileLanguageScopeName(file.absolutePath)
        } else {
            val scopeName = when (editorMode) {
                "lua" -> "source.lua"
                "python" -> "source.python"
                "c" -> "source.c"
                "cpp" -> "source.c"
                else -> "text.html.markdown"
            }
            if (editorMode == "lua") {
                return LuaTextMateLanguage.create(scopeName, true)
            } else {
                return TextMateLanguage.create(scopeName, true)
            }
        }
    }

    fun getFileLanguageScopeName(filePath: String): Language {
        var language = EmptyLanguage()
        val extensionName = FileUtils().getFileExtension(filePath)
        val tmLanguages = mapOf(
            "java" to "source.java",
            "kt" to "source.kotlin",
            "kts" to "source.kotlin",
            "py" to "source.python",
            "html" to "text.html.basic",
            "js" to "source.js",
            "lua" to "source.lua",
            "aly" to "source.lua",
            "lsinfo" to "source.lua",
            "c" to "source.c",
            "cpp" to "source.c",
            "md" to "text.html.markdown"
        )
        val scopeName = tmLanguages[extensionName]
        if (scopeName != null) {
            if (extensionName == "lua" || extensionName == "aly" || extensionName == "lsinfo") {
                Log.i(TAG, "getFileLanguageScopeName: $scopeName")
                language = LuaTextMateLanguage.create(scopeName, true)
            } else {
                language = TextMateLanguage.create(scopeName, true)
            }
        }
        return language
    }

    // 输出原符号
    fun symbolHandler(symbol: String, selectedText: String): Pair<String, Int> {
        var newSelectionOffset = 1
        when (symbol) {
            "FUN", "fun", "Fun" -> {
                newSelectionOffset = 8
            }
        }
        val newSymbol = when (symbol) {
            // 判断是不是指定特殊符号
            "→" -> " "
            "↓" -> "\n"
            else -> {
                //如果不是特殊符号
                when {
                    //如果选中的不为空
                    selectedText != "" -> {
                        when (symbol) {
                            "FUN", "fun", "Fun" -> "function $selectedText()"
                            "\"" -> "\"$selectedText\""
                            "[", "]" -> "[$selectedText]"
                            "(", ")" -> "($selectedText)"
                            "{", "}" -> "{$selectedText}"
                            "'" -> "'$selectedText'"
                            else -> symbol
                        }
                    }
                    //如果选中的为空
                    else -> {
                        when (symbol) {
                            "FUN", "fun", "Fun" -> "function()"
                            else -> symbol
                        }
                    }
                }
            }
        }
        return Pair(newSymbol, newSelectionOffset)
    }


    private fun loadDefaultLanguagesWithDSL() {
        GrammarRegistry.getInstance().loadGrammars(
            languages {
                language("java") {
                    grammar = "textmate/java/syntaxes/java.tmLanguage.json"
                    defaultScopeName()
                    languageConfiguration = "textmate/java/language-configuration.json"
                }
                language("kotlin") {
                    grammar = "textmate/kotlin/syntaxes/Kotlin.tmLanguage"
                    defaultScopeName()
                    languageConfiguration = "textmate/kotlin/language-configuration.json"
                }
                language("python") {
                    grammar = "textmate/python/syntaxes/python.tmLanguage.json"
                    defaultScopeName()
                    languageConfiguration = "textmate/python/language-configuration.json"
                }
            }
        )
    }

    fun resetColorScheme(codeEditor: CodeEditor) {
        codeEditor.apply {
            val colorScheme = this.colorScheme
            // reset
            this.colorScheme = colorScheme
        }
    }

    fun checkEncryptFile(file: File) {
        file.inputStream().use { inputStream ->
            val text = ContentIO.createFrom(inputStream)

        }
    }

    fun backupFile(context: Context, file: File, binRelativePath: String) {
        val fileUtils = FileUtils()
        val binDir = fileUtils.getBinDir(context, binRelativePath)
        val ofRelativePath = fileUtils.getRelativePath(file, PathUtils.getStudioExtDir())
        val currentTime = System.currentTimeMillis().toString()
        val fileName = file.name
        val fullPath = "$binDir/$ofRelativePath/${currentTime}_$fileName"
        Log.i(TAG, "fullPath: $fullPath")
        file.copyTo(File(fullPath))
    }

}

// 获取选中的文本
fun CodeEditor.getSelectedText(): String {
    val cursor = this.cursor
    return if (cursor.isSelected) {
        val leftLine = cursor.leftLine
        val rightLine = cursor.rightLine
        val leftColumn = cursor.leftColumn
        val rightColumn = cursor.rightColumn
        val selectedText = this.text
            .subContent(leftLine, leftColumn, rightLine, rightColumn)
            .toString()
        selectedText
    } else {
        ""
    }
}


// 选择行
fun CodeEditor.selectLine() {
    val cursor = this.cursor
    val leftLine = cursor.leftLine
    val rightColumn = this.text.getColumnCount(leftLine)
    cursor.setLeft(leftLine, 0)
    cursor.setRight(leftLine, rightColumn)
    this.invalidate();
}


// 选择行
fun CodeEditor.selectLine2() {
    val cursor = this.cursor
    val content = this.text
    val leftLine = cursor.leftLine
    val lineCount = content.lineCount
    if (leftLine == 0) {
        val rightColumn = content.getColumnCount(leftLine)
        cursor.setLeft(leftLine, 0)

        if (lineCount == 1 && rightColumn != 0) {
            cursor.setRight(leftLine, rightColumn)
        } else if (lineCount != 1 && rightColumn != 0) {
            cursor.setRight(1, 0)
        }

    } else {
        val leftColumn = content.getColumnCount(leftLine - 1)
        val rightColumn =content.getColumnCount(leftLine)
        cursor.setLeft(leftLine - 1, leftColumn)
        cursor.setRight(leftLine, rightColumn)
    }

    this.invalidate()
}


fun CodeEditor.cutLine() {
    this.selectLine2()
    this.cutText()
}

