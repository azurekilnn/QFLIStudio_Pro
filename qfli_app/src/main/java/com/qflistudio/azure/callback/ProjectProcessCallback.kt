interface ProjectProcessCallback {
    fun onComplete(result: String)

    fun onError(exception: Exception)
}
