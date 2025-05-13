package com.example.searcher.lib.feature.content.domain.network

import com.example.searcher.lib.feature.content.domain.model.ContentModel

interface ContentNetworkInterface {
    suspend fun getContent(query: String): List<ContentModel>

    suspend fun getContentById(id: String): ContentModel
}