package com.example.appartmentapp.presentation.location

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng as AndroidLatLng
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.Marker
import com.google.maps.android.compose.MarkerState
import com.google.maps.android.compose.rememberCameraPositionState

@Composable
actual fun MapView(
    modifier: Modifier,
    initialLocation: LatLng?,
    onMapClick: (LatLng) -> Unit
) {
    val cameraPositionState = rememberCameraPositionState {
        position = CameraPosition.fromLatLngZoom(
            AndroidLatLng(initialLocation?.latitude ?: 0.0, initialLocation?.longitude ?: 0.0),
            15f
        )
    }

    GoogleMap(
        modifier = modifier,
        cameraPositionState = cameraPositionState,
        onMapClick = {
            onMapClick(LatLng(it.latitude, it.longitude))
        }
    ) {
        initialLocation?.let {
            Marker(
                state = MarkerState(position = AndroidLatLng(it.latitude, it.longitude)),
                title = "Current Location"
            )
        }
    }
}
