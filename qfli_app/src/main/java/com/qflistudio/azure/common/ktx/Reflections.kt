package com.qflistudio.azure.common.ktx

inline fun <reified T> getJavaClass(): Class<T> {
    return T::class.java
}
