package com.evone.demo

import android.app.Application
import com.evone.sdk.ScannerManager

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        (ScannerManager.Companion::initialize)(this)
    }
}