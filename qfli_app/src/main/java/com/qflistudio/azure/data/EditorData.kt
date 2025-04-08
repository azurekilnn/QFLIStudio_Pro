package com.qflistudio.azure.data

import OpGroupItem
import OperationItem
import com.qflistudio.azure.R

object EditorData {
    val editorDrawerOpGroups = mutableMapOf<String, OpGroupItem>()

    // 注册 OpGroupItem
    fun registerOpGroup(key: String, opGroupItem: OpGroupItem) {
        editorDrawerOpGroups[key] = opGroupItem
    }

    // 获取 OpGroupItem
    fun getOpGroup(key: String): OpGroupItem =
        editorDrawerOpGroups[key] ?: OpGroupItem(R.string.unknown_text, mutableListOf())

    fun initAllOpGroups() {
        // 代码操作栏 code_op
        registerOpGroup(
            "code_op", OpGroupItem(
                R.string.code_operation,
                mutableListOf(
                    // 代码对齐
                    OperationItem(
                        R.drawable.twotone_notes_black_24,
                        R.string.code_format,
                        "code_format",
                        false
                    ),
                    // 代码检查
                    OperationItem(
                        R.drawable.twotone_check_circle_black_24,
                        R.string.code_check,
                        "code_check",
                        false
                    ),
                    // 导入分析
                    OperationItem(
                        R.drawable.twotone_analytics_black_24,
                        R.string.import_analysis,
                        "import_analysis",
                        true
                    ),
                    // 代码导航
                    OperationItem(
                        R.drawable.twotone_explore_black_24,
                        R.string.code_navigation,
                        "code_navigation",
                        false
                    ),
                    // 搜索代码
                    OperationItem(
                        R.drawable.twotone_find_in_page_black_24,
                        R.string.search_code,
                        "search_code",
                        false
                    ),
                    OperationItem(
                        R.drawable.twotone_search_black_24,
                        R.string.global_search_code,
                        "global_search_code",
                        false
                    ),
                    OperationItem(
                        R.drawable.twotone_manage_search_black_24,
                        R.string.global_search_code_results,
                        "global_search_code_results",
                        false
                    ),
                    OperationItem(
                        R.drawable.twotone_import_export_black_24,
                        R.string.jump_line,
                        "jump_line",
                        false
                    )
                ),
                true
            )
        )
        // 工程操作栏 proj_op
        registerOpGroup(
            "proj_op", OpGroupItem(
                R.string.project_operation,
                mutableListOf(
                    // 打包工程
                    OperationItem(
                        R.drawable.twotone_adb_black_24,
                        R.string.bin_project,
                        "bin_project",
                        true
                    ),
                    // 导入工程
                    OperationItem(
                        R.drawable.twotone_unarchive_black_24,
                        R.string.project_import,
                        "project_import",
                        false
                    ),
                    OperationItem(
                        R.drawable.twotone_web_black_24,
                        R.string.project_recovery,
                        "project_recovery",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_build_black_24,
                        R.string.project_info,
                        "project_info",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_file_download_black_24,
                        R.string.import_resources,
                        "import_resources",
                        false
                    ),
                    OperationItem(
                        R.drawable.twotone_add_black_24,
                        R.string.create_project,
                        "create_project",
                        false
                    )
                )
            )
        )
        // 文件操作栏 file_op
        registerOpGroup(
            "file_op", OpGroupItem(
                R.string.file_operation,
                mutableListOf(
                    OperationItem(
                        R.drawable.twotone_insert_drive_file_black_24,
                        R.string.compile_lua_file,
                        "compile_lua_file",
                        false
                    )
                )
            )
        )
        // 工具操作栏 tools
        registerOpGroup(
            "tools", OpGroupItem(
                R.string.tools_text,
                mutableListOf(
                    OperationItem(
                        R.drawable.twotone_photo_library_black_24,
                        R.string.icon_depository,
                        "icon_depository",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_book_black_24,
                        R.string.lua_course,
                        "lua_course",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_menu_book_black_24,
                        R.string.lua_explain,
                        "lua_explain",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_menu_book_black_24,
                        R.string.java_api,
                        "java_api",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_color_lens_black_24,
                        R.string.argb_tool,
                        "argb_tool",
                        false
                    ),

                    OperationItem(
                        R.drawable.twotone_format_color_fill_black_24,
                        R.string.color_reference,
                        "color_reference",
                        true
                    ),
                    OperationItem(
                        R.drawable.twotone_image_black_24,
                        R.string.layout_helper,
                        "layout_helper",
                        true
                    ),
                    // 日志
                    OperationItem(
                        R.drawable.twotone_assessment_black_24,
                        R.string.logcat,
                        "logcat",
                        true
                    ),
                )
            )
        )

        // 其他操作栏 others
        registerOpGroup(
            "others", OpGroupItem(
                R.string.other,
                mutableListOf(
                    OperationItem(
                        R.drawable.twotone_groups_black_24,
                        R.string.help_roster,
                        "help_roster",
                        true
                    )
                )
            )
        )
    }

}