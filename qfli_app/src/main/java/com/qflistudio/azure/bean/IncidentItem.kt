package com.qflistudio.azure.bean


data class IncidentItem(
    val functionKey: String,
    val function: () -> Unit,
)