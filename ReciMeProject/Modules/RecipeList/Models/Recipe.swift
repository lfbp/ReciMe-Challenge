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

#if DEBUG
extension Recipe {
    static let preview = Recipe(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        title: "Margherita Pizza",
        description: "Classic Neapolitan pizza with tomato, mozzarella, and fresh basil.",
        servings: 2,
        prepTime: 20,
        cookTime: 12,
        ingredients: [
            "250g pizza dough",
            "100g tomato sauce",
            "125g fresh mozzarella",
            "Fresh basil leaves",
            "Olive oil"
        ],
        instructions: [
            "Preheat oven to 250°C (480°F).",
            "Stretch the dough into a thin round.",
            "Spread tomato sauce, tear mozzarella over the top.",
            "Bake until the crust is blistered, then finish with basil and olive oil."
        ],
        dietaryAttributes: [.vegetarian],
        cuisine: "Italian",
        difficulty: .easy,
        imageURL: nil
    )
    
    static let previewAlt = Recipe(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        title: "Avocado Toast",
        description: "Creamy avocado on toasted sourdough with chili flakes.",
        servings: 1,
        prepTime: 5,
        cookTime: 5,
        ingredients: [
            "1 ripe avocado",
            "2 slices sourdough",
            "Chili flakes",
            "Salt and pepper"
        ],
        instructions: [
            "Toast the bread.",
            "Mash avocado with salt and pepper.",
            "Spread on toast and sprinkle chili flakes."
        ],
        dietaryAttributes: [.vegan, .vegetarian],
        cuisine: "American",
        difficulty: .easy,
        imageURL: nil
    )
    
    static let previews: [Recipe] = [preview, previewAlt]
}
#endif
