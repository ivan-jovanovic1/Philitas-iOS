//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

@MainActor
class DictionaryStore: ObservableObject {
    @Published var allWords: DataState<[DictionaryLoader.Item]> = .loading
    @Published var searchWords: DataState<[DictionaryLoader.Item]>?
    @Published var searchString = ""
    @Published var wordFromSearch: DataState<DictionaryLoader.Item>? = .none {
        didSet  {
            
        }
    }
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
                allWords = .loading
            }
            guard let values = allWords.value else {
                return allWords = .data(result.sorted(by: { $0.name < $1.name }))
            }
            allWords = .data( Array(Set(values + result)) .sorted(by: { $0.name < $1.name }))
        }
        catch {
            allWords = .error(error)
        }
    }
    
    @Sendable
    func performSearch() async {
        guard !searchString.isEmpty else { return searchWords = .none }
        
        do {
            let words = try await service.loadFromSearch(query: searchString)
            searchWords = .data(Array(Set(words)).sorted(by: {$0.name < $1.name }))
        } catch {
            searchWords = .error(error)
        }
    }
    
    func addToFavorites(word: DictionaryLoader.Item) {
        Task {
            try await service.updateFavorites(id: word.id, shouldBeInFavorites: true)
        }
    }
    
    func shouldShowNextPage(word: DictionaryLoader.Item) -> Bool {
        
        service.shouldShowNextPage(isLastWord: word.id == allWords.value?.last?.id) && searchWords == .none
    }
    

}
