//
//  RecipeListView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    @State private var showFilters = false
    @State private var draftFilter = RecipeFilter()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: SpacingTokens.sm) {
                RMSearchBar(searchText: $viewModel.searchText, placeholder: "Search recipes...")
                
                Button {
                    draftFilter = viewModel.filter
                    showFilters = true
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 28))
                            .foregroundColor(
                                viewModel.filter.hasActiveFilters
                                    ? ColorTokens.primary
                                    : ColorTokens.textSecondary
                            )
                        
                        if viewModel.activeFilterCount > 0 {
                            Text("\(viewModel.activeFilterCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(4)
                                .background(ColorTokens.accentRed)
                                .clipShape(Circle())
                                .offset(x: 6, y: -6)
                        }
                    }
                }
                .accessibilityLabel("Filters")
            }
            .padding(.horizontal, SpacingTokens.md)
            .padding(.vertical, SpacingTokens.sm)
            
            if viewModel.isLoading {
                RMLoadingView(message: "Loading recipes...")
            } else if viewModel.recipes.isEmpty {
                RMEmptyStateView(
                    icon: "tray",
                    title: "No Recipes Found",
                    message: "Try adjusting your search or filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: SpacingTokens.md) {
                        ForEach(viewModel.recipes) { recipe in
                            RecipeRowCard(
                                recipe: recipe,
                                isFavorite: viewModel.isFavorite(recipe.id),
                                onTap: { viewModel.selectRecipe(recipe) },
                                onFavoriteToggle: { viewModel.toggleFavorite(recipe.id) }
                            )
                            .onAppear {
                                viewModel.trackRecipeImpression(recipe)
                            }
                        }
                    }
                    .padding(SpacingTokens.md)
                }
            }
        }
        .navigationTitle("Recipes")
        .background(ColorTokens.background)
        .onAppear {
            if viewModel.recipes.isEmpty && !viewModel.isLoading {
                viewModel.loadRecipes()
            }
        }
        .sheet(isPresented: $showFilters) {
            RecipeFilterSheet(
                filter: $draftFilter,
                availableCuisines: viewModel.availableCuisines,
                onApply: {
                    viewModel.filter = draftFilter
                    viewModel.applyFilterNow()
                },
                onReset: {
                    draftFilter.reset()
                    viewModel.filter = draftFilter
                    viewModel.resetFilterOptions()
                }
            )
        }
    }
}
