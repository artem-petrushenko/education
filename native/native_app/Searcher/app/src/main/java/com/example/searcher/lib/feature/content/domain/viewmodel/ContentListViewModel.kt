package com.example.searcher.lib.feature.content.domain.viewmodel

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.searcher.lib.feature.content.domain.model.ContentModel
import com.example.searcher.lib.feature.content.domain.provider.ContentProviderInterface
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

sealed class ContentListState {
    data object Initial: ContentListState()
    data object Loading : ContentListState()
    data class Success(val data: List<ContentModel>) : ContentListState()
    data class Error(val message: String) : ContentListState()
    data object Empty : ContentListState()
}

class ContentListViewModel(
    private val contentProvider: ContentProviderInterface
) : ViewModel() {
    private val _contentState: MutableStateFlow<ContentListState> = MutableStateFlow(ContentListState.Initial)
    val contentState: StateFlow<ContentListState> = _contentState.asStateFlow()

    var lastQuery: String = "Memes"

    fun fetchData(query: String? = null) {
        _contentState.value = ContentListState.Loading

        viewModelScope.launch {
            try {
                if (query != null) {
                    lastQuery = query
                }
                val result = contentProvider.getContent(lastQuery)
                _contentState.value = if (result.isEmpty()) {
                    ContentListState.Empty
                } else {
                    ContentListState.Success(result)
                }
            } catch (e: Exception) {
                _contentState.value = ContentListState.Error(e.localizedMessage ?: "Unknown error")
            }
        }
    }
}

