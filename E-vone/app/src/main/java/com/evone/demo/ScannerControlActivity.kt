package com.evone.demo

import android.content.Context
import android.graphics.drawable.AnimationDrawable
import android.hardware.camera2.CameraManager
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ImageView

import com.evone.sdk.Configuration
import com.evone.sdk.ScannerManager
import com.evone.sdk.ble.BeaconDevice
import com.evone.sdk.ble.BeaconListener

class ScannerControlActivity : AppCompatActivity() {
    companion object {
        private val TAG = ScannerControlActivity::class.java.simpleName
    }

    private lateinit var mConfiguration: Configuration
    private val mScannerManager = ScannerManager(this)
    private lateinit var mAlertWidget: ImageView
    private lateinit var mCameraManager: CameraManager

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(TAG, "onCreate")
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_scanner_control)

        mCameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        mAlertWidget = findViewById(R.id.ivPersonnage)
        mConfiguration = Configuration()
        mConfiguration.setBeaconListener(object : BeaconListener {
            override fun onBeaconDiscovered(beacon: BeaconDevice) {
                if (BuildConfig.DEBUG) Log.d(TAG, "onBeaconDiscovered: $beacon")
                alertOn()
            }

            override fun onBeaconLost(beacon: BeaconDevice) {
                if (BuildConfig.DEBUG) Log.d(TAG, "onBeaconLost: $beacon")
                alertOff()
            }
        })
    }

/*
    override fun onStart() {
        super.onStart()
    }
*/

    fun onClickSetUp(@Suppress("UNUSED_PARAMETER") v: View) {
        Log.d(TAG, "onClickSetUp")
        mScannerManager.setUp(mConfiguration)
    }

    fun onClickTearDown(@Suppress("UNUSED_PARAMETER") v: View) {
        Log.d(TAG, "onClickTearDown")
        mScannerManager.tearDown()
    }

    private fun alertOn() {
        mAlertWidget.setImageDrawable((getDrawable(R.drawable.blinker) as AnimationDrawable).apply { start() })
        //mCameraManager.setTorchMode("0", true)
    }

    private fun alertOff() {
        mAlertWidget.setImageResource(R.drawable.personnage_filaire_250x250_bleuclair)
        //mCameraManager.setTorchMode("0", false)
    }
}
