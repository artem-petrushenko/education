package com.example.searcher.lib.feature.content.domain.model

import com.beust.klaxon.*

private fun <T> Klaxon.convert(
    k: kotlin.reflect.KClass<*>,
    fromJson: (JsonValue) -> T,
    toJson: (T) -> String,
    isUnion: Boolean = false
) =
    this.converter(object : Converter {
        @Suppress("UNCHECKED_CAST")
        override fun toJson(value: Any) = toJson(value as T)
        override fun fromJson(jv: JsonValue) = fromJson(jv) as Any
        override fun canConvert(cls: Class<*>) = cls == k.java || (isUnion && cls.superclass == k.java)
    })

data class ContentDataModel(
    val data: List<ContentModel>,
    val meta: Meta,
    val pagination: Pagination
) {
    private val klaxon = Klaxon()

    fun toJson() = klaxon.toJsonString(this)

    companion object {
        private val klaxon = Klaxon()

        fun fromJson(json: String) = klaxon.parse<ContentDataModel>(json)
    }
}

data class ContentDetailsModel(
    val data: ContentModel,
) {
    private val klaxon = Klaxon()

    fun toJson() = klaxon.toJsonString(this)

    companion object {
        private val klaxon = Klaxon()

        fun fromJson(json: String) = klaxon.parse<ContentDataModel>(json)
    }
}

data class ContentModel(
    val id: String,
    val title: String,
    val images: Images,
)

data class Images(
    val original: FixedHeight,
)


data class FixedHeight(
    val url: String,
)


data class Meta(
    val status: Long,
    val msg: String,
    @Json(name = "response_id")
    val responseID: String
)

data class Pagination(
    @Json(name = "total_count")
    val totalCount: Long,
    val count: Long,
    val offset: Long
)
