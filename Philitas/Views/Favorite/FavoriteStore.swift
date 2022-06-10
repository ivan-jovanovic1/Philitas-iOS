//
//  FavoriteStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

@MainActor
class FavoriteStore<T: FavoriteLoader>: ObservableObject {
    @Published var favorites: DataState<[T.Item]> = .loading
    private let service: T
    
    init(
        service: T
    ) {
        self.service = service
    }
}

extension FavoriteStore {
    @Sendable
    func loadFavorites(refreshing: Bool = false) async {
        if refreshing {
            service.resetPagination()
            favorites = .loading
        }
        
        do {
            favorites = .data(try await service.load())
        } catch {
            favorites = .error(error)
        }
    }
    
    func shouldShowNextPage(word: T.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == favorites.value?.last?.id)
    }
}
