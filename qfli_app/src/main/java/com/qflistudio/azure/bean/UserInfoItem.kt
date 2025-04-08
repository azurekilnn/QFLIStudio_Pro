package com.qflistudio.azure.bean

data class UserInfoItem(
    val uid: String,
    val nickname: String,
    val role: String,
    val photo: String,
    val email: String,
    val description: String,
    val ip: String,
    val create_time: String,
)