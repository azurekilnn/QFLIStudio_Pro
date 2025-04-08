package com.qflistudio.azure.bean

data class SourceResponse(
    val code: Int,
    val state: String,
    val results: CloudSourceItem,
    val time_stamp: Long
)