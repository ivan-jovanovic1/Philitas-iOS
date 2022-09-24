//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

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
    @MainActor
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
                return allWords = .data(result)
            }
            allWords = .data(Array(Set(values + result).sorted(by: {$0.name.lowercased() < $1.name.lowercased() })))
        }
        catch {
            allWords = .error(error)
        }
    }
    
    @MainActor
    @Sendable
    func performSearch() async {
        guard !searchString.isEmpty else { return searchWords = .none }
        searchWords = .loading
        
        do {
            let words = try await service.loadFromSearch(query: searchString)
            searchWords = .data(Array(Set(words)).sorted(by: {$0.name.lowercased() < $1.name.lowercased() }))
        } catch {
            searchWords = .error(error)
        }
    }
    
    func addToFavorites(wordId: String) {
        Task {
            try await service.updateFavorites(id: wordId, shouldBeInFavorites: true)
        }
    }
    
    func shouldShowNextPage(wordId: String) -> Bool {
        service.shouldShowNextPage(isLastWord: wordId == allWords.value?.last?.id) && searchWords == .none
    }
    
}
