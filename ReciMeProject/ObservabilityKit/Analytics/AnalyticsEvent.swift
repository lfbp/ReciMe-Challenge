//
//  AnalyticsEvent.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

enum AnalyticsEvent {
    // User Actions
    case userLogin(username: String)
    case userLogout
    case recipeViewed(recipeId: String, recipeName: String)
    case recipeSearched(query: String, resultsCount: Int)
    case filterApplied(filterType: String, value: String)
    case recipeFavorited(recipeId: String, recipeName: String)
    case recipeUnfavorited(recipeId: String, recipeName: String)
    
    // Screen Views
    case screenViewed(screenName: String)
    case screenDismissed(screenName: String, timeSpent: TimeInterval)
    
    // User Engagement
    case buttonTapped(buttonName: String, screenName: String)
    case linkClicked(url: String)
    case shareInitiated(contentType: String, contentId: String)
    
    // Custom
    case custom(name: String, parameters: [String: Any])
    
    var name: String {
        switch self {
        case .userLogin: return "user_login"
        case .userLogout: return "user_logout"
        case .recipeViewed: return "recipe_viewed"
        case .recipeSearched: return "recipe_searched"
        case .filterApplied: return "filter_applied"
        case .recipeFavorited: return "recipe_favorited"
        case .recipeUnfavorited: return "recipe_unfavorited"
        case .screenViewed: return "screen_viewed"
        case .screenDismissed: return "screen_dismissed"
        case .buttonTapped: return "button_tapped"
        case .linkClicked: return "link_clicked"
        case .shareInitiated: return "share_initiated"
        case .custom(let name, _): return name
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .userLogin(let username):
            return ["username": username]
            
        case .userLogout:
            return [:]
            
        case .recipeViewed(let recipeId, let recipeName):
            return [
                "recipe_id": recipeId,
                "recipe_name": recipeName
            ]
            
        case .recipeSearched(let query, let resultsCount):
            return [
                "query": query,
                "results_count": resultsCount
            ]
            
        case .filterApplied(let filterType, let value):
            return [
                "filter_type": filterType,
                "value": value
            ]
            
        case .recipeFavorited(let recipeId, let recipeName):
            return [
                "recipe_id": recipeId,
                "recipe_name": recipeName,
                "action": "add"
            ]
            
        case .recipeUnfavorited(let recipeId, let recipeName):
            return [
                "recipe_id": recipeId,
                "recipe_name": recipeName,
                "action": "remove"
            ]
            
        case .screenViewed(let screenName):
            return ["screen_name": screenName]
            
        case .screenDismissed(let screenName, let timeSpent):
            return [
                "screen_name": screenName,
                "time_spent_seconds": timeSpent
            ]
            
        case .buttonTapped(let buttonName, let screenName):
            return [
                "button_name": buttonName,
                "screen_name": screenName
            ]
            
        case .linkClicked(let url):
            return ["url": url]
            
        case .shareInitiated(let contentType, let contentId):
            return [
                "content_type": contentType,
                "content_id": contentId
            ]
            
        case .custom(_, let parameters):
            return parameters
        }
    }
}
