//
//  RecipeListViewModel.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

final class RecipeListViewModel: BaseViewModel {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var filter: RecipeFilter = RecipeFilter()
    @Published var searchText: String = ""
    @Published var favoriteIds: Set<UUID> = []
    @Published var selectedRecipe: Recipe?
    @Published private(set) var availableCuisines: [String] = []
    
    let recipeService: RecipeServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    let observability: ObservabilityManager
    let errorHandler: ErrorHandler
    private let screenName = "RecipeList"
    
    /// Triggers a fresh API request. Use empty filter for initial load.
    private let reloadSubject = PassthroughSubject<RecipeFilter, Never>()
    
    var activeFilterCount: Int {
        var count = 0
        if !filter.dietaryAttributes.isEmpty { count += 1 }
        if filter.difficulty != nil { count += 1 }
        if filter.cuisine != nil { count += 1 }
        if filter.servings != nil { count += 1 }
        if filter.maxPrepTime != nil { count += 1 }
        return count
    }
    
    init(
        recipeService: RecipeServiceProtocol,
        favoritesService: FavoritesServiceProtocol,
        observability: ObservabilityManager,
        errorHandler: ErrorHandler
    ) {
        self.recipeService = recipeService
        self.favoritesService = favoritesService
        self.observability = observability
        self.errorHandler = errorHandler
        super.init()
        setupBindings()
        observability.analytics.track(event: .screenViewed(screenName: screenName))
        observability.impressions.trackImpression(
            contentId: screenName,
            contentType: "screen",
            metadata: [:]
        )
    }
    
    private func setupBindings() {
        favoritesService.favoritesPublisher
            .assign(to: &$favoriteIds)
        
        // Debounced search text → API (drop initial "" before debounce so the
        // first real keystroke is not swallowed when tests/UI set text quickly).
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.reloadFromAPI(reason: .search)
            }
            .store(in: &cancellables)
        
        reloadSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.errorMessage = nil
            })
            .map { [weak self] requestFilter -> AnyPublisher<Result<(recipes: [Recipe], filter: RecipeFilter), Error>, Never> in
                guard let self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.recipeService.searchRecipes(with: requestFilter)
                    .map { Result.success(($0, requestFilter)) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let payload):
                    self.recipes = payload.recipes
                    self.mergeCuisines(from: payload.recipes, requestFilter: payload.filter)
                    self.observability.analytics.track(
                        event: .custom(
                            name: "recipes_loaded",
                            parameters: [
                                "count": payload.recipes.count,
                                "has_search": !payload.filter.searchText.isEmpty,
                                "has_filters": payload.filter.hasActiveFilters
                            ]
                        )
                    )
                case .failure(let error):
                    self.errorMessage = "Failed to load recipes"
                    self.errorHandler.handle(
                        error,
                        context: ErrorContext(screen: self.screenName, action: "search_recipes"),
                        presentToUser: true
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private enum ReloadReason {
        case initial
        case search
        case filter
    }
    
    func loadRecipes() {
        reloadFromAPI(reason: .initial)
    }
    
    func selectRecipe(_ recipe: Recipe) {
        selectedRecipe = recipe
        observability.analytics.track(
            event: .recipeViewed(recipeId: recipe.id.uuidString, recipeName: recipe.title)
        )
    }
    
    func trackRecipeImpression(_ recipe: Recipe) {
        observability.impressions.trackImpression(
            contentId: recipe.id.uuidString,
            contentType: "recipe",
            metadata: ["title": recipe.title]
        )
    }
    
    func toggleFavorite(_ recipeId: UUID) {
        favoritesService.toggleFavorite(recipeId)
        
        if let recipe = recipes.first(where: { $0.id == recipeId }) {
            let wasFavorite = !favoriteIds.contains(recipeId)
            let event: AnalyticsEvent = wasFavorite
                ? .recipeFavorited(recipeId: recipeId.uuidString, recipeName: recipe.title)
                : .recipeUnfavorited(recipeId: recipeId.uuidString, recipeName: recipe.title)
            observability.analytics.track(event: event)
        }
    }
    
    func isFavorite(_ recipeId: UUID) -> Bool {
        favoriteIds.contains(recipeId)
    }
    
    func resetFilterOptions() {
        filter.reset()
        reloadFromAPI(reason: .filter)
    }
    
    func applyFilterNow() {
        if filter.hasActiveFilters {
            let value = filter.dietaryAttributes.map(\.rawValue).joined(separator: ",")
            observability.analytics.track(
                event: .filterApplied(
                    filterType: "sheet",
                    value: value.isEmpty ? "active" : value
                )
            )
        }
        reloadFromAPI(reason: .filter)
    }
    
    private func reloadFromAPI(reason: ReloadReason) {
        var request = filter
        request.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if reason == .search, !request.searchText.isEmpty {
            // resultsCount filled after response; track intent here
            observability.analytics.track(
                event: .recipeSearched(query: request.searchText, resultsCount: -1)
            )
        }
        
        reloadSubject.send(request)
    }
    
    private func mergeCuisines(from recipes: [Recipe], requestFilter: RecipeFilter) {
        // Prefer full cuisine list from unfiltered responses; otherwise accumulate.
        let incoming = Set(recipes.map(\.cuisine))
        if !requestFilter.hasActiveFilters && requestFilter.searchText.isEmpty {
            availableCuisines = incoming.sorted()
        } else if availableCuisines.isEmpty {
            availableCuisines = incoming.sorted()
        }
    }
}
