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
