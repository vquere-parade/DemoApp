package com.evone.sdk

interface ServiceConnectionListener {
    fun onServiceConnected()
    fun onBindFailure()
}