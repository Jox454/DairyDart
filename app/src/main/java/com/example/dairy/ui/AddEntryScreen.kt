package com.example.dairy.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dairy.R
import com.example.dairy.ui.theme.MDBackground
import com.example.dairy.ui.theme.MDGlassBackground
import com.example.dairy.ui.theme.MDPrimary

@Composable
fun AddEntryScreen(onBackClick: () -> Unit) {
    var noteText by remember { mutableStateOf("") }
    var selectedMood by remember { mutableStateOf<String?>(null) }
    val selectedActivities = remember { mutableStateListOf<String>() }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MDBackground)
    ) {
        // Decorative background elements
        Box(
            modifier = Modifier
                .align(Alignment.CenterEnd)
                .offset(x = 100.dp)
                .size(300.dp)
                .blur(100.dp)
                .background(MDPrimary.copy(alpha = 0.05f), CircleShape)
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
        ) {
            // Header
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(64.dp)
                    .padding(horizontal = 16.dp),
                contentAlignment = Alignment.CenterStart
            ) {
                IconButton(onClick = onBackClick) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Back",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 20.dp),
                verticalArrangement = Arrangement.spacedBy(32.dp)
            ) {
                // Mood Section
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(16.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = stringResource(R.string.add_entry_title),
                        style = MaterialTheme.typography.headlineMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                        fontWeight = FontWeight.Bold
                    )
                    MoodSelector(
                        selectedMood = selectedMood,
                        onMoodSelect = { selectedMood = it }
                    )
                }

                // Activities Section
                Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                    Text(
                        text = stringResource(R.string.section_activities),
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontWeight = FontWeight.Bold
                    )
                    ActivitiesGrid(
                        selectedActivities = selectedActivities,
                        onActivityToggle = { activity ->
                            if (selectedActivities.contains(activity)) {
                                selectedActivities.remove(activity)
                            } else {
                                selectedActivities.add(activity)
                            }
                        }
                    )
                }

                // Note Section
                Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                    Text(
                        text = stringResource(R.string.section_note),
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontWeight = FontWeight.Bold
                    )
                    NoteField(text = noteText, onValueChange = { noteText = it })
                }

                // Photo Section
                Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                    Text(
                        text = stringResource(R.string.section_photo),
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontWeight = FontWeight.Bold
                    )
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        PhotoActionButton(
                            icon = Icons.Default.PhotoCamera,
                            label = stringResource(R.string.btn_take_photo),
                            modifier = Modifier.weight(1f)
                        )
                        PhotoActionButton(
                            icon = Icons.Default.Image,
                            label = stringResource(R.string.btn_from_gallery),
                            modifier = Modifier.weight(1f)
                        )
                    }
                }
                
                Spacer(modifier = Modifier.weight(1f))

                // Save Button
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 32.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.clickable { /* Handle Save */ }
                    ) {
                        Surface(
                            modifier = Modifier.size(64.dp),
                            color = MDPrimary,
                            shape = CircleShape,
                            shadowElevation = 8.dp
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Icon(
                                    imageVector = Icons.Default.Check,
                                    contentDescription = "Save",
                                    tint = Color.Black,
                                    modifier = Modifier.size(32.dp)
                                )
                            }
                        }
                        Text(
                            text = stringResource(R.string.btn_save),
                            style = MaterialTheme.typography.labelMedium,
                            color = MDPrimary,
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 2.sp
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun MoodSelector(selectedMood: String?, onMoodSelect: (String) -> Unit) {
    val moods = listOf(
        Triple(stringResource(R.string.mood_super), Icons.Default.SentimentVerySatisfied, "super"),
        Triple(stringResource(R.string.mood_good), Icons.Default.SentimentSatisfied, "good"),
        Triple(stringResource(R.string.mood_neutral), Icons.Default.SentimentNeutral, "neutral"),
        Triple(stringResource(R.string.mood_bad), Icons.Default.SentimentDissatisfied, "bad"),
        Triple(stringResource(R.string.mood_awful), Icons.Default.SentimentVeryDissatisfied, "awful")
    )

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        moods.forEach { (label, icon, id) ->
            val isSelected = selectedMood == id
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.clickable { onMoodSelect(id) }
            ) {
                Surface(
                    modifier = Modifier.size(48.dp),
                    color = if (isSelected) MDPrimary else MDGlassBackground,
                    shape = CircleShape,
                    border = if (isSelected) null else BorderStroke(1.dp, Color.White.copy(alpha = 0.05f))
                ) {
                    Box(contentAlignment = Alignment.Center) {
                        Icon(
                            imageVector = icon,
                            contentDescription = label,
                            tint = if (isSelected) Color.Black else MDPrimary,
                            modifier = Modifier.size(28.dp)
                        )
                    }
                }
                Text(
                    text = label,
                    style = MaterialTheme.typography.labelSmall,
                    color = if (isSelected) MDPrimary else MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
fun ActivitiesGrid(selectedActivities: List<String>, onActivityToggle: (String) -> Unit) {
    val activities = listOf(
        Pair(stringResource(R.string.act_family), Icons.Default.FamilyRestroom),
        Pair(stringResource(R.string.act_friends), Icons.Default.Group),
        Pair(stringResource(R.string.act_date), Icons.Default.Favorite),
        Pair(stringResource(R.string.act_sport), Icons.Default.FitnessCenter),
        Pair(stringResource(R.string.act_work), Icons.Default.Work),
        Pair(stringResource(R.string.act_movie), Icons.Default.Movie),
        Pair(stringResource(R.string.act_shop), Icons.Default.ShoppingBasket),
        Pair(stringResource(R.string.act_other), Icons.Default.MoreHoriz)
    )

    Box(modifier = Modifier.height(180.dp)) {
        LazyVerticalGrid(
            columns = GridCells.Fixed(4),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
            modifier = Modifier.fillMaxSize()
        ) {
            items(activities) { (label, icon) ->
                val isSelected = selectedActivities.contains(label)
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.clickable { onActivityToggle(label) }
                ) {
                    Surface(
                        modifier = Modifier.size(48.dp),
                        color = if (isSelected) MDPrimary.copy(alpha = 0.2f) else MDGlassBackground,
                        shape = RoundedCornerShape(12.dp),
                        border = BorderStroke(
                            1.dp, 
                            if (isSelected) MDPrimary else Color.White.copy(alpha = 0.05f)
                        )
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            Icon(
                                imageVector = icon,
                                contentDescription = label,
                                tint = if (isSelected) MDPrimary else MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.size(24.dp)
                            )
                        }
                    }
                    Text(
                        text = label,
                        style = MaterialTheme.typography.labelSmall,
                        color = if (isSelected) MDPrimary else MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 1,
                        fontSize = 10.sp
                    )
                }
            }
        }
    }
}

@Composable
fun NoteField(text: String, onValueChange: (String) -> Unit) {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(16.dp),
        modifier = Modifier
            .fillMaxWidth()
            .border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(16.dp))
    ) {
        TextField(
            value = text,
            onValueChange = onValueChange,
            placeholder = { 
                Text(
                    text = stringResource(R.string.note_placeholder),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.outline
                ) 
            },
            modifier = Modifier.fillMaxWidth(),
            colors = TextFieldDefaults.colors(
                focusedContainerColor = Color.Transparent,
                unfocusedContainerColor = Color.Transparent,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                cursorColor = MDPrimary,
                focusedTextColor = MaterialTheme.colorScheme.onSurface,
                unfocusedTextColor = MaterialTheme.colorScheme.onSurface
            ),
            textStyle = MaterialTheme.typography.bodyMedium,
            minLines = 3
        )
    }
}

@Composable
fun PhotoActionButton(icon: ImageVector, label: String, modifier: Modifier = Modifier) {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(12.dp),
        modifier = modifier
            .height(48.dp)
            .border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(12.dp))
            .clickable { }
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center,
            modifier = Modifier.padding(horizontal = 12.dp)
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(20.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(
                text = label,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurface
            )
        }
    }
}
