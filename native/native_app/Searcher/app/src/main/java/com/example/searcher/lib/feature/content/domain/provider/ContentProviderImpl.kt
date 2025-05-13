package com.example.searcher.lib.feature.content.domain.provider

import com.example.searcher.lib.feature.content.domain.model.ContentModel
import com.example.searcher.lib.feature.content.domain.network.ContentNetworkInterface

class ContentProviderImpl(private val contentNetwork: ContentNetworkInterface) : ContentProviderInterface {
    override suspend fun getContent(query: String): List<ContentModel> {
        return contentNetwork.getContent(query)
    }

    override suspend fun getContentById(id: String): ContentModel {
        return contentNetwork.getContentById(id)
    }
}
