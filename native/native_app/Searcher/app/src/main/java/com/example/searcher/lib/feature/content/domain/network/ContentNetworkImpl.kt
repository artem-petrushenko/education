import com.beust.klaxon.Klaxon
import com.example.searcher.lib.feature.content.domain.model.ContentDataModel
import com.example.searcher.lib.feature.content.domain.model.ContentDetailsModel
import com.example.searcher.lib.feature.content.domain.model.ContentModel
import com.example.searcher.lib.feature.content.domain.network.ContentNetworkInterface
import kotlinx.coroutines.suspendCancellableCoroutine
import okhttp3.*
import okio.IOException
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class ContentNetworkImpl : ContentNetworkInterface {
    override suspend fun getContent(query: String): List<ContentModel> {
        val client = OkHttpClient()
        var url = "https://api.giphy.com/v1/gifs/search?api_key=kkj4jS7Yr8HpsYWKhNPlrOBAyQB6Pcha&limit=20"
        if(query.isNotEmpty()){
            url += "&q=$query"
        }
        val request = Request.Builder()
            .url(url)
            .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .get()
            .build()

        return suspendCancellableCoroutine { continuation ->
            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    if (continuation.isActive) {
                        continuation.resumeWithException(e)
                    }
                }

                override fun onResponse(call: Call, response: Response) {
                    response.use {
                        if (response.isSuccessful) {
                            val responseBody = response.body?.string()
                            if (responseBody != null) {
                                try {
                                    val contentDataModel = Klaxon().parse<ContentDataModel>(responseBody)
                                    if (contentDataModel != null) {
                                        continuation.resume(contentDataModel.data)
                                    } else {
                                        continuation.resumeWithException(Exception("Failed to parse response"))
                                    }
                                } catch (e: Exception) {
                                    continuation.resumeWithException(e)
                                }
                            } else {
                                continuation.resumeWithException(Exception("Response body is null"))
                            }
                        } else {
                            continuation.resumeWithException(Exception("Failed with code: ${response.code}"))
                        }
                    }
                }
            })
        }
    }

    override suspend fun getContentById(id: String): ContentModel {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url("https://api.giphy.com/v1/gifs/${id}?api_key=kkj4jS7Yr8HpsYWKhNPlrOBAyQB6Pcha")
            .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .get()
            .build()

        return suspendCancellableCoroutine { continuation ->
            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    if (continuation.isActive) {
                        continuation.resumeWithException(e)
                    }
                }

                override fun onResponse(call: Call, response: Response) {
                    response.use {
                        if (response.isSuccessful) {
                            val responseBody = response.body?.string()
                            if (responseBody != null) {
                                try {
                                    val contentDataModel = Klaxon().parse<ContentDetailsModel>(responseBody)
                                    if (contentDataModel != null) {
                                        continuation.resume(contentDataModel.data)
                                    } else {
                                        continuation.resumeWithException(Exception("Failed to parse response"))
                                    }
                                } catch (e: Exception) {
                                    continuation.resumeWithException(e)
                                }
                            } else {
                                continuation.resumeWithException(Exception("Response body is null"))
                            }
                        } else {
                            continuation.resumeWithException(Exception("Failed with code: ${response.code}"))
                        }
                    }
                }
            })
        }
    }
}