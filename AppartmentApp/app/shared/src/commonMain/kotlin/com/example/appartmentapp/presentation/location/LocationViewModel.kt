package com.example.appartmentapp.presentation.location

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class LocationViewModel(private val locationService: LocationService) : ViewModel() {
    private val _uiState = MutableStateFlow<LocationUiState>(LocationUiState.Loading)
    val uiState: StateFlow<LocationUiState> = _uiState.asStateFlow()

    init {
        getCurrentLocation()
    }

    fun getCurrentLocation() {
        viewModelScope.launch {
            _uiState.value = LocationUiState.Loading
            val location = locationService.getCurrentLocation()
            if (location != null) {
                _uiState.value = LocationUiState.Success(location)
            } else {
                _uiState.value = LocationUiState.Error("Could not fetch location")
            }
        }
    }
}

sealed class LocationUiState {
    object Loading : LocationUiState()
    data class Success(val location: LatLng) : LocationUiState()
    data class Error(val message: String) : LocationUiState()
}
