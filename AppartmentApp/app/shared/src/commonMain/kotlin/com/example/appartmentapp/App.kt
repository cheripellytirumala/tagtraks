package com.example.appartmentapp

import androidx.compose.runtime.*
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.appartmentapp.di.AppContainer
import com.example.appartmentapp.presentation.dashboard.DashboardScreen
import com.example.appartmentapp.presentation.dashboard.DashboardViewModel
import com.example.appartmentapp.presentation.login.LoginScreen
import com.example.appartmentapp.presentation.login.LoginViewModel
import com.example.appartmentapp.presentation.signup.SignupScreen
import com.example.appartmentapp.presentation.signup.SignupViewModel
import com.example.appartmentapp.presentation.forgotpassword.ForgotPasswordScreen
import com.example.appartmentapp.presentation.forgotpassword.ForgotPasswordViewModel
import com.example.appartmentapp.presentation.location.LocationScreen
import com.example.appartmentapp.presentation.location.LocationViewModel
import com.example.appartmentapp.presentation.location.provideLocationService
import com.example.appartmentapp.presentation.NoBrokerTheme

enum class Screen {
    Login, Signup, Dashboard, ForgotPassword, Location
}

@Composable
fun App() {
    NoBrokerTheme {
        val appContainer = remember { AppContainer() }
        var currentScreen by remember { mutableStateOf(Screen.Login) }

        when (currentScreen) {
            Screen.Login -> {
                val loginViewModel: LoginViewModel = viewModel {
                    LoginViewModel(appContainer.loginUseCase)
                }
                LoginScreen(
                    viewModel = loginViewModel,
                    onNavigateToSignup = { currentScreen = Screen.Signup },
                    onNavigateToForgotPassword = { currentScreen = Screen.ForgotPassword },
                    onLoginSuccess = { currentScreen = Screen.Dashboard }
                )
            }
            Screen.Signup -> {
                val signupViewModel: SignupViewModel = viewModel {
                    SignupViewModel(appContainer.signupUseCase)
                }
                SignupScreen(
                    viewModel = signupViewModel,
                    onNavigateToLogin = { currentScreen = Screen.Login },
                    onSignupSuccess = { currentScreen = Screen.Dashboard }
                )
            }
            Screen.ForgotPassword -> {
                val forgotPasswordViewModel: ForgotPasswordViewModel = viewModel {
                    ForgotPasswordViewModel(
                        appContainer.forgotPasswordUseCase,
                        appContainer.verifyOtpUseCase,
                        appContainer.resetPasswordUseCase
                    )
                }
                ForgotPasswordScreen(
                    viewModel = forgotPasswordViewModel,
                    onNavigateBack = { currentScreen = Screen.Login },
                    onSuccess = { currentScreen = Screen.Login }
                )
            }
            Screen.Dashboard -> {
                val dashboardViewModel: DashboardViewModel = viewModel {
                    DashboardViewModel(
                        appContainer.getDashboardDataUseCase,
                        appContainer.logoutUseCase
                    )
                }
                DashboardScreen(
                    viewModel = dashboardViewModel,
                    onLogout = { currentScreen = Screen.Login },
                    onNavigateToLocation = { currentScreen = Screen.Location }
                )
            }
            Screen.Location -> {
                val locationViewModel: LocationViewModel = viewModel {
                    LocationViewModel(provideLocationService())
                }
                LocationScreen(
                    viewModel = locationViewModel,
                    onNavigateBack = { currentScreen = Screen.Dashboard }
                )
            }
        }
    }
}
