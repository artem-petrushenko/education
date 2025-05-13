package com.example.searcher.lib.feature.content.domain.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.searcher.lib.feature.content.domain.model.ContentModel
import com.example.searcher.lib.feature.content.domain.provider.ContentProviderInterface
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

sealed class ContentDetailsState {
    data object Loading : ContentDetailsState()
    data class Success(val data: ContentModel) : ContentDetailsState()
    data class Error(val message: String) : ContentDetailsState()
}

class ContentDetailsViewModel(
    private val id: String, private val contentProvider: ContentProviderInterface,
) : ViewModel() {
    private val _contentState: MutableStateFlow<ContentDetailsState> = MutableStateFlow(ContentDetailsState.Loading)
    val contentState: StateFlow<ContentDetailsState> = _contentState.asStateFlow()

    fun fetchData() {
        _contentState.value = ContentDetailsState.Loading
        viewModelScope.launch {
            try {
                val data = contentProvider.getContentById(id)
                _contentState.value = ContentDetailsState.Success(data)
            } catch (e: Exception) {
                _contentState.value = ContentDetailsState.Error("Failed to load data: ${e.message}")
            }
        }
    }
}
