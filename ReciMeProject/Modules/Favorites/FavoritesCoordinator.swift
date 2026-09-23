import SwiftUI
import Combine

final class FavoritesCoordinator: ObservableObject, Coordinator {
    private let dependencies: FavoritesDependencies
    @Published var navigationPath = NavigationPath()
    private(set) var viewModel: FavoritesViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: FavoritesDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = FavoritesViewModel(
            recipeService: dependencies.recipeService,
            favoritesService: dependencies.favoritesService,
            observability: dependencies.observability,
            errorHandler: dependencies.errorHandler
        )
        self.viewModel = viewModel
        
        viewModel.$selectedRecipe
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipe in
                self?.showRecipeDetail(recipe)
                self?.viewModel?.selectedRecipe = nil
            }
            .store(in: &cancellables)
    }
    
    func detailView(for recipe: Recipe) -> RecipeDetailView {
        RecipeDetailView(
            viewModel: RecipeDetailViewModel(
                recipe: recipe,
                favoritesService: self.dependencies.favoritesService,
                recipeService: self.dependencies.recipeService,
                observability: self.dependencies.observability,
                errorHandler: self.dependencies.errorHandler
            )
        )
    }
    
    private func showRecipeDetail(_ recipe: Recipe) {
        navigationPath.append(recipe)
    }
}

struct FavoritesFlowView: View {
    @ObservedObject var coordinator: FavoritesCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                if let viewModel = coordinator.viewModel {
                    FavoritesView(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationDestination(for: Recipe.self) { recipe in
                coordinator.detailView(for: recipe)
            }
        }
    }
}

#if DEBUG
#Preview("Favorites Flow") {
    FavoritesFlowPreviewHost()
}

private struct FavoritesFlowPreviewHost: View {
    @StateObject private var coordinator: FavoritesCoordinator
    
    init() {
        let deps = PreviewSupport.makeAppDependencies()
        let coordinator = FavoritesCoordinator(dependencies: deps.favorites)
        coordinator.start()
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        FavoritesFlowView(coordinator: coordinator)
    }
}
#endif
