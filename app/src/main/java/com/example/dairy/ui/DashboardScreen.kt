package com.example.dairy.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.dairy.R
import com.example.dairy.model.MoodEntry
import com.example.dairy.ui.theme.MDBackground
import com.example.dairy.ui.theme.MDPrimary
import com.example.dairy.ui.theme.MDSurfaceContainer

@Composable
fun DashboardScreen(
    onAddClick: () -> Unit, 
    entries: List<MoodEntry>,
    onEditClick: (MoodEntry) -> Unit,
    onDeleteClick: (MoodEntry) -> Unit
) {
    var currentTab by rememberSaveable { mutableStateOf("mood") }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MDBackground)
    ) {
        // Background Gradients
        Box(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .offset(x = 100.dp, y = (-50).dp)
                .size(300.dp)
                .blur(120.dp)
                .background(MDPrimary.copy(alpha = 0.1f), CircleShape)
        )
        Box(
            modifier = Modifier
                .align(Alignment.BottomStart)
                .offset(x = (-50).dp, y = 50.dp)
                .size(250.dp)
                .blur(100.dp)
                .background(MaterialTheme.colorScheme.secondaryContainer.copy(alpha = 0.1f), CircleShape)
        )

        Scaffold(
            containerColor = Color.Transparent,
            topBar = { SharedTopBar() },
            bottomBar = { 
                SharedBottomBar(
                    currentTab = currentTab,
                    onTabSelected = { currentTab = it },
                    onAddClick = onAddClick
                ) 
            }
        ) { innerPadding ->
            Box(modifier = Modifier.padding(innerPadding)) {
                when (currentTab) {
                    "mood" -> MoodScreen(
                        entries = entries,
                        onEditClick = onEditClick,
                        onDeleteClick = onDeleteClick
                    )
                    "stats" -> StatsScreen()
                    "journal" -> JournalScreen()
                    "profile" -> ProfileScreen()
                }
            }
        }
    }
}

@Composable
fun SharedTopBar() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .statusBarsPadding()
            .height(64.dp)
            .padding(horizontal = 20.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = { }) {
            Icon(Icons.Default.CalendarMonth, contentDescription = null, tint = MDPrimary)
        }
        Text(
            text = "MindDiary",
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold,
            color = MDPrimary
        )
        IconButton(onClick = { }) {
            Icon(Icons.Default.Settings, contentDescription = null, tint = MDPrimary)
        }
    }
}

@Composable
fun SharedBottomBar(currentTab: String, onTabSelected: (String) -> Unit, onAddClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .navigationBarsPadding()
            .padding(bottom = 16.dp, start = 16.dp, end = 16.dp)
    ) {
        Surface(
            color = MDSurfaceContainer.copy(alpha = 0.9f),
            shape = RoundedCornerShape(24.dp),
            shadowElevation = 8.dp,
            modifier = Modifier
                .fillMaxWidth()
                .height(80.dp)
                .border(1.dp, Color.White.copy(alpha = 0.1f), RoundedCornerShape(24.dp))
        ) {
            Row(
                modifier = Modifier.fillMaxSize(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(
                    modifier = Modifier.weight(1f),
                    horizontalArrangement = Arrangement.SpaceAround
                ) {
                    BottomNavItem(
                        icon = Icons.Default.Mood,
                        label = stringResource(R.string.nav_mood),
                        selected = currentTab == "mood",
                        onClick = { onTabSelected("mood") }
                    )
                    BottomNavItem(
                        icon = Icons.Default.BarChart,
                        label = stringResource(R.string.nav_stats),
                        selected = currentTab == "stats",
                        onClick = { onTabSelected("stats") }
                    )
                }
                
                Spacer(modifier = Modifier.width(64.dp)) // Equal to FAB size
                
                Row(
                    modifier = Modifier.weight(1f),
                    horizontalArrangement = Arrangement.SpaceAround
                ) {
                    BottomNavItem(
                        icon = Icons.Default.EditNote,
                        label = stringResource(R.string.nav_journal),
                        selected = currentTab == "journal",
                        onClick = { onTabSelected("journal") }
                    )
                    BottomNavItem(
                        icon = Icons.Default.Person,
                        label = stringResource(R.string.nav_profile),
                        selected = currentTab == "profile",
                        onClick = { onTabSelected("profile") }
                    )
                }
            }
        }
        
        // Floating Action Button - Perfectly centered
        LargeFloatingActionButton(
            onClick = onAddClick,
            shape = CircleShape,
            containerColor = MDPrimary,
            contentColor = Color.Black,
            modifier = Modifier
                .align(Alignment.TopCenter)
                .offset(y = (-28).dp)
                .size(64.dp)
                .border(4.dp, MDSurfaceContainer, CircleShape)
        ) {
            Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.size(32.dp))
        }
    }
}

@Composable
fun BottomNavItem(
    icon: ImageVector,
    label: String,
    selected: Boolean = false,
    onClick: () -> Unit
) {
    val color = if (selected) MaterialTheme.colorScheme.onSecondaryContainer else MaterialTheme.colorScheme.onSurfaceVariant
    val containerColor = if (selected) MaterialTheme.colorScheme.secondaryContainer else Color.Transparent
    
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(20.dp))
            .background(containerColor)
            .clickable(onClick = onClick)
            .padding(horizontal = 12.dp, vertical = 4.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(icon, null, tint = color, modifier = Modifier.size(24.dp))
            Text(text = label, style = MaterialTheme.typography.labelSmall, color = color)
        }
    }
}
