//
//  WordListStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

@MainActor
class WordListStore: ObservableObject {
    weak var session: Session?
    @Published var favorites: DataState<[WordListLoader.Item]> = .loading
    private let service: WordListLoader
    
    init(service: WordListLoader) {
        self.service = service
    }
}

extension WordListStore {
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
    
    func shouldShowNextPage(word: WordListLoader.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == favorites.value?.last?.id)
    }
    
    @MainActor
    func processStateAfterWordDetailsDisappear(id: String) {
        Task {
            await loadFavorites(refreshing: true)
         }
    }
}
