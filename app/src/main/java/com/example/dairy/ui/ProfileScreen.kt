package com.example.dairy.ui

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dairy.R
import com.example.dairy.ui.theme.MDGlassBackground
import com.example.dairy.ui.theme.MDPrimary
import com.example.dairy.ui.theme.MDSurfaceContainer

@Composable
fun ProfileScreen() {
    var remindersEnabled by remember { mutableStateOf(true) }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 20.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(bottom = 32.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(24.dp))
            ProfileHeader()
        }

        item {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                ProfileMenuItem(
                    icon = Icons.Default.AdsClick,
                    label = stringResource(R.string.menu_goals),
                    iconContainerColor = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.2f),
                    iconColor = MDPrimary
                )
                ProfileMenuItem(
                    icon = Icons.Default.DataThresholding,
                    label = stringResource(R.string.menu_weekly_reports),
                    iconContainerColor = MaterialTheme.colorScheme.secondaryContainer.copy(alpha = 0.2f),
                    iconColor = MaterialTheme.colorScheme.secondary
                )
                ProfileMenuItem(
                    icon = Icons.Default.EventNote,
                    label = stringResource(R.string.menu_important_days),
                    iconContainerColor = MaterialTheme.colorScheme.tertiaryContainer.copy(alpha = 0.2f),
                    iconColor = MaterialTheme.colorScheme.tertiary
                )
                ProfileMenuItem(
                    icon = Icons.Default.PhotoLibrary,
                    label = stringResource(R.string.menu_photo_gallery),
                    iconContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
                    iconColor = MaterialTheme.colorScheme.onSurface
                )
                ProfileMenuItem(
                    icon = Icons.Default.MilitaryTech,
                    label = stringResource(R.string.menu_achievements),
                    iconContainerColor = Color(0xFFFFD700).copy(alpha = 0.2f),
                    iconColor = Color(0xFFFFD700)
                )
                
                // Reminders Toggle
                Surface(
                    color = MDGlassBackground,
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(16.dp))
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        Surface(
                            modifier = Modifier.size(40.dp),
                            color = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.1f),
                            shape = CircleShape
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Icon(
                                    Icons.Default.NotificationsActive,
                                    null,
                                    tint = MaterialTheme.colorScheme.primaryContainer,
                                    modifier = Modifier.size(20.dp)
                                )
                            }
                        }
                        Text(
                            text = stringResource(R.string.menu_reminders),
                            modifier = Modifier.weight(1f),
                            style = MaterialTheme.typography.labelLarge,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Switch(
                            checked = remindersEnabled,
                            onCheckedChange = { remindersEnabled = it },
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                checkedTrackColor = MaterialTheme.colorScheme.primaryContainer
                            )
                        )
                    }
                }

                ProfileMenuItem(
                    icon = Icons.Default.SentimentSatisfied,
                    label = stringResource(R.string.menu_edit_moods),
                    iconContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
                    iconColor = MaterialTheme.colorScheme.onSurfaceVariant
                )
                ProfileMenuItem(
                    icon = Icons.Default.FitnessCenter,
                    label = stringResource(R.string.menu_edit_activities),
                    iconContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
                    iconColor = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        item {
            PremiumBanner()
        }
    }
}

@Composable
fun ProfileHeader() {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(modifier = Modifier.size(96.dp)) {
            // Circular Border/Frame
            Surface(
                modifier = Modifier
                    .fillMaxSize()
                    .border(4.dp, MaterialTheme.colorScheme.primaryContainer, CircleShape),
                shape = CircleShape,
                color = MDSurfaceContainer
            ) {
                // Placeholder for User Image
                Image(
                    painter = painterResource(id = R.drawable.onboarding_photo), // Using existing photo as placeholder
                    contentDescription = null,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize().clip(CircleShape)
                )
            }
            // Edit Badge
            Surface(
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .size(28.dp)
                    .border(2.dp, MaterialTheme.colorScheme.background, CircleShape),
                color = MaterialTheme.colorScheme.primaryContainer,
                shape = CircleShape
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        Icons.Default.Edit,
                        null,
                        tint = MaterialTheme.colorScheme.onPrimaryContainer,
                        modifier = Modifier.size(14.dp)
                    )
                }
            }
        }

        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = stringResource(R.string.profile_name),
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = stringResource(R.string.profile_status),
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
fun ProfileMenuItem(
    icon: ImageVector,
    label: String,
    iconContainerColor: Color,
    iconColor: Color,
    onClick: () -> Unit = {}
) {
    Surface(
        color = MDGlassBackground,
        shape = RoundedCornerShape(16.dp),
        modifier = Modifier
            .fillMaxWidth()
            .border(1.dp, Color.White.copy(alpha = 0.05f), RoundedCornerShape(16.dp))
            .clickable(onClick = onClick)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Surface(
                modifier = Modifier.size(40.dp),
                color = iconContainerColor,
                shape = CircleShape
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(icon, null, tint = iconColor, modifier = Modifier.size(20.dp))
                }
            }
            Text(
                text = label,
                modifier = Modifier.weight(1f),
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
            Icon(
                Icons.Default.ChevronRight,
                null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

@Composable
fun PremiumBanner() {
    Surface(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(24.dp))
            .clickable { },
        shape = RoundedCornerShape(24.dp),
    ) {
        Box(
            modifier = Modifier
                .background(
                    brush = Brush.linearGradient(
                        colors = listOf(Color(0xFFA078FF), Color(0xFF0566D9))
                    )
                )
                .padding(24.dp)
        ) {
            Column(
                modifier = Modifier.fillMaxWidth(0.6f),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = stringResource(R.string.premium_title),
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
                Text(
                    text = stringResource(R.string.premium_desc),
                    style = MaterialTheme.typography.bodySmall,
                    color = Color.White.copy(alpha = 0.9f)
                )
                Button(
                    onClick = { },
                    colors = ButtonDefaults.buttonColors(containerColor = Color.White),
                    shape = RoundedCornerShape(8.dp),
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
                ) {
                    Text(
                        text = stringResource(R.string.upgrade_now),
                        color = Color(0xFFA078FF),
                        fontWeight = FontWeight.Bold,
                        style = MaterialTheme.typography.labelMedium
                    )
                }
            }
            
            Icon(
                Icons.Default.WorkspacePremium,
                null,
                tint = Color.White.copy(alpha = 0.1f),
                modifier = Modifier
                    .size(120.dp)
                    .align(Alignment.BottomEnd)
                    .offset(x = 20.dp, y = 20.dp)
            )
        }
    }
}
