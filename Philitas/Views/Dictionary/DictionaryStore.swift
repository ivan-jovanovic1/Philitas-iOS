//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

@MainActor
class DictionaryStore: ObservableObject {
    // MARK: - State

    @Published var words: [ViewModel] = []
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var searchWords: [ViewModel] = []

    // MARK: - Internals

    private let pageSize: Int
    private var pagination: Pagination?
    private let service: any WordServiceRepresentable

    // MARK: - Init

    init(
        pageSize: Int = 25,
        words: [ViewModel] = [],
        service: any WordServiceRepresentable = WordService()
    ) {
        self.pageSize = pageSize
        self.words = words
        self.service = service
    }
}

// MARK: - Actions

extension DictionaryStore {
    @Sendable
    func loadWords() async {
        guard let response = try? await service.words(
            page: pagination?.nextPage(),
            pageSize: pageSize
        ) else {
            return
        }

        words.update(with: Self.map(response))
        pagination = response.pagination
    }

    func searchForWords() {
        guard !searchString.isEmpty else { return }
    }

    func shouldShowNextPage(word: ViewModel) -> Bool {
        return word.id == words.last?.id && pagination?.hasNextPage() ?? false
    }
}
