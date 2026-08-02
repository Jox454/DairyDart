package com.example.dairy.ui

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.TrendingUp
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dairy.R
import com.example.dairy.ui.theme.MDGlassBackground
import com.example.dairy.ui.theme.MDPrimary

@Composable
fun StatsScreen() {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 20.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = { }) {
                    Icon(Icons.Default.ChevronLeft, null, tint = MDPrimary)
                }
                Text(
                    text = stringResource(R.string.journal_month_year),
                    style = MaterialTheme.typography.headlineMedium,
                    color = MaterialTheme.colorScheme.onBackground
                )
                IconButton(onClick = { }) {
                    Icon(Icons.Default.ChevronRight, null, tint = MDPrimary)
                }
            }
        }

        item {
            StreakCard()
        }

        item {
            MoodFluctuationsCard()
        }

        item {
            MoodDistributionCard()
        }

        item {
            AchievementsSection()
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
fun StreakCard() {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.Bottom
        ) {
            Text(
                text = stringResource(R.string.streak_title).uppercase(),
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 2.sp
            )
            Text(
                text = stringResource(R.string.streak_count),
                style = MaterialTheme.typography.bodyMedium,
                color = MDPrimary,
                fontWeight = FontWeight.Bold
            )
        }

        Surface(
            color = MDGlassBackground,
            shape = RoundedCornerShape(24.dp),
            modifier = Modifier.border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.SpaceAround
            ) {
                val days = listOf("Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
                days.forEachIndexed { index, day ->
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.graphicsLayer(alpha = if (index > 3) 0.4f else 1f)
                    ) {
                        Text(text = day, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        if (index <= 3) {
                            Surface(
                                color = MaterialTheme.colorScheme.secondaryContainer,
                                shape = CircleShape,
                                modifier = Modifier.size(40.dp)
                            ) {
                                Box(contentAlignment = Alignment.Center) {
                                    Icon(Icons.Default.CheckCircle, null, tint = MaterialTheme.colorScheme.onSecondaryContainer, modifier = Modifier.size(24.dp))
                                }
                            }
                        } else {
                            Box(
                                modifier = Modifier
                                    .size(40.dp)
                                    .border(1.dp, MaterialTheme.colorScheme.outline, CircleShape),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(text = (16 + index).toString(), style = MaterialTheme.typography.labelSmall)
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun MoodFluctuationsCard() {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(24.dp),
        modifier = Modifier.border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
    ) {
        Column(modifier = Modifier.padding(24.dp), verticalArrangement = Arrangement.spacedBy(20.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Column {
                    Text(
                        text = stringResource(R.string.mood_fluctuations).uppercase(),
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        letterSpacing = 2.sp
                    )
                    Text(
                        text = stringResource(R.string.past_7_days),
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                }
                Icon(Icons.AutoMirrored.Filled.TrendingUp, null, tint = MaterialTheme.colorScheme.tertiary)
            }

            Box(modifier = Modifier.fillMaxWidth().height(160.dp)) {
                Canvas(modifier = Modifier.fillMaxSize()) {
                    val width = size.width
                    val height = size.height
                    
                    val points = listOf(
                        Offset(0f, height * 0.8f),
                        Offset(width * 0.2f, height * 0.5f),
                        Offset(width * 0.4f, height * 0.7f),
                        Offset(width * 0.6f, height * 0.3f),
                        Offset(width * 0.8f, height * 0.6f),
                        Offset(width, height * 0.4f)
                    )

                    val path = Path().apply {
                        moveTo(points[0].x, points[0].y)
                        for (i in 1 until points.size) {
                            lineTo(points[i].x, points[i].y)
                        }
                    }

                    drawPath(
                        path = path,
                        color = MDPrimary,
                        style = Stroke(width = 3.dp.toPx())
                    )
                    
                    val fillPath = Path().apply {
                        addPath(path)
                        lineTo(width, height)
                        lineTo(0f, height)
                        close()
                    }
                    drawPath(
                        path = fillPath,
                        brush = Brush.verticalGradient(
                            colors = listOf(MDPrimary.copy(alpha = 0.3f), Color.Transparent)
                        )
                    )
                    
                    points.forEach { point ->
                        drawCircle(color = MDPrimary, radius = 4.dp.toPx(), center = point)
                    }
                }
            }
            
            Row(
                modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                listOf("28", "29", "30", "31", "01", "02", "03").forEach {
                    Text(text = it, style = MaterialTheme.typography.labelSmall, color = MDPrimary, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@Composable
fun AchievementsSection() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Text(
            text = stringResource(R.string.achievements).uppercase(),
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            letterSpacing = 2.sp
        )

        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            AchievementCard(
                title = stringResource(R.string.zen_master),
                desc = stringResource(R.string.zen_desc),
                icon = Icons.Default.WorkspacePremium,
                color = MaterialTheme.colorScheme.tertiary,
                modifier = Modifier.weight(1f)
            )
            AchievementCard(
                title = stringResource(R.string.on_fire),
                desc = stringResource(R.string.fire_desc),
                icon = Icons.Default.LocalFireDepartment,
                color = MDPrimary,
                modifier = Modifier.weight(1f)
            )
        }

        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            AchievementCard(
                title = stringResource(R.string.philosopher),
                desc = stringResource(R.string.philo_desc),
                icon = Icons.Default.Psychology,
                color = MaterialTheme.colorScheme.outline,
                unlocked = false,
                modifier = Modifier.weight(1f)
            )
            AchievementCard(
                title = stringResource(R.string.optimist),
                desc = stringResource(R.string.opti_desc),
                icon = Icons.Default.AutoAwesome,
                color = MaterialTheme.colorScheme.secondary,
                modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
fun AchievementCard(
    modifier: Modifier = Modifier,
    title: String,
    desc: String,
    icon: ImageVector,
    color: Color,
    unlocked: Boolean = true
) {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(24.dp),
        modifier = modifier
            .graphicsLayer(alpha = if (unlocked) 1f else 0.5f)
            .border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(24.dp))
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Surface(
                modifier = Modifier.size(64.dp),
                color = color.copy(alpha = 0.2f),
                shape = CircleShape
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(icon, null, tint = color, modifier = Modifier.size(32.dp))
                }
            }
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text(text = title, style = MaterialTheme.typography.labelLarge, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onSurface)
                Text(text = desc, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp)
            }
        }
    }
}
