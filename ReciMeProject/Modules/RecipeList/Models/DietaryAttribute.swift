//
//  DietaryAttribute.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

enum DietaryAttribute: String, Codable, CaseIterable, Identifiable {
    // Lifestyle & Religious
    case vegan = "vegan"
    case vegetarian = "vegetarian"
    case halal = "halal"
    case kosher = "kosher"
    case organic = "organic"
    
    // Allergen-Free
    case glutenFree = "glutenFree"
    case dairyFree = "dairyFree"
    case nutFree = "nutFree"
    case soyFree = "soyFree"
    
    // Nutritional Focus
    case ketoFriendly = "ketoFriendly"
    case lowSodium = "lowSodium"
    case noAddedSugar = "noAddedSugar"
    case highProtein = "highProtein"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .vegan: return "Vegan"
        case .vegetarian: return "Vegetarian"
        case .halal: return "Halal"
        case .kosher: return "Kosher"
        case .organic: return "Organic"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        case .soyFree: return "Soy-Free"
        case .ketoFriendly: return "Keto-Friendly"
        case .lowSodium: return "Low-Sodium"
        case .noAddedSugar: return "No Added Sugar"
        case .highProtein: return "High-Protein"
        }
    }
    
    var color: Color {
        switch self {
        case .vegan:
            return ColorTokens.veganColor
        case .vegetarian:
            return ColorTokens.vegetarianColor
        case .halal, .kosher:
            return ColorTokens.halalColor
        case .organic:
            return ColorTokens.organicColor
        case .glutenFree:
            return ColorTokens.glutenFreeColor
        case .dairyFree, .nutFree, .soyFree:
            return ColorTokens.warning
        case .ketoFriendly:
            return ColorTokens.ketoColor
        case .lowSodium, .noAddedSugar:
            return ColorTokens.success
        case .highProtein:
            return ColorTokens.accentRed
        }
    }
    
    var icon: String {
        switch self {
        case .vegan:
            return "leaf.fill"
        case .vegetarian:
            return "leaf"
        case .halal:
            return "moon.fill"
        case .kosher:
            return "star.fill"
        case .organic:
            return "sparkles"
        case .glutenFree:
            return "g.circle.fill"
        case .dairyFree:
            return "cup.and.saucer.fill"
        case .nutFree:
            return "bolt.slash.fill"
        case .soyFree:
            return "s.circle.fill"
        case .ketoFriendly:
            return "flame.fill"
        case .lowSodium:
            return "heart.fill"
        case .noAddedSugar:
            return "x.circle.fill"
        case .highProtein:
            return "figure.strengthtraining.traditional"
        }
    }
    
    var description: String {
        switch self {
        case .vegan:
            return "No animal-derived ingredients"
        case .vegetarian:
            return "No meat, poultry, or seafood"
        case .halal:
            return "Prepared per Islamic dietary laws"
        case .kosher:
            return "Prepared per Jewish dietary laws"
        case .organic:
            return "Grown without synthetic pesticides"
        case .glutenFree:
            return "No wheat, barley, or rye"
        case .dairyFree:
            return "No milk or milk products"
        case .nutFree:
            return "Free of peanuts and tree nuts"
        case .soyFree:
            return "No soybeans or soy derivatives"
        case .ketoFriendly:
            return "High fat, low carb"
        case .lowSodium:
            return "Reduced salt content"
        case .noAddedSugar:
            return "No extra sugar added"
        case .highProtein:
            return "Elevated protein content"
        }
    }
}
