package com.example.appartmentapp.presentation.location

data class LatLng(val latitude: Double, val longitude: Double)

interface LocationService {
    suspend fun getCurrentLocation(): LatLng?
}

expect fun provideLocationService(): LocationService
