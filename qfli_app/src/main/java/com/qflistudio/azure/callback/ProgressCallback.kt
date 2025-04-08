interface ProgressCallback {
    fun onProgressUpdate(
        progress: Int,
        fileName: String,
        speed: String,
        sourceFolder: String,
        destinationFolder: String
    )

    fun onComplete()

    fun onError(exception: Exception)
}
