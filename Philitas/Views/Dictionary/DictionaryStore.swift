//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

@MainActor
class DictionaryStore<T: DictionaryLoader & DictionaryUpdater>: ObservableObject {

    // MARK: - State
    @Published var words: DataState<[T.Item]> = .loading
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var wordFromSearch: DataState<T.Item>? = .none

    private let service: T

    init(
        service: T
    ) {
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
            words = .data(values.update(with: result))
        }
        catch {
            words = .error(error)
        }
    }
    
    func addToFavorites(word: T.Item) {
        Task {
            try await service.addToFavorites(id: word._id)
        }
    }

    //    func searchForWord() async {
    //        guard !searchString.isEmpty else { return }
    //        //        wordFromSearch = .loading
    //
    //        do {
    //            //            let response = try await service.singleWord(query: searchString)
    //            //            wordFromSearch = .data(Self.mapSingle(response.data))
    //        }
    //        catch {
    //            wordFromSearch = .error(error)
    //        }
    //    }

    func resetSearchState() {
        searchString = ""
        //        wordFromSearch = .none
    }

    func shouldShowNextPage(word: T.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == words.value?.last?.id)
    }
}
