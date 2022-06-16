//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

@MainActor
class DictionaryStore: ObservableObject {
    @Published var words: DataState<[DictionaryLoader.Item]> = .loading
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var wordFromSearch: DataState<DictionaryLoader.Item>? = .none
    private let service: DictionaryLoader & FavoriteUpdater

    init(service: DictionaryLoader & FavoriteUpdater) {
        self.service = service
    }
}

// MARK: - Actions
extension DictionaryStore {
    @Sendable
    func loadWords(refreshing: Bool = false) async {
        if refreshing {
            service.resetPagination()
        }

        do {
            let result = try await service.load()
            if refreshing {
                words = .loading
            }
            guard let values = words.value else {
                return words = .data(result)
            }
            words = .data(values + result)
        }
        catch {
            words = .error(error)
        }
    }
    
    func addToFavorites(word: DictionaryLoader.Item) {
        Task {
            try await service.updateFavorites(id: word.id, shouldBeInFavorites: true)
        }
    }
    
    func shouldShowNextPage(word: DictionaryLoader.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == words.value?.last?.id)
    }
}
