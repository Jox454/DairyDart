package com.example.dairy

import android.os.Bundle
import android.os.StrictMode
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import com.example.dairy.ui.AddEntryScreen
import com.example.dairy.ui.DashboardScreen
import com.example.dairy.ui.OnboardingScreen
import com.example.dairy.ui.theme.DairyTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Android 17 Migration: Enable StrictMode to detect non-SDK API usage
        if (android.os.Build.VERSION.SDK_INT >= 37) {
            StrictMode.setVmPolicy(
                StrictMode.VmPolicy.Builder()
                    .detectNonSdkApiUsage()
                    .penaltyLog()
                    .build()
            )
        }

        enableEdgeToEdge()
        setContent {
            DairyTheme(dynamicColor = false) {
                var currentScreen by rememberSaveable { mutableStateOf("onboarding") }

                when (currentScreen) {
                    "onboarding" -> {
                        OnboardingScreen(onGetStartedClick = { currentScreen = "dashboard" })
                    }
                    "dashboard" -> {
                        DashboardScreen(onAddClick = { currentScreen = "add_entry" })
                    }
                    "add_entry" -> {
                        AddEntryScreen(onBackClick = { currentScreen = "dashboard" })
                    }
                }
            }
        }
    }
}
