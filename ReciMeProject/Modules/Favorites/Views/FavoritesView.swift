//
//  FavoritesView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            if !viewModel.favoriteRecipes.isEmpty {
                RMSearchBar(searchText: $viewModel.searchText, placeholder: "Search favorites...")
                    .padding(.horizontal, SpacingTokens.md)
                    .padding(.vertical, SpacingTokens.sm)
            }
            
            // Content
            if viewModel.filteredRecipes.isEmpty {
                RMEmptyStateView(
                    icon: "heart.slash",
                    title: "No Favorites",
                    message: viewModel.searchText.isEmpty
                        ? "Start adding recipes to your favorites"
                        : "No favorites match your search"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: SpacingTokens.md) {
                        ForEach(viewModel.filteredRecipes) { recipe in
                            RecipeRowCard(
                                recipe: recipe,
                                isFavorite: true,
                                onTap: { viewModel.selectRecipe(recipe) },
                                onFavoriteToggle: { viewModel.removeFavorite(recipe.id) }
                            )
                        }
                    }
                    .padding(SpacingTokens.md)
                }
            }
        }
        .navigationTitle("Favorites")
        .background(ColorTokens.background)
    }
}

#if DEBUG
#Preview("Favorites — Empty") {
    NavigationStack {
        FavoritesView(viewModel: PreviewSupport.makeFavoritesViewModel())
    }
}

#Preview("Favorites — Populated") {
    let favoritesService = FavoritesService()
    favoritesService.toggleFavorite(Recipe.preview.id)
    favoritesService.toggleFavorite(Recipe.previewAlt.id)
    
    return NavigationStack {
        FavoritesView(
            viewModel: PreviewSupport.makeFavoritesViewModel(
                recipeService: PreviewSupport.makeStaticRecipeService(),
                favoritesService: favoritesService
            )
        )
    }
}
#endif
