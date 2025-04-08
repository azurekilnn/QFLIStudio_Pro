package com.qflistudio.azure.bean

data class CloudSourceItem(
    var sid: Int,
    var source_name: String,
    var description: String,
    var update_log: String,
    var version_name: String,
    var version_code: Int,
    var author_uids: String,
    var download_link: String,
    var photos: String,
    var comments: String,
    var likes: Int,
    var likes_users: String,
    var history: String,
    var state: String,
    var update_time: Int,
    var create_time: Int,
    var icon: String,
)