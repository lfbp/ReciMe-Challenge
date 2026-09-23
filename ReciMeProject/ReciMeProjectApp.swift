//
//  ReciMeProjectApp.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

@main
struct ReciMeProjectApp: App {
    private let appDependencies: AppDependencies
    
    @StateObject private var appCoordinator: AppCoordinator
    @StateObject private var errorPresenter: ErrorPresenter
    
    init() {
        let appDeps = AppDependencies(observability: ObservabilityManager())
        self.appDependencies = appDeps
        self._errorPresenter = StateObject(wrappedValue: ErrorPresenter(errorHandler: appDeps.errorHandler))
        let coordinator = AppCoordinator(appDependencies: appDeps)
        self._appCoordinator = StateObject(wrappedValue: coordinator)
        coordinator.start()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.route {
                case .login:
                    if let viewModel = appCoordinator.loginCoordinator?.viewModel {
                        LoginView(viewModel: viewModel)
                    } else {
                        ProgressView()
                    }
                case .main:
                    if let recipeList = appCoordinator.recipeListCoordinator,
                       let favorites = appCoordinator.favoritesCoordinator {
                        MainTabView(
                            recipeListCoordinator: recipeList,
                            favoritesCoordinator: favorites
                        )
                    } else {
                        ProgressView()
                    }
                }
            }
            .environmentObject(errorPresenter)
            .errorHandling(errorPresenter: errorPresenter)
        }
    }
}
