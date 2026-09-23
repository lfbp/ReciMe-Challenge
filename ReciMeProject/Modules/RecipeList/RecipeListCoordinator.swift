import SwiftUI
import Combine

final class RecipeListCoordinator: ObservableObject, Coordinator {
    private let dependencies: RecipeListDependencies
    @Published var navigationPath = NavigationPath()
    private(set) var viewModel: RecipeListViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: RecipeListDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = RecipeListViewModel(
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

struct RecipeListFlowView: View {
    @ObservedObject var coordinator: RecipeListCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                if let viewModel = coordinator.viewModel {
                    RecipeListView(viewModel: viewModel)
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
#Preview("Recipe List Flow") {
    RecipeListFlowPreviewHost()
}

private struct RecipeListFlowPreviewHost: View {
    @StateObject private var coordinator: RecipeListCoordinator
    
    init() {
        let deps = PreviewSupport.makeAppDependencies()
        let coordinator = RecipeListCoordinator(dependencies: deps.recipeList)
        coordinator.start()
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        RecipeListFlowView(coordinator: coordinator)
    }
}
#endif
