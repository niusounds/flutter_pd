package com.niusounds.flutter_pd

import com.niusounds.flutter_pd.impl.PdImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** FlutterPdPlugin */
class FlutterPdPlugin : FlutterPlugin, ActivityAware {
    private var flutterPd: FlutterPd? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val flutterPd = FlutterPd(
            flutterPluginBinding,
            pd = PdImpl(flutterPluginBinding.applicationContext)
        )
        // Setup messaging path:
        // MethodChannel & EventChannel -> DartCallHandler -> FlutterPd
        DartCallHandler(flutterPd).also {
            MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pd/method")
                .setMethodCallHandler(it)
            EventChannel(flutterPluginBinding.binaryMessenger, "flutter_pd/event")
                .setStreamHandler(it)
        }
        this.flutterPd = flutterPd
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterPd?.dispose()
        flutterPd = null
    }

    override fun onDetachedFromActivity() {
        flutterPd?.activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        flutterPd?.activityBinding = binding
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterPd?.activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        flutterPd?.activityBinding = null
    }
}
