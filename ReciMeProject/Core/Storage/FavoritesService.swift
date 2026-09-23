//
//  FavoritesService.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

protocol FavoritesServiceProtocol {
    var favoritesPublisher: AnyPublisher<Set<UUID>, Never> { get }
    func getFavorites() -> Set<UUID>
    func isFavorite(_ recipeId: UUID) -> Bool
    func toggleFavorite(_ recipeId: UUID)
    func addFavorite(_ recipeId: UUID)
    func removeFavorite(_ recipeId: UUID)
    func clearAll()
}

final class FavoritesService: FavoritesServiceProtocol {
    private let storageKey = "com.recime.favorites"
    private let favoritesSubject = CurrentValueSubject<Set<UUID>, Never>([])
    
    var favoritesPublisher: AnyPublisher<Set<UUID>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    init() {
        loadFavorites()
    }
    
    func getFavorites() -> Set<UUID> {
        favoritesSubject.value
    }
    
    func isFavorite(_ recipeId: UUID) -> Bool {
        favoritesSubject.value.contains(recipeId)
    }
    
    func toggleFavorite(_ recipeId: UUID) {
        if isFavorite(recipeId) {
            removeFavorite(recipeId)
        } else {
            addFavorite(recipeId)
        }
    }
    
    func addFavorite(_ recipeId: UUID) {
        var favorites = favoritesSubject.value
        favorites.insert(recipeId)
        saveFavorites(favorites)
    }
    
    func removeFavorite(_ recipeId: UUID) {
        var favorites = favoritesSubject.value
        favorites.remove(recipeId)
        saveFavorites(favorites)
    }
    
    func clearAll() {
        saveFavorites([])
    }
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let uuidStrings = try? JSONDecoder().decode([String].self, from: data) else {
            return
        }
        
        let favorites = Set(uuidStrings.compactMap { UUID(uuidString: $0) })
        favoritesSubject.send(favorites)
    }
    
    private func saveFavorites(_ favorites: Set<UUID>) {
        let uuidStrings = favorites.map { $0.uuidString }
        
        if let data = try? JSONEncoder().encode(uuidStrings) {
            UserDefaults.standard.set(data, forKey: storageKey)
            favoritesSubject.send(favorites)
        }
    }
}
