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

    @Published var words: DataState<[ViewModel]> = .loading
    @Published var wordsFromSearch = false
    @Published var searchString = ""

    @Published var wordFromSearch: DataState<ViewModel>? = .none

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
        self.words = .loading
        self.service = service
    }
}

// MARK: - Actions

extension DictionaryStore {
    @Sendable
    func loadWords(refreshing: Bool = false) async {
        if refreshing {
            pagination = nil
        }

        do {
            let response = try await service.words(
                page: pagination?.nextPage(),
                pageSize: pageSize
            )

            if refreshing {
                words = .loading
            }
            
            processLoadWordsResponse(response)
        } catch {
            words = .error(error)
        }
    }

    func searchForWord() async {
        guard !searchString.isEmpty else { return }

        wordFromSearch = .loading
        
        do {
            let response = try await service.singleWord(query: searchString)
            wordFromSearch = .data(Self.mapSingle(response.data))
        } catch {
            wordFromSearch = .error(error)
        }
    }

    func shouldShowNextPage(word: ViewModel) -> Bool {
        return word.id == words.value?.last?.id && pagination?.hasNextPage() ?? false
    }
}


extension DictionaryStore {
    private func processLoadWordsResponse(_ response: Response.BaseResponse<[Response.Word]>) {
        if let values = words.value {
            words = .data(values.update(with: Self.map(response.data).sortByLanguage()))
        } else {
            words = .data(Self.map(response.data).sortByLanguage())
        }
        pagination = response.pagination
    }
}
