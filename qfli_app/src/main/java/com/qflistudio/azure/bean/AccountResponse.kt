package com.qflistudio.azure.bean

data class AccountResponse(
    val code: Int,
    val state: String,
    val message: String,
    val results: List<Map<String, Any>>,
    val userinfo: UserInfoItem,
    val time_stamp: Long
)