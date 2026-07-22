package com.example.appartmentapp.presentation.dashboard

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.appartmentapp.domain.model.Coin

// NoBroker inspired colors
val NoBrokerRed = Color(0xFFE53935)
val NoBrokerLightRed = Color(0xFFFFEBEE)
val NoBrokerGray = Color(0xFF757575)
val BackgroundGray = Color(0xFFF5F5F5)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DashboardScreen(
    viewModel: DashboardViewModel,
    onLogout: () -> Unit,
    onNavigateToLocation: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            Column(
                modifier = Modifier
                    .background(NoBrokerRed)
                    .statusBarsPadding()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(
                            text = "Find your home",
                            color = Color.White,
                            fontSize = 14.sp
                        )
                        Text(
                            text = "Bengaluru",
                            color = Color.White,
                            fontWeight = FontWeight.Bold,
                            fontSize = 18.sp
                        )
                    }
                    Row {
                        IconButton(onClick = onNavigateToLocation) {
                            Icon(Icons.Default.LocationOn, contentDescription = "Location", tint = Color.White)
                        }
                        IconButton(onClick = { /* Handle notifications */ }) {
                            BadgedBox(badge = {
                                if (uiState is DashboardUiState.Success && (uiState as DashboardUiState.Success).data.notificationsCount > 0) {
                                    Badge { Text((uiState as DashboardUiState.Success).data.notificationsCount.toString()) }
                                }
                            }) {
                                Icon(Icons.Default.Notifications, contentDescription = "Notifications", tint = Color.White)
                            }
                        }
                    }
                }
                
                Spacer(modifier = Modifier.height(12.dp))
                
                // Search Bar
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                    shape = RoundedCornerShape(8.dp),
                    color = Color.White
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(Icons.Default.Search, contentDescription = null, tint = NoBrokerGray)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "Search properties by locality...",
                            color = NoBrokerGray,
                            fontSize = 14.sp
                        )
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
            }
        },
        containerColor = BackgroundGray
    ) { padding ->
        Box(modifier = Modifier.fillMaxSize().padding(padding)) {
            when (val state = uiState) {
                is DashboardUiState.Loading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                        color = NoBrokerRed
                    )
                }
                is DashboardUiState.Success -> {
                    val data = state.data
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(bottom = 16.dp)
                    ) {
                        // Quick Services Grid (Simulated)
                        item {
                            QuickServicesSection()
                        }

                        // Welcome Message Section
                        item {
                            Card(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp),
                                colors = CardDefaults.cardColors(containerColor = NoBrokerLightRed),
                                shape = RoundedCornerShape(12.dp)
                            ) {
                                Column(modifier = Modifier.padding(16.dp)) {
                                    Text(
                                        text = data.welcomeMessage,
                                        style = MaterialTheme.typography.titleMedium,
                                        color = NoBrokerRed,
                                        fontWeight = FontWeight.Bold
                                    )
                                    Text(
                                        text = "Complete your profile to get better recommendations.",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = Color.DarkGray
                                    )
                                }
                            }
                        }
                        
                        // Top Coins (styled as "Market Insights")
                        if (data.topCoins.isNotEmpty()) {
                            item {
                                SectionHeader(title = "Market Insights (Top Coins)")
                                LazyRow(
                                    contentPadding = PaddingValues(horizontal = 16.dp),
                                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                                ) {
                                    items(data.topCoins) { coin ->
                                        CoinCard(coin)
                                    }
                                }
                            }
                        }

                        // Upcoming Events (styled as "Real Estate News")
                        item {
                            SectionHeader(title = "Upcoming Events & News")
                        }
                        
                        items(data.upcomingEvents) { event ->
                            EventItem(event)
                        }
                        
                        item {
                            Spacer(modifier = Modifier.height(16.dp))
                            Button(
                                onClick = { viewModel.logout(onLogout) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(horizontal = 16.dp),
                                colors = ButtonDefaults.buttonColors(containerColor = Color.White, contentColor = NoBrokerRed),
                                border = androidx.compose.foundation.BorderStroke(1.dp, NoBrokerRed),
                                shape = RoundedCornerShape(8.dp)
                            ) {
                                Text("Logout")
                            }
                        }
                    }
                }
                is DashboardUiState.Error -> {
                    Column(
                        modifier = Modifier.align(Alignment.Center).padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(text = state.message, color = MaterialTheme.colorScheme.error)
                        Spacer(modifier = Modifier.height(8.dp))
                        Button(onClick = { viewModel.loadDashboard() }, colors = ButtonDefaults.buttonColors(containerColor = NoBrokerRed)) {
                            Text("Retry")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun QuickServicesSection() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        QuickServiceItem("Rent", NoBrokerLightRed)
        QuickServiceItem("Buy", Color(0xFFE8F5E9))
        QuickServiceItem("Commercial", Color(0xFFE3F2FD))
        QuickServiceItem("Plots", Color(0xFFFFF3E0))
    }
}

@Composable
fun QuickServiceItem(label: String, bgColor: Color) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Box(
            modifier = Modifier
                .size(60.dp)
                .clip(CircleShape)
                .background(bgColor),
            contentAlignment = Alignment.Center
        ) {
            Text(label.take(1), fontWeight = FontWeight.Bold, color = Color.DarkGray)
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(text = label, fontSize = 12.sp, fontWeight = FontWeight.Medium)
    }
}

@Composable
fun SectionHeader(title: String) {
    Text(
        text = title,
        style = MaterialTheme.typography.titleMedium,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)
    )
}

@Composable
fun CoinCard(coin: Coin) {
    Card(
        modifier = Modifier.width(160.dp),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(text = coin.name, fontWeight = FontWeight.Bold, maxLines = 1)
            Text(text = coin.symbol.uppercase(), color = NoBrokerGray, fontSize = 12.sp)
            Spacer(modifier = Modifier.height(8.dp))
            Text(text = "$${coin.currentPrice}", fontWeight = FontWeight.ExtraBold, fontSize = 16.sp)
            val color = if (coin.priceChangePercentage24h >= 0) Color(0xFF4CAF50) else Color.Red
            Text(
                text = "${if (coin.priceChangePercentage24h >= 0) "+" else ""}${coin.priceChangePercentage24h}%",
                style = MaterialTheme.typography.bodySmall,
                color = color,
                fontWeight = FontWeight.Bold
            )
        }
    }
}

@Composable
fun EventItem(event: String) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 6.dp),
        shape = RoundedCornerShape(8.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .background(NoBrokerLightRed),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.Notifications, contentDescription = null, tint = NoBrokerRed, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(16.dp))
            Text(
                text = event,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Medium
            )
        }
    }
}
