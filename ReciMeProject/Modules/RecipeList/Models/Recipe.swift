//
//  Recipe.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let servings: Int
    let prepTime: Int           // minutes
    let cookTime: Int           // minutes
    let ingredients: [String]
    let instructions: [String]
    let dietaryAttributes: [DietaryAttribute]
    let cuisine: String
    let difficulty: Difficulty
    let imageURL: String?
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        
        var displayName: String {
            rawValue.capitalized
        }
    }
    
    var totalTime: Int {
        prepTime + cookTime
    }
    
    var isVegetarian: Bool {
        dietaryAttributes.contains(.vegetarian) || dietaryAttributes.contains(.vegan)
    }
    
    var isVegan: Bool {
        dietaryAttributes.contains(.vegan)
    }
    
    var isGlutenFree: Bool {
        dietaryAttributes.contains(.glutenFree)
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
