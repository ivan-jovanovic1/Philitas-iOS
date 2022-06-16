//
//  FavoriteStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

@MainActor
class FavoriteStore: ObservableObject {
    weak var session: Session?
    @Published var favorites: DataState<[FavoriteLoader.Item]> = .loading
    private let service: FavoriteLoader
    
    init(service: FavoriteLoader) {
        self.service = service
    }
}

extension FavoriteStore {
    @Sendable
    func loadFavorites(refreshing: Bool = false) async {
        if refreshing {
            service.resetPagination()
        }
        
        do {
            favorites = .data(try await service.load())
        } catch {
            favorites = .error(error)
        }
    }
    
    func shouldShowNextPage(word: FavoriteLoader.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == favorites.value?.last?.id)
    }
    
    @MainActor
    func processStateAfterWordDetailsDisappear(id: String) {
        Task {
            await loadFavorites(refreshing: true)
         }
    }
}
