package com.example.appartmentapp.presentation.location

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.interop.UIKitView
import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.cinterop.readValue
import platform.CoreLocation.CLLocationCoordinate2DMake
import cocoapods.GoogleMaps.GMSCameraPosition
import cocoapods.GoogleMaps.GMSMapView
import cocoapods.GoogleMaps.GMSMarker

@OptIn(ExperimentalForeignApi::class)
@Composable
actual fun MapView(
    modifier: Modifier,
    initialLocation: LatLng?,
    onMapClick: (LatLng) -> Unit
) {
    val camera = GMSCameraPosition.cameraWithLatitude(
        initialLocation?.latitude ?: 0.0,
        initialLocation?.longitude ?: 0.0,
        15.0f
    )
    
    val mapView = remember { GMSMapView.mapWithFrame(platform.CoreGraphics.CGRectZero.readValue(), camera) }

    UIKitView(
        factory = {
            initialLocation?.let {
                val marker = GMSMarker.markerWithPosition(
                    CLLocationCoordinate2DMake(it.latitude, it.longitude)
                )
                marker.title = "Current Location"
                marker.setMap(mapView)
            }
            mapView
        },
        modifier = modifier
    )
}
