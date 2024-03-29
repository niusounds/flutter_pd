package com.niusounds.flutter_pd

/**
 * Interface from Dart to native method calls.
 */
interface DartToNative {
    fun checkPermission(callback: (Boolean) -> Unit)

    fun startPd(callback: () -> Unit)

    fun stopPd()

    fun openAsset(assetName: String): Int

    fun close(patchHandle: Int)

    fun startAudio(requireInput: Boolean)

    fun send(receiver: String, value: Float)

    fun sendBang(receiver: String)

    fun onListen(symbol: String, id: Int, callback: (Any) -> Unit)

    fun onCancel(symbol: String, id: Int)
}