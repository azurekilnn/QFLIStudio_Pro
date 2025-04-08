package com.qflistudio.azure.bean

data class ContentResponse(
    val code: Int,
    val state: String,
    val results: List<CloudSourceItem>,
    val time_stamp: Long
)