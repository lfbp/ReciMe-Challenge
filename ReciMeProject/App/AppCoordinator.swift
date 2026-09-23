import SwiftUI
import Combine

/// App-level navigation for the ReciMe home app (MVVM-C).
final class AppCoordinator: ObservableObject, ParentCoordinator {
    enum Route: Equatable {
        case login
        case main(User)
    }
    
    @Published private(set) var route: Route = .login
    @Published private(set) var loginCoordinator: LoginCoordinator?
    @Published private(set) var recipeListCoordinator: RecipeListCoordinator?
    @Published private(set) var favoritesCoordinator: FavoritesCoordinator?
    
    var childCoordinators: [any Coordinator] = []
    
    private let appDependencies: AppDependencies
    private var didStart = false
    
    init(appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
    }
    
    func start() {
        guard !didStart else { return }
        didStart = true
        showLogin()
    }
    
    private func showLogin() {
        clearMainTabs()
        
        let loginCoordinator = LoginCoordinator(dependencies: appDependencies)
        loginCoordinator.onLoginSuccess = { [weak self] user in
            self?.showMainTab(user: user)
        }
        // Start before publishing so viewModel is ready on first render.
        loginCoordinator.start()
        addChild(loginCoordinator)
        self.loginCoordinator = loginCoordinator
        route = .login
    }
    
    private func showMainTab(user: User) {
        if let loginCoordinator {
            removeChild(loginCoordinator)
            self.loginCoordinator = nil
        }
        
        let recipeListCoordinator = RecipeListCoordinator(dependencies: appDependencies)
        recipeListCoordinator.start()
        addChild(recipeListCoordinator)
        
        let favoritesCoordinator = FavoritesCoordinator(dependencies: appDependencies)
        favoritesCoordinator.start()
        addChild(favoritesCoordinator)
        
        // Publish only after both tabs are started.
        self.recipeListCoordinator = recipeListCoordinator
        self.favoritesCoordinator = favoritesCoordinator
        route = .main(user)
    }
    
    private func clearMainTabs() {
        if let recipeListCoordinator {
            removeChild(recipeListCoordinator)
            self.recipeListCoordinator = nil
        }
        if let favoritesCoordinator {
            removeChild(favoritesCoordinator)
            self.favoritesCoordinator = nil
        }
    }
}
