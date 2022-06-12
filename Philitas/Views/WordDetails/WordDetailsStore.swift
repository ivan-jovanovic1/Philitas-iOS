//
//  WordDetailsStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

class WordDetailsStore<T: WordDetailsLoader & FavoriteUpdater>: ObservableObject, ViewPresentable {
    @Published var presented: PresentedView? = .none
    @Published var state: DataState<T.Item> = .loading
    @Published var showFavoriteButton = false
    @Published var isFavoriteWord = false
    private var favoriteIds: [String] = []
    private let service: T

    init(loader: T) {
        self.service = loader
    }
}

extension WordDetailsStore {
    @MainActor
    @Sendable
    func loadWordDetails() async {
        state = .loading
        do {
            let wordFromResponse: T.Item = try await service.load()
            state = .data(wordFromResponse)
            isFavoriteWord = favoriteIds.contains(wordFromResponse.id)
        }
        catch {
            state = .error(error)
        }
    }
    
    @MainActor
    @Sendable
    func addToFavorites() async {
        do {
            guard let id = state.value?.id else { return }
            isFavoriteWord = try await service.updateFavorites(id: id, shouldBeInFavorites: !isFavoriteWord)
        } catch {
            PHLogger.networking.error("\(error.localizedDescription)")
        }
    }
    
    func processUser(user: SessionLoader.User?) {
        showFavoriteButton = user != nil
        favoriteIds = user?.favoriteWordIds ?? []
    }
}
