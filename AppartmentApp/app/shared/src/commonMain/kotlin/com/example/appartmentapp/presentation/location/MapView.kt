package com.example.appartmentapp.presentation.location

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
expect fun MapView(
    modifier: Modifier,
    initialLocation: LatLng?,
    onMapClick: (LatLng) -> Unit = {}
)
