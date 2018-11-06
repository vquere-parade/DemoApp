package com.evone.sdk

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.util.Log
import com.evone.sdk.ble.BeaconDevice
import com.evone.sdk.ble.BeaconListener

import com.kontakt.sdk.android.ble.manager.ProximityManager
import com.kontakt.sdk.android.ble.manager.ProximityManagerFactory
import com.kontakt.sdk.android.ble.manager.configuration.GeneralConfigurator
import com.kontakt.sdk.android.ble.manager.configuration.SpacesConfigurator
import com.kontakt.sdk.android.ble.manager.listeners.IBeaconListener
import com.kontakt.sdk.android.ble.manager.listeners.ScanStatusListener
import com.kontakt.sdk.android.ble.manager.listeners.SpaceListener
import com.kontakt.sdk.android.ble.manager.listeners.simple.SimpleIBeaconListener
import com.kontakt.sdk.android.common.profile.IBeaconDevice
import com.kontakt.sdk.android.common.profile.IBeaconRegion

class ScannerService : Service() {
    companion object {
        private val TAG = ScannerService::class.java.simpleName
    }

    private lateinit var mProximityManager: ProximityManager
    private var mIsAlreadyRunning: Boolean = false
    private val mBinder = LocalBinder()

    override fun onCreate() {
        if (BuildConfig.DEBUG) Log.d(TAG, "onCreate")
        super.onCreate()
        mIsAlreadyRunning = false
        mProximityManager = ProximityManagerFactory.create(this)
    }

    override fun onDestroy() {
        if (BuildConfig.DEBUG) Log.d(TAG, "onDestroy")
        if (mProximityManager.isConnected) mProximityManager.disconnect()
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (BuildConfig.DEBUG) Log.d(TAG, "onStartCommand: $intent")
        if (!mIsAlreadyRunning) mIsAlreadyRunning = true
        else Log.w(TAG, "Service already started")
        return START_STICKY
    }

    inner class LocalBinder : Binder() {
        fun getService(): ScannerService = this@ScannerService
    }

    override fun onBind(intent: Intent): IBinder = mBinder

    //

    fun getGeneralConfigurator(): GeneralConfigurator = mProximityManager.configuration()
    fun getSpacesConfigurator(): SpacesConfigurator = mProximityManager.spaces()

    fun setSpaceListener(listener: SpaceListener?) = mProximityManager.setSpaceListener(listener)
    fun setScanStatusListener(listener: ScanStatusListener?) = mProximityManager.setScanStatusListener(listener)
    fun setBeaconListener(listener: BeaconListener) =
        mProximityManager.setIBeaconListener(object : SimpleIBeaconListener() {
            override fun onIBeaconDiscovered(iBeacon: IBeaconDevice?, region: IBeaconRegion?) {
                if (BuildConfig.DEBUG) Log.d(TAG, "onIBeaconDiscovered: $iBeacon, region: $region")
                listener.onBeaconDiscovered(BeaconDevice(iBeacon!!.proximityUUID, iBeacon.major, iBeacon.minor))
            }

            override fun onIBeaconLost(iBeacon: IBeaconDevice?, region: IBeaconRegion?) {
                if (BuildConfig.DEBUG) Log.d(TAG, "onIBeaconLost: $iBeacon, region: $region")
                listener.onBeaconLost(BeaconDevice(iBeacon!!.proximityUUID, iBeacon.major, iBeacon.minor))
            }
        })

    fun isProximityServiceConnected() = mProximityManager.isConnected

    fun connectProximityService(listener: ServiceConnectionListener) {
        if (BuildConfig.DEBUG) Log.d(TAG, "connectProximityService")
        if (!mProximityManager.isConnected) {
            mProximityManager.connect { listener.onServiceConnected() }
        } else {
            Log.w(TAG, "connect requested while already connected")
            listener.onServiceConnected()
        }
    }

    fun disconnectProximityService() {
        if (BuildConfig.DEBUG) Log.d(TAG, "disconnectProximityService")
        if (mProximityManager.isConnected) {
            mProximityManager.disconnect()
        } else {
            Log.w(TAG, "disconnect requested while not connected")
        }
    }

    fun isScanning() = mProximityManager.isScanning
    fun startScanning() = mProximityManager.startScanning()
    fun stopScanning() = mProximityManager.stopScanning()
    fun restartScanning() = mProximityManager.restartScanning()
}
