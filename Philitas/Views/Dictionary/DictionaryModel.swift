//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation


@MainActor
class DictionaryModel: ObservableObject {

    // MARK: - State
    
    @Published var words: [ViewModel] = []
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var searchWords: [ViewModel] = []
    
    // MARK: - Internals
    
    private let pageSize: Int
    private var pagination: Pagination? = nil
    private let service: any WordMethods
    
    // MARK: - Init
    
    init(
        pageSize: Int = 25,
        words: [ViewModel] = [],
        service: any WordMethods = WordService()
    ) {
        self.pageSize = pageSize
        self.words = words
        self.service = service
    }
}

// MARK: - Actions

extension DictionaryModel {
    
    @Sendable
    func loadWords() async {
        guard let response = try? await service.words(
            page: pagination?.nextPage(),
            pageSize: pageSize
        ) else {
            return
        }
        
        words = Self.map(response)
    }
    
    func searchForWords() {
        guard !searchString.isEmpty else { return }
    }
    
    func shouldShowNextPage(word: ViewModel) -> Bool {
       return word.id == words.last?.id && pagination?.hasNextPage() ?? false
    }
}

// MARK: - Private

private extension DictionaryModel {
    
    static func map(_ model: Response.BaseResponse<[Response.Word]>) -> [ViewModel] {
        model.data.compactMap { word -> DictionaryModel.ViewModel in
            
            let translations = word.translations?.filter { translation in
                word.language == "sl" ? translation.language != "en" : translation.language != "sl"
            }
            
            return DictionaryModel.ViewModel(
                id: word._id,
                word: word.word,
                language: word.language,
                translation: translations?.first?.word ?? ""
            )
        }
    }

}
