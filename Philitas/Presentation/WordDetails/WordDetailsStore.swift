//
//  WordDetailsStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

class WordDetailsStore: ObservableObject, ViewPresentable {
    @Published var presented: PresentedView? = .none
    @Published var state: DataState<WordDetailsLoader.Item> = .loading
    @Published var showFavoriteButton = false
    private var favoriteIds: [String] = []
    private let service: WordDetailsLoader & FavoriteUpdater

    init(service: WordDetailsLoader & FavoriteUpdater) {
        self.service = service
    }
}

extension WordDetailsStore {
    @MainActor
    @Sendable
    func loadWordDetails() async {
        state = .loading
        do {
            let wordFromResponse = try await service.load()
            state = .data(wordFromResponse)
        }
        catch {
            state = .error(error)
        }
    }
    
    @MainActor
    @Sendable
    func addToFavorites() async {
        do {
            guard let word = state.value else { return }
            _ = try await service.updateFavorites(id: word.id, shouldBeInFavorites: !word.isFavorite)
            await loadWordDetails()
        } catch {
            PHLogger.networking.error("\(error.localizedDescription)")
        }
    }
    
    func processUser(user: SessionLoader.User?) {
        showFavoriteButton = user != nil
        favoriteIds = user?.favoriteWordIds ?? []
    }
}
