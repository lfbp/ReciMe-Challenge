//
//  RecipeService.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

protocol RecipeServiceProtocol {
    func fetchRecipes() -> AnyPublisher<[Recipe], Error>
    func searchRecipes(with filter: RecipeFilter) -> AnyPublisher<[Recipe], Error>
    func getRecipeDetail(id: UUID) -> AnyPublisher<Recipe, Error>
}

final class RecipeService: RecipeServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private var cachedRecipes: [Recipe] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchRecipes() -> AnyPublisher<[Recipe], Error> {
        searchRecipes(with: RecipeFilter())
    }
    
    /// Always reloads from the mock backend and applies filter params server-side.
    func searchRecipes(with filter: RecipeFilter) -> AnyPublisher<[Recipe], Error> {
        networkService.loadLocalJSON(filename: "recipes")
            .map { (response: RecipeResponse) -> [Recipe] in
                response.recipes.filter { self.matches(recipe: $0, filter: filter) }
            }
            // Simulate network latency so each search/filter shows loading.
            .delay(for: .milliseconds(350), scheduler: DispatchQueue.global())
            .handleEvents(receiveOutput: { [weak self] recipes in
                if !filter.hasActiveFilters && filter.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self?.cachedRecipes = recipes
                }
            })
            .eraseToAnyPublisher()
    }
    
    func getRecipeDetail(id: UUID) -> AnyPublisher<Recipe, Error> {
        if let recipe = cachedRecipes.first(where: { $0.id == id }) {
            return Just(recipe)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return fetchRecipes()
            .compactMap { recipes in
                recipes.first(where: { $0.id == id })
            }
            .eraseToAnyPublisher()
    }
    
    private func matches(recipe: Recipe, filter: RecipeFilter) -> Bool {
        var matches = true
        
        if !filter.searchText.isEmpty {
            let searchLower = filter.searchText.lowercased()
            matches = matches && (
                recipe.title.lowercased().contains(searchLower) ||
                recipe.description.lowercased().contains(searchLower) ||
                recipe.cuisine.lowercased().contains(searchLower) ||
                recipe.ingredients.contains { $0.lowercased().contains(searchLower) }
            )
        }
        
        if !filter.dietaryAttributes.isEmpty {
            matches = matches && filter.dietaryAttributes.isSubset(of: Set(recipe.dietaryAttributes))
        }
        
        if let servings = filter.servings {
            matches = matches && recipe.servings >= servings
        }
        
        if let maxPrepTime = filter.maxPrepTime {
            matches = matches && recipe.prepTime <= maxPrepTime
        }
        
        if let difficulty = filter.difficulty {
            matches = matches && recipe.difficulty == difficulty
        }
        
        if let cuisine = filter.cuisine, !cuisine.isEmpty {
            matches = matches && recipe.cuisine.lowercased() == cuisine.lowercased()
        }
        
        if !filter.includeIngredients.isEmpty {
            matches = matches && filter.includeIngredients.allSatisfy { ingredient in
                recipe.ingredients.contains { $0.lowercased().contains(ingredient.lowercased()) }
            }
        }
        
        if !filter.excludeIngredients.isEmpty {
            matches = matches && !filter.excludeIngredients.contains { ingredient in
                recipe.ingredients.contains { $0.lowercased().contains(ingredient.lowercased()) }
            }
        }
        
        return matches
    }
}
