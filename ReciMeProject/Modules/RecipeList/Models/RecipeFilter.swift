//
//  RecipeFilter.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct RecipeFilter: Equatable {
    var searchText: String = ""
    var dietaryAttributes: Set<DietaryAttribute> = []
    var servings: Int?
    var maxPrepTime: Int?
    var difficulty: Recipe.Difficulty?
    var cuisine: String?
    var includeIngredients: [String] = []
    var excludeIngredients: [String] = []
    
    /// Sheet/tag filters only (search text is separate).
    var hasActiveFilters: Bool {
        !dietaryAttributes.isEmpty ||
        servings != nil ||
        maxPrepTime != nil ||
        difficulty != nil ||
        cuisine != nil ||
        !includeIngredients.isEmpty ||
        !excludeIngredients.isEmpty
    }
    
    mutating func reset() {
        self = RecipeFilter()
    }
}
