package com.example.dairy

import android.os.Bundle
import android.os.StrictMode
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import com.example.dairy.model.MoodEntry
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
                var editingEntry by remember { mutableStateOf<MoodEntry?>(null) }
                
                val moodEntries = remember { 
                    mutableStateListOf(
                        MoodEntry(
                            id = "1",
                            moodTitle = "Neutral",
                            moodId = "neutral",
                            date = "August 2",
                            time = "16:58",
                            note = "The day went calmly, but I feel a bit tired.",
                            activities = emptyList()
                        ),
                        MoodEntry(
                            id = "2",
                            moodTitle = "Good",
                            moodId = "good",
                            date = "August 1",
                            time = "14:20",
                            note = "Spent some time reading a book. Felt very peaceful.",
                            activities = emptyList()
                        )
                    )
                }

                when (currentScreen) {
                    "onboarding" -> {
                        OnboardingScreen(onGetStartedClick = { currentScreen = "dashboard" })
                    }
                    "dashboard" -> {
                        DashboardScreen(
                            onAddClick = { 
                                editingEntry = null
                                currentScreen = "add_entry" 
                            },
                            entries = moodEntries,
                            onEditClick = { entry ->
                                editingEntry = entry
                                currentScreen = "add_entry"
                            },
                            onDeleteClick = { entry ->
                                moodEntries.remove(entry)
                            }
                        )
                    }
                    "add_entry" -> {
                        AddEntryScreen(
                            initialEntry = editingEntry,
                            onBackClick = { currentScreen = "dashboard" },
                            onSaveEntry = { entry ->
                                if (editingEntry != null) {
                                    // Update existing entry
                                    val index = moodEntries.indexOfFirst { it.id == entry.id }
                                    if (index != -1) {
                                        moodEntries[index] = entry
                                    }
                                } else {
                                    // Add new entry
                                    moodEntries.add(0, entry)
                                }
                                currentScreen = "dashboard"
                                editingEntry = null
                            }
                        )
                    }
                }
            }
        }
    }
}
