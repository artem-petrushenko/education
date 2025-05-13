package com.example.searcher.lib.feature.content.presentation.view

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentListState
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContentListView(
    viewModel: ContentListViewModel, navController: NavHostController
) {
    var searchQuery by rememberSaveable { mutableStateOf(viewModel.lastQuery) }
    val contentState by viewModel.contentState.collectAsState()


    LaunchedEffect(viewModel) {
        if (contentState is ContentListState.Initial) {
            viewModel.fetchData()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(title = {
                TextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    singleLine = true,
                    placeholder = { Text("Search") },
                    modifier = Modifier.fillMaxWidth()
                )
            }, actions = {
                IconButton(onClick = {
                    viewModel.fetchData(searchQuery)
                }) {
                    Icon(Icons.Default.Search, contentDescription = "Search")
                }
            })
        }) { paddingValues ->
        Box(
            modifier = Modifier.padding(paddingValues).fillMaxSize()
        ) {
            when (contentState) {

                is ContentListState.Success -> {
                    val items = (contentState as ContentListState.Success).data
                    LazyColumn(
                        modifier = Modifier.fillMaxSize().padding(16.dp)
                    ) {
                        items(items) { item ->
                            CartItemRow(content = item, onClick = {
                                navController.navigate("contentDetail/${item.id}") {

                                }
                            })
                        }
                    }
                }

                is ContentListState.Error -> {
                    Text(
                        text = (contentState as ContentListState.Error).message,
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.error,
                        modifier = Modifier.align(Alignment.Center)
                    )
                }

                ContentListState.Empty -> {
                    Text(
                        text = "Nothing found.",
                        style = MaterialTheme.typography.bodyLarge,
                        modifier = Modifier.align(Alignment.Center)
                    )
                }

                else -> {
                    Box(
                        modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }
            }
        }
    }
}