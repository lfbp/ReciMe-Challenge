//
//  MainTabView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var recipeListCoordinator: RecipeListCoordinator
    @ObservedObject var favoritesCoordinator: FavoritesCoordinator

    var body: some View {
        TabView {
            RecipeListFlowView(coordinator: recipeListCoordinator)
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
            
            FavoritesFlowView(coordinator: favoritesCoordinator)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .tint(ColorTokens.primary)
    }
}

#if DEBUG
#Preview("Main Tabs") {
    MainTabPreviewHost()
}

private struct MainTabPreviewHost: View {
    private let errorPresenter: ErrorPresenter
    @StateObject private var recipeListCoordinator: RecipeListCoordinator
    @StateObject private var favoritesCoordinator: FavoritesCoordinator
    
    init() {
        let deps = PreviewSupport.makeAppDependencies()
        let recipeList = RecipeListCoordinator(dependencies: deps.recipeList)
        let favorites = FavoritesCoordinator(dependencies: deps.favorites)
        recipeList.start()
        favorites.start()
        errorPresenter = ErrorPresenter(errorHandler: deps.errorHandler)
        _recipeListCoordinator = StateObject(wrappedValue: recipeList)
        _favoritesCoordinator = StateObject(wrappedValue: favorites)
    }
    
    var body: some View {
        MainTabView(
            recipeListCoordinator: recipeListCoordinator,
            favoritesCoordinator: favoritesCoordinator
        )
        .environmentObject(errorPresenter)
    }
}
#endif
