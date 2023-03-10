package com.informed.better_informed_mobile

import android.content.Context;

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;

import com.ryanheise.audioservice.AudioServicePlugin

class MainActivity : FlutterActivity() {
    override fun provideFlutterEngine(context: Context): FlutterEngine {
        return AudioServicePlugin.getFlutterEngine(context)
            .apply { registerAppPlugin(this) }
    }

    private fun registerAppPlugin(engine: FlutterEngine) = engine.plugins.add(InformedAppPlugin())
}
