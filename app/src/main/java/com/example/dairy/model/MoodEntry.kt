package com.example.dairy.model

import androidx.compose.ui.graphics.vector.ImageVector

data class MoodEntry(
    val id: String,
    val moodTitle: String,
    val moodId: String, // super, good, neutral, bad, awful
    val date: String,
    val time: String,
    val note: String,
    val activities: List<String>
)
