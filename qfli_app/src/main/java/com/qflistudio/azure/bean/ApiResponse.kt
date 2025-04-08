package com.qflistudio.azure.bean

data class ApiResponse(
    val code: Int,
    val state: String,
    val results: List<Map<String, Any>>,
    val time_stamp: Long
)