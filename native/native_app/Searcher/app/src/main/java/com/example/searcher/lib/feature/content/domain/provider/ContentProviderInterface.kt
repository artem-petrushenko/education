package com.example.searcher.lib.feature.content.domain.provider

import com.example.searcher.lib.feature.content.domain.model.ContentModel

interface ContentProviderInterface {
    suspend fun getContent(query: String): List<ContentModel>

    suspend fun getContentById(id: String): ContentModel
}