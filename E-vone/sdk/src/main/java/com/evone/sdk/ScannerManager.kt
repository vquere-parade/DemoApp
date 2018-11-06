package com.evone.sdk

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import android.widget.TextView

import com.kontakt.sdk.android.ble.configuration.ScanPeriod
import com.kontakt.sdk.android.ble.device.BeaconRegion
import com.kontakt.sdk.android.ble.exception.ScanError
import com.kontakt.sdk.android.ble.manager.configuration.GeneralConfigurator
import com.kontakt.sdk.android.ble.manager.configuration.SpacesConfigurator
import com.kontakt.sdk.android.ble.manager.listeners.IBeaconListener
import com.kontakt.sdk.android.ble.manager.listeners.ScanStatusListener
import com.kontakt.sdk.android.ble.manager.listeners.SpaceListener
import com.kontakt.sdk.android.common.KontaktSDK
import com.kontakt.sdk.android.common.log.LogLevel
import com.kontakt.sdk.android.common.profile.IBeaconDevice
import com.kontakt.sdk.android.common.profile.IBeaconRegion
import com.kontakt.sdk.android.common.profile.IEddystoneNamespace
import java.util.*


class ScannerManager(context: Context) {
    companion object {
        private val TAG = ScannerManager::class.java.simpleName

        fun initialize(context: Context) {
            Log.i(TAG, "initialize")
            KontaktSDK.initialize(context)
                .setDebugLoggingEnabled(BuildConfig.DEBUG)
                .setLogLevelEnabled(LogLevel.VERBOSE, true)
                .setLogLevelEnabled(LogLevel.DEBUG, true)
                .setLogLevelEnabled(LogLevel.INFO, true)
                .setLogLevelEnabled(LogLevel.WARNING, true)
                .setLogLevelEnabled(LogLevel.ERROR, true)
        }
    }

    private val mContext: Context = context
    private lateinit var mService: ScannerService
    private var mBound: Boolean = false
    private lateinit var mConnection: ServiceConnection

    fun setUp(cfg: Configuration?/*txtLog: TextView*/) {
        if (BuildConfig.DEBUG) Log.d(TAG, "setUp")
        val serviceIntent = Intent(mContext, ScannerService::class.java)
        val cn: ComponentName? = mContext.startService(serviceIntent)
        //TODO tester cn
        connect(object : ServiceConnectionListener {
            override fun onServiceConnected() {
                cfg?.getBeaconListener()?.also { mService.setBeaconListener(it) }
                val sc: SpacesConfigurator = mService.getSpacesConfigurator()
                // tmp configure
                sc.iBeaconRegion(
                    BeaconRegion.Builder()
                        .identifier("e.vone")  // ne peut pas rester null
                        .proximity(UUID.fromString("dfe942fe-cfdf-4838-90c5-07dbcaa8f620"))
                        .build()
                )
                val gc: GeneralConfigurator = mService.getGeneralConfigurator()
                gc.monitoringEnabled(false).scanPeriod(ScanPeriod.RANGING)
                mService.setSpaceListener(object : SpaceListener {
                    override fun onRegionEntered(region: IBeaconRegion?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onRegionEntered: $region")
                    }

                    override fun onRegionAbandoned(region: IBeaconRegion?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onRegionAbandoned: $region")
                    }

                    override fun onNamespaceEntered(namespace: IEddystoneNamespace?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onNamespaceEntered: $namespace")
                    }

                    override fun onNamespaceAbandoned(namespace: IEddystoneNamespace?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onNamespaceAbandoned: $namespace")
                    }

                })
                mService.setScanStatusListener(object : ScanStatusListener {
                    override fun onScanStart() {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onScanStart")
                    }

                    override fun onScanStop() {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onScanStop")
                    }

                    override fun onScanError(scanError: ScanError?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onScanError ${scanError?.message}")
                    }

                    override fun onMonitoringCycleStart() {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onMonitoringCycleStart")
                    }

                    override fun onMonitoringCycleStop() {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onMonitoringCycleStop")
                    }
                })
/*
                mService.setIBeaconListener(object : IBeaconListener {
                    override fun onIBeaconDiscovered(iBeacon: IBeaconDevice?, region: IBeaconRegion?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onIBeaconDiscovered: $iBeacon, region: $region")
                        log("disc", iBeacon)
                    }

                    override fun onIBeaconLost(iBeacon: IBeaconDevice?, region: IBeaconRegion?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onIBeaconLost: $iBeacon, region: $region")
                        log("lost", iBeacon)
                    }

                    override fun onIBeaconsUpdated(iBeacons: MutableList<IBeaconDevice>?, region: IBeaconRegion?) {
                        if (BuildConfig.DEBUG) Log.d(TAG, "onIBeaconsUpdated: $iBeacons, region: $region")
                    }
                })
*/
                mService.connectProximityService(object : ServiceConnectionListener {
                    override fun onServiceConnected() {
                        if (mService.isScanning()) {
                            mService.restartScanning()
                        } else {
                            mService.startScanning()
                        }
                        disconnect()
                    }

                    override fun onBindFailure() {}
                })
            }

/*
            private fun log(type: String, iBeacon: IBeaconDevice?) {
                //txtLog.editableText.appendln(iBeacon.toString())
                //txtLog.text = txtLog.text.toString() + iBeacon + "\n"
                txtLog.text = "${txtLog.text.toString()}$type ${iBeacon?.address} rssi ${iBeacon?.rssi}\n   ${iBeacon?.proximityUUID} ${iBeacon?.major} ${iBeacon?.minor}\n"
            }
*/

            override fun onBindFailure() {
                Log.e(TAG, "Unable to bind the Scanner Service")
                throw RuntimeException("Incapable de se connecter au service d'écoute")
            }

        })
    }

    fun isConnected() = mBound

    private fun connect(listener: ServiceConnectionListener) {
        if (isConnected()) {
            Log.w(TAG, "connect requested while already connected")
            listener.onServiceConnected()
            return
        }
        mConnection = object : ServiceConnection {
            override fun onServiceConnected(className: ComponentName?, service: IBinder?) {
                mService = (service as ScannerService.LocalBinder).getService()
                mBound = true
                listener.onServiceConnected()
            }

            override fun onServiceDisconnected(className: ComponentName?) {
                mBound = false
            }
        }
        if (!mContext.bindService(Intent(mContext, ScannerService::class.java), mConnection, 0)) {
            mContext.unbindService(mConnection)
            listener.onBindFailure()
        }
    }

    private fun disconnect() {
        if (BuildConfig.DEBUG) Log.d(TAG, "disconnect")
        if (!isConnected()) {
            Log.w(TAG, "disconnect requested while not connected")
            return
        }
        mContext.unbindService(mConnection)
        mBound = false
        //mService = null
    }

    fun tearDown() {
        if (BuildConfig.DEBUG) Log.d(TAG, "tearDown")
        connect(object : ServiceConnectionListener {
            override fun onServiceConnected() {
                if (mService.isProximityServiceConnected()) {
                    mService.stopScanning()
                    mService.disconnectProximityService()
                }
                disconnect()
                if (!mContext.stopService(Intent(mContext, ScannerService::class.java))) {
                    Log.e(TAG, "Unable to stop the Scanner Service or already stopped")
                }
            }

            override fun onBindFailure() {
                if (BuildConfig.DEBUG) Log.w(TAG, "Scanner Service not started")
            }
        })
    }
}