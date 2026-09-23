//
//  FeatureDependencies.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

/// Narrow deps for the login flow — no recipe/favorites access.
protocol LoginDependencies {
    var authService: AuthServiceProtocol { get }
    var observability: ObservabilityManager { get }
}

/// Shared deps for home tabs that browse recipes.
protocol HomeTabDependencies {
    var recipeService: RecipeServiceProtocol { get }
    var favoritesService: FavoritesServiceProtocol { get }
    var observability: ObservabilityManager { get }
    var errorHandler: ErrorHandler { get }
}

typealias RecipeListDependencies = HomeTabDependencies
typealias FavoritesDependencies = HomeTabDependencies
