//
//  PreviewSupport.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

#if DEBUG
import Combine
import Foundation
import SwiftUI

enum PreviewSupport {
    static func makeAppDependencies() -> AppDependencies {
        AppDependencies(observability: ObservabilityManager())
    }
    
    static func makeRecipeListViewModel(
        recipeService: RecipeServiceProtocol? = nil,
        favoritesService: FavoritesServiceProtocol = FavoritesService()
    ) -> RecipeListViewModel {
        let deps = makeAppDependencies()
        return RecipeListViewModel(
            recipeService: recipeService ?? deps.recipeService,
            favoritesService: favoritesService,
            observability: deps.observability,
            errorHandler: deps.errorHandler
        )
    }
    
    static func makeFavoritesViewModel(
        recipeService: RecipeServiceProtocol? = nil,
        favoritesService: FavoritesServiceProtocol = FavoritesService()
    ) -> FavoritesViewModel {
        let deps = makeAppDependencies()
        return FavoritesViewModel(
            recipeService: recipeService ?? deps.recipeService,
            favoritesService: favoritesService,
            observability: deps.observability,
            errorHandler: deps.errorHandler
        )
    }
    
    static func makeRecipeDetailViewModel(
        recipe: Recipe = .preview,
        favoritesService: FavoritesServiceProtocol = FavoritesService()
    ) -> RecipeDetailViewModel {
        let deps = makeAppDependencies()
        return RecipeDetailViewModel(
            recipe: recipe,
            favoritesService: favoritesService,
            recipeService: deps.recipeService,
            observability: deps.observability,
            errorHandler: deps.errorHandler
        )
    }
    
    /// Instant recipes — no JSON / network delay (good for Favorites + Detail).
    static func makeStaticRecipeService(recipes: [Recipe] = Recipe.previews) -> RecipeServiceProtocol {
        PreviewRecipeService(recipes: recipes)
    }
}

/// In-memory recipe service for SwiftUI previews.
private final class PreviewRecipeService: RecipeServiceProtocol {
    private let recipes: [Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    func fetchRecipes() -> AnyPublisher<[Recipe], Error> {
        Just(recipes)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func searchRecipes(with filter: RecipeFilter) -> AnyPublisher<[Recipe], Error> {
        Just(recipes)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getRecipeDetail(id: UUID) -> AnyPublisher<Recipe, Error> {
        if let recipe = recipes.first(where: { $0.id == id }) {
            return Just(recipe)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "PreviewRecipeService", code: 404))
            .eraseToAnyPublisher()
    }
}
#endif
