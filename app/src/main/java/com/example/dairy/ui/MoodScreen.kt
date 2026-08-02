package com.example.dairy.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dairy.R
import com.example.dairy.model.MoodEntry
import com.example.dairy.ui.theme.MDGlassBackground
import com.example.dairy.ui.theme.MDPrimary
import com.example.dairy.ui.theme.MDSurfaceContainer

@Composable
fun MoodScreen(
    entries: List<MoodEntry>,
    onEditClick: (MoodEntry) -> Unit,
    onDeleteClick: (MoodEntry) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 20.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp),
        contentPadding = PaddingValues(bottom = 32.dp)
    ) {
        items(entries) { entry ->
            val iconInfo = when (entry.moodId) {
                "super" -> Icons.Default.SentimentVerySatisfied
                "good" -> Icons.Default.SentimentSatisfied
                "neutral" -> Icons.Default.Mood
                "bad" -> Icons.Default.SentimentDissatisfied
                "awful" -> Icons.Default.SentimentVeryDissatisfied
                else -> Icons.Default.Mood
            }
            
            MoodEntryCard(
                mood = entry.moodTitle,
                time = "${entry.date}, ${entry.time}",
                description = entry.note,
                activities = entry.activities,
                icon = iconInfo,
                iconColor = MaterialTheme.colorScheme.secondaryContainer,
                onEdit = { onEditClick(entry) },
                onDelete = { onDeleteClick(entry) }
            )
        }
    }
}

@Composable
fun MoodEntryCard(
    mood: String,
    time: String,
    description: String,
    activities: List<String>,
    icon: ImageVector,
    iconColor: Color,
    onEdit: () -> Unit,
    onDelete: () -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(24.dp),
        modifier = Modifier.border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
    ) {
        Row(
            modifier = Modifier
                .padding(20.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.Top,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Surface(
                modifier = Modifier.size(48.dp),
                color = iconColor,
                shape = CircleShape
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        imageVector = icon,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSecondaryContainer,
                        modifier = Modifier.size(28.dp)
                    )
                }
            }

            Column(modifier = Modifier.weight(1f)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = mood,
                        style = MaterialTheme.typography.headlineSmall,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.secondary
                    )
                    Text(
                        text = time,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
                
                Spacer(modifier = Modifier.height(4.dp))
                
                if (description.isNotEmpty()) {
                    Text(
                        text = description,
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                }

                if (activities.isNotEmpty()) {
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        activities.forEach { activity ->
                            val activityIcon = getActivityIcon(activity)
                            Icon(
                                imageVector = activityIcon,
                                contentDescription = activity,
                                tint = MDPrimary,
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }
            }

            Box {
                IconButton(onClick = { expanded = true }) {
                    Icon(
                        imageVector = Icons.Default.MoreHoriz,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                DropdownMenu(
                    expanded = expanded,
                    onDismissRequest = { expanded = false },
                    modifier = Modifier
                        .background(MDSurfaceContainer)
                        .border(
                            width = 1.dp,
                            color = Color.White.copy(alpha = 0.1f),
                            shape = RoundedCornerShape(16.dp)
                        ),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    DropdownMenuItem(
                        text = { 
                            Text(
                                text = stringResource(R.string.action_edit), 
                                style = MaterialTheme.typography.labelLarge,
                                color = Color.White
                            ) 
                        },
                        leadingIcon = {
                            Icon(
                                imageVector = Icons.Default.Edit,
                                contentDescription = null,
                                tint = MDPrimary,
                                modifier = Modifier.size(20.dp)
                            )
                        },
                        onClick = {
                            expanded = false
                            onEdit()
                        }
                    )
                    DropdownMenuItem(
                        text = { 
                            Text(
                                text = stringResource(R.string.action_delete), 
                                style = MaterialTheme.typography.labelLarge,
                                color = MaterialTheme.colorScheme.error
                            ) 
                        },
                        leadingIcon = {
                            Icon(
                                imageVector = Icons.Default.Delete,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.error,
                                modifier = Modifier.size(20.dp)
                            )
                        },
                        onClick = {
                            expanded = false
                            onDelete()
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun getActivityIcon(activity: String): ImageVector {
    return when (activity) {
        stringResource(R.string.act_family) -> Icons.Default.FamilyRestroom
        stringResource(R.string.act_friends) -> Icons.Default.Group
        stringResource(R.string.act_date) -> Icons.Default.Favorite
        stringResource(R.string.act_sport) -> Icons.Default.FitnessCenter
        stringResource(R.string.act_work) -> Icons.Default.Work
        stringResource(R.string.act_movie) -> Icons.Default.Movie
        stringResource(R.string.act_shop) -> Icons.Default.ShoppingBasket
        else -> Icons.Default.MoreHoriz
    }
}
