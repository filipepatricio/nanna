package com.informed.better_informed_mobile

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.lang.ref.WeakReference

class InformedAppPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: WeakReference<Context>

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = WeakReference(binding.applicationContext)

        channel = MethodChannel(binding.binaryMessenger, "so.informed.internal")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        applicationContext.clear()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "manageSubscription" -> manageSubscription(call.arguments, result)
        }
    }

    private fun manageSubscription(args: Any, result: MethodChannel.Result) {
        val context = applicationContext.get()
        if (context == null) {
            result.error(
                "manageSubscription",
                "Context was null",
                null
            )
            return
        }

        val sku = (args as Map<*, *>?)?.get("sku") as String?
        val uri = if (sku == null) {
            Uri.parse("https://play.google.com/store/account/subscriptions")
        } else {
            Uri.parse("https://play.google.com/store/account/subscriptions?sku=$sku&package=${context.packageName}")
        }

        try {
            context.startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    uri
                ).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
            )

            result.success(null)
        } catch (e: ActivityNotFoundException) {
            result.error(
                "manageSubscription",
                e.localizedMessage,
                e.stackTrace.contentToString()
            )
        }
    }
}
