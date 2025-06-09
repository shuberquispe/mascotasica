package com.example.mascotasica

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.tooling.preview.Preview
import com.example.mascotasica.ui.theme.MascotasIcaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MascotasIcaTheme {
                MainScreen()
            }
        }
    }
}

@Composable
fun MainScreen() {
    var showMessage by remember { mutableStateOf(false) }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = "¡Hola desde Mascotas Ica!",
                fontSize = 26.sp
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(onClick = {
                showMessage = true
            }) {
                Text(text = "Presiona aquí")
            }
            if (showMessage) {
                Spacer(modifier = Modifier.height(16.dp))
                Text(text = "Gracias por visitar nuestra app 🐾", fontSize = 20.sp)
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MainScreenPreview() {
    MascotasIcaTheme {
        MainScreen()
    }
}
