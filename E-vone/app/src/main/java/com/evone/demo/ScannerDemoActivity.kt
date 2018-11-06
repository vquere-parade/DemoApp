package com.evone.demo

import android.content.Context
import android.graphics.drawable.AnimationDrawable
import android.hardware.camera2.CameraManager
import android.media.AudioAttributes
import android.os.Build
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import android.widget.ImageView

import com.evone.sdk.Configuration
import com.evone.sdk.ScannerManager
import com.evone.sdk.ble.BeaconDevice
import com.evone.sdk.ble.BeaconListener

import kotlinx.coroutines.experimental.*

import kotlin.coroutines.experimental.CoroutineContext

class ScannerDemoActivity : CoroutineScope, AppCompatActivity() {
    companion object {
        private val TAG = ScannerDemoActivity::class.java.simpleName
    }

    private lateinit var mConfiguration: Configuration
    private val mScannerManager = ScannerManager(this)
    private lateinit var mAlertWidget: ImageView
    private lateinit var mCameraManager: CameraManager
    private lateinit var mVibrator: Vibrator
    private var mAlertJob: Job? = null

    // https://github.com/Kotlin/kotlinx.coroutines/blob/master/docs/coroutine-context-and-dispatchers.md#cancellation-via-explicit-job
    private lateinit var mLifecycleJob: Job
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Default + mLifecycleJob

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(TAG, "onCreate")
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_scanner_demo)

        mCameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        mVibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        mAlertWidget = findViewById(R.id.ivPersonnage)
        mConfiguration = Configuration()
            .setBeaconListener(object : BeaconListener {
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

    override fun onStart() {
        Log.d(TAG, "onStart")
        super.onStart()
        mLifecycleJob = Job()
        mScannerManager.setUp(mConfiguration)
//        alertOn()
    }

    override fun onStop() {
        Log.d(TAG, "onStop")
        mScannerManager.tearDown()
//        alertOff()
        mLifecycleJob.cancel()
        super.onStop()
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy")
        super.onDestroy()
    }

    private fun alertOn() {
        mAlertWidget.setImageDrawable((getDrawable(R.drawable.blinker) as AnimationDrawable).apply { start() })
        mAlertJob = launch {
            torchBlinker()
        }
        val timings = longArrayOf(900, 100)  // repos, actif
        val repeat = 0
        val attributes = AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            mVibrator.vibrate(VibrationEffect.createWaveform(timings, repeat), attributes)
        } else {
            mVibrator.vibrate(timings, repeat, attributes)
        }
    }

    private fun alertOff() {
        mAlertWidget.setImageResource(R.drawable.personnage_filaire_250x250_bleuclair)
        mAlertJob?.cancel()
        mVibrator.cancel()
    }

    private fun <T : Any> cycle(vararg items: T): Sequence<T> = generateSequence { items.toList() }.flatten()

    private suspend fun torchBlinker() {
        var enabled = false  // mémoriser soi-même car pas de moyen pour lire l'état de la torch
        mCameraManager.setTorchMode("0", enabled)
        try {
            cycle(50, 150, 50, 150 + 350, 50, 150, 50, 150 + 1000).forEach {
                enabled = !enabled
                mCameraManager.setTorchMode("0", enabled)
                delay(it.toLong())
            }
        } finally {
            mCameraManager.setTorchMode("0", false)
        }
    }
}
