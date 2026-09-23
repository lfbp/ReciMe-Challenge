//
//  AppDependencies.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

/// App-level composition root.
/// Owns shared services; feature coordinators receive narrow protocol views.
final class AppDependencies {
    /// Created at launch — used by logging/analytics across the app.
    let observability: ObservabilityManager
    
    /// Built on first access (ErrorPresenter / feature flows).
    lazy var errorHandler: ErrorHandler = ErrorHandler(observability: observability)
    
    lazy var networkService: NetworkServiceProtocol = NetworkService(observability: observability)
    
    lazy var recipeService: RecipeServiceProtocol = RecipeService(networkService: networkService)
    
    lazy var favoritesService: FavoritesServiceProtocol = FavoritesService()
    
    lazy var authService: AuthServiceProtocol = MockAuthService()
    
    init(observability: ObservabilityManager) {
        self.observability = observability
        observability.configure()
    }
}

extension AppDependencies: LoginDependencies, HomeTabDependencies {}
