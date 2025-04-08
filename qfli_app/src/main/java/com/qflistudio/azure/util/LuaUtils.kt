package com.qflistudio.azure.util

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import com.luajava.LuaException
import com.luajava.LuaObject
import com.luajava.LuaState
import com.luajava.LuaStateFactory
import com.luajava.LuaTable
import com.luastudio.azure.LuaAppActivity
import com.luastudio.azure.LuaAppActivityX
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream

class LuaUtils {
    companion object {
        const val ARG = "arg"
        const val DATA = "data"
        const val NAME = "name"
        const val TAG = "LuaUtils"
    }

    // 初始化 LuaState
    fun init(): LuaState {
        val luaState = LuaStateFactory.newLuaState()
        luaState.openLibs()
        return luaState
    }

    // 关闭 lua 解释器
    fun close(luaState: LuaState) {
        // 出现异常时确保关闭
        System.gc()
        luaState.gc(LuaState.LUA_GCCOLLECT, 1)
        //luaState.close()
    }

    // 执行 Lua 字符串
    fun doString(string: String): LuaState? {
        val luaState = init()
        return try {
            luaState.LdoString(string)
            luaState
        } catch (e: LuaException) {
            Log.e(TAG, "Error executing Lua string: ${e.message}")
            close(luaState)
            null
        }
    }

    // 编译文件
    fun consoleBuild(path: String): Any? {
        val luaState = init()
        return try {
            // 加载 Lua 文件
            val ok = luaState.LloadFile(path)
            if (ok != 0) {
                val errorMsg = luaState.toString(-1)
                Log.e(TAG, "加载 Lua 文件失败: $errorMsg")
                close(luaState)
                return null
            }
            val env: LuaObject = luaState.getLuaObject(-1)
            luaState.setUpValue(-2, 1)
            // 编译成字节码
            val stringDumpFunction = luaState.getLuaObject("string").getField("dump").function
            val str2 = stringDumpFunction.call(env, true)
            val byteArray = (str2 as String).toByteArray(Charsets.ISO_8859_1)
            Log.i(TAG, "Lua 编译成功: ${str2}")
            val compiledPath = path + "c"
            FileOutputStream(File(compiledPath)).write(byteArray)
            compiledPath
        } catch (e: LuaException) {
            // 出现异常时确保关闭
            Log.e(TAG, "Error executing Lua File: ${e.message}")
            close(luaState)
            e
        }
    }


    // 检查代码错误
    fun checkCodeError(funcSrc: String): Pair<Boolean?, String?> {
        val luaState = init()
        return try {
            luaState?.setTop(0)
            val ok = luaState?.LloadString(funcSrc)
            val result = ok?.let { outputErrorReason(it) } + luaState?.toString(-1)
            Pair(ok == 0, result) // 返回 ok 和 result
        } catch (e: LuaException) {
            Log.e(TAG, "Error executing Lua string: ${e.message}")
            // 出现异常时确保关闭
            close(luaState)
            Pair(false, e.message) // 如果有异常，返回 false 和错误信息
        }
    }

    fun outputErrorReason(code: Int): String {
        return when (code) {
            1 -> "Yield Error: "
            2 -> "Runtime Error: "
            3 -> "Syntax Error: "
            4 -> "Out of memory: "
            5 -> "GC Error: "
            0 -> "No Error"
            else -> "Unknown Error: "
        }
    }


    // 执行 Lua 文件
    fun doFile(filePath: String): LuaState? {
        val luaState = init()
        return try {
            luaState.LdoFile(filePath)
            luaState
        } catch (e: LuaException) {
            Log.e(TAG, "Error executing Lua File: ${e.message}")
            close(luaState)
            null
        }
    }

    // 执行 Lua 文件
    fun loadFile(filePath: String): LuaState? {
        val luaState = init()
        return try {
            luaState.LloadFile(filePath)
            luaState
        } catch (e: LuaException) {
            Log.e(TAG, "Error executing Lua File: ${e.message}")
            close(luaState)
            null
        }
    }


