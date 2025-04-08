package com.qflistudio.azure.bean

import ProjectItem

data class HistoryProjectItem(
    var projectItem: ProjectItem,
    var lastOpenedTime: Long? = null
)