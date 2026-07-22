package com.example.appartmentapp.presentation.location

import android.annotation.SuppressLint
import android.content.Context
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import kotlinx.coroutines.tasks.await

class AndroidLocationService(private val context: Context) : LocationService {
    private val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)

    @SuppressLint("MissingPermission")
    override suspend fun getCurrentLocation(): LatLng? {
        return try {
            val location = fusedLocationClient.getCurrentLocation(
                Priority.PRIORITY_HIGH_ACCURACY,
                null
            ).await()
            location?.let { LatLng(it.latitude, it.longitude) }
        } catch (e: Exception) {
            null
        }
    }
}

// In a real app, use a proper DI framework or a better way to provide context.
private var _context: Context? = null
var androidContext: Context
    get() = _context ?: throw IllegalStateException("Context not initialized")
    set(value) { _context = value }

actual fun provideLocationService(): LocationService = AndroidLocationService(androidContext)
