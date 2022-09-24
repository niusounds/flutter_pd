package com.niusounds.flutter_pd.exception

class PdException(
    val code: String,
    message: String?,
    val detail: Any? = null,
) : Exception(message)