    // 读取 Lua 表数据
    fun readLuaTable(luaState: LuaState, tableName: String): Map<*, *>? {
        return try {
            luaState.getGlobal(tableName)
            if (!luaState.isTable(-1)) {
                Log.e(TAG, "$tableName is not a valid table.")
                luaState.pop(1) // 移除错误的表对象，防止 Lua 栈泄露
                return null
            }
            val luaTable = mutableMapOf<String, Any>()
            luaState.pushNil()

            while (luaState.next(-2) != 0) {
                val key = luaState.toString(-2) ?: continue
                Log.i(TAG, "readLuaTable key:" + key)
                val value: Any = when {
                    luaState.isNumber(-1) -> luaState.toNumber(-1)
                    luaState.isString(-1) -> luaState.toString(-1)
                    luaState.isBoolean(-1) -> luaState.toBoolean(-1)
                    else -> luaState
                }
                luaTable[key] = value
                luaState.pop(1) // 弹出值，保持 Lua 栈平衡
            }
            luaState.pop(1) // 弹出整个表
            luaTable
        } catch (e: LuaException) {
            Log.e(TAG, "Error reading Lua table: ${e.message}")
            close(luaState)
            null
        }
    }

    // 读取 Lua 表数据
    fun readLuaTable2(luaState: LuaState, tableName: String): Map<*, *>? {
        return try {
            val luaTable = mutableMapOf<String, Any>()
            luaState.pushNil()

            while (luaState.next(-2) != 0) {
                val key = luaState.toString(-2) ?: continue
                Log.i(TAG, "key:" + key)
                val value: Any = when {
                    luaState.isNumber(-1) -> luaState.toNumber(-1)
                    luaState.isString(-1) -> luaState.toString(-1)
                    luaState.isBoolean(-1) -> luaState.toBoolean(-1)
                    else -> luaState
                }
                luaTable[key] = value
                luaState.pop(1) // 弹出值，保持 Lua 栈平衡
            }
            luaState.pop(1) // 弹出整个表
            luaTable
        } catch (e: LuaException) {
            Log.e(TAG, "Error reading Lua table: ${e.message}")
            close(luaState)
            null
        }
    }

    fun luaTable2Map(luaObj: LuaObject): Map<*, *>? {
        return try {
            if (luaObj.isTable) {
                val luaTable = luaObj as LuaTable<*, *>
                val newLuaTable = mutableMapOf<String, Any?>()
                val sets: MutableSet<out MutableMap.MutableEntry<out Any, out Any>> =
                    luaTable.entries
                for ((key, value) in sets) {
                    try {
                        newLuaTable[key.toString()] = value
                    } catch (e: java.lang.Exception) {
                        Log.i("lua", e.message!!)
                    }
                }
                Log.i("newLuaTable", newLuaTable.toString())
                newLuaTable
            } else {
                Log.e(TAG, "This is not a table or does not exist.")
                null
            }
        } catch (e: LuaException) {
            Log.e(TAG, "Error reading Lua table: ${e.message}")
            null
        }
    }

    /**
     * 解析 Lua 值（支持 String, Number, Table）
     */
    fun luaGetValue(L: LuaState, index: Int): Any {
        return when {
            L.isString(index) -> L.toString(index) ?: ""
            L.isNumber(index) -> L.toNumber(index)
            else -> "[Unsupported Type]"
        }
    }

    /**
     * 解析 Lua 混合表为 Map<String, Any>
     */
    fun getSubMap(luaTable: LuaTable<*, *>, key: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        val entrySet = luaTable.entries
        entrySet.forEach { v ->
            // Log.i(TAG, "getSubMap $key  ${v.key} - ${v.value} ")
            map[v.key.toString()] = v.value
        }
        val sortedMap = map.toSortedMap(compareBy { it.toIntOrNull() ?: Int.MAX_VALUE })
        return sortedMap
    }

