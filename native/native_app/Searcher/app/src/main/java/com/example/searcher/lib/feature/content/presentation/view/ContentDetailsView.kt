package com.example.searcher.lib.feature.content.presentation.view

import android.content.Intent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentDetailsState
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentDetailsViewModel
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.NavHostController
import com.skydoves.landscapist.glide.GlideImage

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContentDetailView(
    viewModel: ContentDetailsViewModel, navController: NavHostController,
) {
    val contentState by viewModel.contentState.collectAsState()

    LaunchedEffect(viewModel) {
        if (contentState !is ContentDetailsState.Success && contentState !is ContentDetailsState.Error) {
            viewModel.fetchData()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(title = {}, navigationIcon = {
                if (navController.previousBackStackEntry != null) {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Назад")
                    }
                }
            })
        }) { paddingValues ->
        Box(
            modifier = Modifier.fillMaxSize().padding(paddingValues)
        ) {
            when (contentState) {
                is ContentDetailsState.Loading -> {
                    Box(
                        modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }

                is ContentDetailsState.Success -> {
                    val data = (contentState as ContentDetailsState.Success).data
                    val context = LocalContext.current

                    Column(
                        modifier = Modifier.fillMaxWidth().padding(16.dp)
                    ) {
                        Text(
                            text = data.title,
                            style = MaterialTheme.typography.headlineLarge,
                        )

                        Spacer(modifier = Modifier.height(16.dp))

                        GlideImage(
                            imageModel = { data.images.original.url },
                            modifier = Modifier.fillMaxWidth(),
                            loading = {
                                CircularProgressIndicator(modifier = Modifier.padding(16.dp))
                            },
                            failure = {
                                Text("Не вдалося завантажити зображення")
                            })

                        Spacer(modifier = Modifier.height(24.dp))

                        Button(onClick = {
                            val shareIntent = Intent().apply {
                                action = Intent.ACTION_SEND
                                putExtra(
                                    Intent.EXTRA_TEXT, "Подивись це: ${data.title}\n${data.images.original.url}"
                                )
                            }
                            context.startActivity(Intent.createChooser(shareIntent, "Поділитись через"))
                        }) {
                            Text("Поділитись")
                        }
                    }
                }

                is ContentDetailsState.Error -> {
                    Text(
                        text = (contentState as ContentDetailsState.Error).message,
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.error,
                    )
                }
            }
        }
    }
}