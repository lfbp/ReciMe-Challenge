//
//  RecipeDetailViewModel.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

final class RecipeDetailViewModel: BaseViewModel {
    @Published var recipe: Recipe
    @Published var isFavorite: Bool = false
    
    private let favoritesService: FavoritesServiceProtocol
    let recipeService: RecipeServiceProtocol
    let observability: ObservabilityManager
    let errorHandler: ErrorHandler
    
    init(recipe: Recipe, favoritesService: FavoritesServiceProtocol, recipeService: RecipeServiceProtocol, observability: ObservabilityManager, errorHandler: ErrorHandler) {
        self.recipe = recipe
        self.favoritesService = favoritesService
        self.recipeService = recipeService
        self.observability = observability
        self.errorHandler = errorHandler
        super.init()
        
        isFavorite = favoritesService.isFavorite(recipe.id)
        
        favoritesService.favoritesPublisher
            .map { $0.contains(recipe.id) }
            .assign(to: &$isFavorite)
        
        observability.analytics.track(event: .screenViewed(screenName: "RecipeDetail"))
        observability.impressions.trackImpression(
            contentId: recipe.id.uuidString,
            contentType: "recipe_detail",
            metadata: ["title": recipe.title]
        )
    }
    
    func toggleFavorite() {
        let willFavorite = !isFavorite
        favoritesService.toggleFavorite(recipe.id)
        observability.analytics.track(
            event: willFavorite
                ? .recipeFavorited(recipeId: recipe.id.uuidString, recipeName: recipe.title)
                : .recipeUnfavorited(recipeId: recipe.id.uuidString, recipeName: recipe.title)
        )
    }
}
