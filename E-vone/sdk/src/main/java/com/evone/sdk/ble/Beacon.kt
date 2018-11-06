package com.evone.sdk.ble

import java.util.UUID

class BeaconDevice(uuid: UUID, major: Int, minor: Int) {
    private var mUuid: UUID = uuid
    private var mMajor: Int = major
    private var mMinor: Int = minor

    override fun toString() = "BeaconDevice(uuid='$mUuid', major=$mMajor, minor=$mMinor)"
}

/*
class BeaconRegion(uuid: UUID, major: Int, minor: Int) {
    private var mUuid: UUID = uuid
    private var mMajor: Int = major
    private var mMinor: Int = minor
}
*/

interface BeaconListener {
    fun onBeaconDiscovered(beacon: BeaconDevice)
    fun onBeaconLost(beacon: BeaconDevice)
}