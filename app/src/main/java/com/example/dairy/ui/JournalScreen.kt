package com.example.dairy.ui

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dairy.R
import com.example.dairy.ui.theme.MDGlassBackground
import com.example.dairy.ui.theme.MDPrimary

@Composable
fun JournalScreen() {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 20.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = stringResource(R.string.journal_today),
                style = MaterialTheme.typography.headlineMedium,
                color = MaterialTheme.colorScheme.onBackground
            )
        }

        item {
            CalendarCard()
        }

        item {
            MoodDistributionCard()
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
fun CalendarCard() {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(24.dp),
        modifier = Modifier.border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = stringResource(R.string.journal_month_year).uppercase(),
                    style = MaterialTheme.typography.labelMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    letterSpacing = 2.sp
                )
                Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    Icon(Icons.Default.ChevronLeft, null, tint = MDPrimary)
                    Icon(Icons.Default.ChevronRight, null, tint = MDPrimary)
                }
            }

            // Days Header
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceAround) {
                listOf("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su").forEach {
                    Text(text = it, style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.outline)
                }
            }

            // Grid (simplified representation of the July grid)
            val days = (29..30).toList() + (1..31).toList() + (1..2).toList()
            val chunkedDays = days.chunked(7)
            
            chunkedDays.take(5).forEachIndexed { rowIndex, week ->
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceAround) {
                    week.forEachIndexed { colIndex, day ->
                        DayCell(day, rowIndex, colIndex)
                    }
                }
            }
        }
    }
}

@Composable
fun DayCell(day: Int, rowIndex: Int, colIndex: Int) {
    Box(
        modifier = Modifier.size(40.dp),
        contentAlignment = Alignment.Center
    ) {
        if (rowIndex == 1 && colIndex == 0) { // July 6 (Mood)
            Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.tertiary.copy(alpha = 0.2f), shape = CircleShape) {
                Icon(Icons.Default.Mood, null, tint = MaterialTheme.colorScheme.tertiary, modifier = Modifier.padding(8.dp))
            }
        } else if (rowIndex == 1 && colIndex == 2) { // July 8 (Satisfied)
            Surface(modifier = Modifier.fillMaxSize(), color = MDPrimary.copy(alpha = 0.2f), shape = CircleShape) {
                Icon(Icons.Default.SentimentSatisfied, null, tint = MDPrimary, modifier = Modifier.padding(8.dp))
            }
        } else if (rowIndex == 4 && (colIndex == 3 || colIndex == 4)) { // July 30, 31 (Neutral)
            Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.secondaryContainer, shape = CircleShape) {
                Icon(Icons.Default.SentimentNeutral, null, tint = MaterialTheme.colorScheme.onSecondaryContainer, modifier = Modifier.padding(8.dp))
            }
        } else {
            val isOutOfMonth = (rowIndex == 0 && day > 20) || (rowIndex == 4 && day < 5)
            Text(
                text = day.toString(),
                style = MaterialTheme.typography.labelSmall,
                color = if (isOutOfMonth) MaterialTheme.colorScheme.outline.copy(alpha = 0.5f) else MaterialTheme.colorScheme.onSurface
            )
        }
    }
}

@Composable
fun MoodDistributionCard() {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(24.dp),
        modifier = Modifier.border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(
                text = stringResource(R.string.mood_distribution).uppercase(),
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 2.sp
            )
            
            Box(modifier = Modifier.fillMaxWidth().height(140.dp), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "2",
                        style = MaterialTheme.typography.headlineLarge,
                        fontWeight = FontWeight.ExtraBold,
                        fontSize = 40.sp,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    Text(
                        text = stringResource(R.string.avg_score).uppercase(),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                MoodStat(Icons.Default.Mood, "12", MaterialTheme.colorScheme.tertiary)
                MoodStat(Icons.Default.SentimentSatisfied, "8", MDPrimary)
                MoodStat(Icons.Default.SentimentNeutral, "5", MaterialTheme.colorScheme.secondary)
                MoodStat(Icons.Default.SentimentDissatisfied, "2", MaterialTheme.colorScheme.outline)
                MoodStat(Icons.Default.SentimentVeryDissatisfied, "0", MaterialTheme.colorScheme.error)
            }
        }
    }
}

@Composable
fun MoodStat(icon: ImageVector, count: String, color: Color) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Icon(icon, null, tint = color, modifier = Modifier.size(24.dp))
        Text(
            text = count,
            style = MaterialTheme.typography.labelSmall,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onSurface
        )
    }
}
