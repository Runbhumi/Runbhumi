package com.example.Runbhumi

import android.util.Log
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin


class FirebaseCloudMessagingPluginRegistrant {
    companion object {
        fun registerWith(registry: PluginRegistry) {
            Log.d("FirebaseCloudMessaging", "registerWith");
            if (alreadyRegisteredWith(registry)) {
                Log.d("Already Registered","");
                return
            }
            try {
                FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
            } catch (e: Exception) {
                Log.d("FirebaseCloudMessaging", e.toString());
            }

            Log.d("Plugin Registered","");
        }

        private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
            val key = FirebaseCloudMessagingPluginRegistrant::class.java.canonicalName
            if (registry.hasPlugin(key)) {
                return true
            }
            registry.registrarFor(key)
            return false
        }
    }
}