package com.evone.demo

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View

class MainActivity : AppCompatActivity() {
    companion object {
        private val TAG = MainActivity::class.java.simpleName
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(TAG, "onCreate")
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun onClickDemo(@Suppress("UNUSED_PARAMETER") v: View) {
        startActivity(Intent(this, ScannerDemoActivity::class.java))
    }

    fun onClickDev(@Suppress("UNUSED_PARAMETER") v: View) {
        startActivity(Intent(this, ScannerControlActivity::class.java))
    }
}
