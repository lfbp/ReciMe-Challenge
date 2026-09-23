//
//  FavoritesViewModel.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

final class FavoritesViewModel: BaseViewModel {
    @Published var favoriteRecipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedRecipe: Recipe?
    
    // Expose services for child modules
    let recipeService: RecipeServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    let observability: ObservabilityManager
    let errorHandler: ErrorHandler
    
    init(recipeService: RecipeServiceProtocol, favoritesService: FavoritesServiceProtocol, observability: ObservabilityManager, errorHandler: ErrorHandler) {
        self.recipeService = recipeService
        self.favoritesService = favoritesService
        self.observability = observability
        self.errorHandler = errorHandler
        super.init()
        setupBindings()
        observability.analytics.track(event: .screenViewed(screenName: "Favorites"))
        observability.impressions.trackImpression(
            contentId: "Favorites",
            contentType: "screen",
            metadata: [:]
        )
    }
    
    private func setupBindings() {
        favoritesService.favoritesPublisher
            .combineLatest(
                recipeService.fetchRecipes()
                    .replaceError(with: [])
            )
            .map { favoriteIds, allRecipes in
                allRecipes.filter { favoriteIds.contains($0.id) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.favoriteRecipes = recipes
                self?.applyFilter()
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    func selectRecipe(_ recipe: Recipe) {
        selectedRecipe = recipe
    }
    
    func removeFavorite(_ recipeId: UUID) {
        favoritesService.removeFavorite(recipeId)
    }
    
    private func applyFilter() {
        if searchText.isEmpty {
            filteredRecipes = favoriteRecipes
        } else {
            let searchLower = searchText.lowercased()
            filteredRecipes = favoriteRecipes.filter { recipe in
                recipe.title.lowercased().contains(searchLower) ||
                recipe.description.lowercased().contains(searchLower) ||
                recipe.cuisine.lowercased().contains(searchLower)
            }
        }
    }
}
