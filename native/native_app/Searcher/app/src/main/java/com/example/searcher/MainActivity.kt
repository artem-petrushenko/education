package com.example.searcher

import ContentNetworkImpl
import android.animation.ObjectAnimator
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.annotation.RequiresApi
import androidx.core.animation.doOnEnd
import androidx.navigation.NavType
import androidx.navigation.compose.*
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.searcher.lib.feature.content.domain.provider.ContentProviderImpl
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentDetailsViewModel
import com.example.searcher.lib.feature.content.domain.viewmodel.ContentListViewModel
import com.example.searcher.lib.feature.content.presentation.view.ContentDetailView
import com.example.searcher.ui.theme.SearcherTheme
import com.example.searcher.lib.feature.content.presentation.view.ContentListView

class MainActivity : ComponentActivity() {
    @RequiresApi(Build.VERSION_CODES.S)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        splashScreen.setOnExitAnimationListener { splashScreenView ->
            val fadeOut = ObjectAnimator.ofFloat(
                splashScreenView,
                View.ALPHA,
                1f,
                0f
            )
            fadeOut.duration = 2000L
            fadeOut.doOnEnd { splashScreenView.remove() }
            fadeOut.start()
        }
        setContent {
            SearcherTheme {
                val navController = rememberNavController()
                val contentProvider = ContentProviderImpl(
                    contentNetwork = ContentNetworkImpl()
                )

                NavHost(navController = navController, startDestination = "contentList") {
                    composable("contentList") {
                        ContentListView(
                            navController = navController,
                            viewModel = ContentListViewModel(
                                contentProvider = contentProvider,
                            ),
                        )
                    }
                    composable(
                        "contentDetail/{id}", arguments = listOf(
                            navArgument("id") { type = NavType.StringType },
                        )
                    ) { backStackEntry ->
                        val id = backStackEntry.arguments?.getString("id") ?: ""
                        ContentDetailView(
                            navController = navController,
                            viewModel = ContentDetailsViewModel(
                                id = id,
                                contentProvider = contentProvider,
                            ),
                        )
                    }
                }
            }
        }
    }
}