    fun luaMixedTableToMap(luaTable: LuaTable<*, *>): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        val entrySet = luaTable.entries
        entrySet.forEach { v ->
            if (v.value is LuaTable<*, *>) {
                val childMap = luaMixedTableToMap(v.value as LuaTable<*, *>)
                Log.i(TAG, "遍历 entrySet ${v.key} - ${v.value} \n ${childMap} ")
                map[v.key.toString()] = childMap
            } else {
                map[v.key.toString()] = v.value as String
            }
        }
        return map.toSortedMap(compareBy { it })
    }

    fun loadLuaTableFromFile(luaPath: String, tableName: String): Map<String, Any>? {
        Log.i(TAG, "loadLuaTableFromFile")
        var luaState: LuaState? = null  // 确保 luaState 在 finally 中可用

        return try {
            // 使用 doFile 加载 Lua 文件并初始化 LuaState
            // 加载 Lua 脚本
            luaState = doFile(luaPath)
            val luaTableObject = luaState?.getLuaObject(tableName)

            if (luaState != null) {
                if (luaTableObject?.isTable == true) {
                    Log.i(TAG, "Lua 表 $tableName 存在！")
                    val luaTable = luaTableObject.table as LuaTable
                    val luaTableMap = luaMixedTableToMap(luaTable)

                    for ((key, value) in luaTableMap) {
                        if (key.toIntOrNull() != null) {
                            Log.i(TAG, "遍历 luaMixedTableToMap $key - $value - ${luaTableMap[value]} ")
                        }
                    }
                    luaTableMap
                } else {
                    Log.i(TAG, "Lua 表 $tableName 为空！")
                    null
                }
            } else {
                Log.i(TAG, "Lua 表 $tableName 为空！")
                null
            }
        } catch (e: Exception) {
            Log.e(TAG, "An error occurred: ${e.message}")
            null
        } finally {
            luaState?.let { close(it) }
        }
    }


    fun loadBuildInfo(projectPath: String): Map<*, *>? {
        var luaState: LuaState? = null  // 确保 luaState 在 finally 中可用

        return try {
            // 使用 doFile 加载 Lua 文件并初始化 LuaState
            luaState = doFile("$projectPath/build.lsinfo")
            Log.i(TAG, "$projectPath/build.lsinfo")
            // 检查 LuaState 是否为 null，读取 "build_info" 表
            luaState?.let {
                val buildInfo = readLuaTable(it, "build_info")
                if (buildInfo == null) {
                    Log.e(TAG, "build_info table is null or not found")
                } else {
//                    buildInfo.forEach { (key, value) ->
//                        Log.i(TAG, "Key: $key, Value: $value")
//                    }
                }
                buildInfo
            }
        } catch (e: Exception) {
            Log.e(TAG, "An error occurred: ${e.message}")
            null
        } finally {
            luaState?.let { close(it) }
        }
    }

    fun readInitFile(initFilePath: String): Map<*, *>? {
        val luaUtils = LuaUtils()
        var luaState: LuaState? = null  // 确保 luaState 在 finally 中可用

        return try {
            luaState = luaUtils.loadFile(initFilePath)
            Log.i(TAG, initFilePath)
            // 检查 LuaState 是否为 null，读取 "build_info" 表
            luaState?.let {
                luaState.newTable()
                val env: LuaObject = luaState.getLuaObject(-1)
                luaState.setUpValue(-2, 1)
                var ok: Int? = luaState.pcall(0, 0, 0)
                if (ok == 0) {
                    return luaTable2Map(env)
                } else {
                    return null
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "An error occurred: ${e.message}")
            null
        } finally {
            // 确保 LuaState 被关闭
            System.gc()
            luaState?.gc(LuaState.LUA_GCCOLLECT, 1)
            //luaState?.close()
        }
    }

    fun newLSActivityIntent(
        packageContext: Context,
        nextClass: Class<*>,
        nextClassX: Class<*>,
        path: String,
        args: Array<Any>,
        newDocument: Boolean
    ): Intent {
        var path = path
        var intent = Intent(packageContext, nextClass)
        if (newDocument) {
            intent = Intent(packageContext, nextClassX)
        }
        intent.putExtra(NAME, path)
        var luaDir = packageContext.getDir("luastudio", Context.MODE_PRIVATE).getAbsolutePath()

        if (path[0] != '/') path = luaDir + "/" + path
        val f = File(path)
        if (f.isDirectory && File("$path/main.lua").exists()) path += "/main.lua"
        else if ((f.isDirectory || !f.exists()) && !path.endsWith(".lua")) path += ".lua"
        if (!File(path).exists()) throw FileNotFoundException(path)

        intent.setData(Uri.parse("file://$path"))

        if (newDocument) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT)
            intent.addFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
        }
        intent.putExtra("arg", args)  // 传递 Object[] 数组
        return intent
    }

    fun newLSActivityIntent(
        packageContext: Context, path: String, args: Array<Any>, newDocument: Boolean
    ): Intent {
        return newLSActivityIntent(
            packageContext,
            LuaAppActivity::class.java,
            LuaAppActivityX::class.java,
            path,
            args,
            newDocument
        )
    }

    fun skipToActivity(context: Context, luaFilePath: String) {
        skipToActivity(context, luaFilePath, false)
    }

    fun skipToActivity(context: Context, luaFilePath: String, newDocument: Boolean) {
        val args = arrayOf<Any>()
        val intent = LuaUtils().newLSActivityIntent(context, luaFilePath, args, newDocument)
        context.startActivity(intent)
    }

}
