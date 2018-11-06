package com.evone.sdk

import com.evone.sdk.ble.BeaconListener


class Configuration {
    private var mBeaconListener: BeaconListener? = null

    fun getBeaconListener() = mBeaconListener
    fun setBeaconListener(listener: BeaconListener): Configuration = this.apply { mBeaconListener = listener }
}