//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation


@MainActor
class DictionaryModel: ObservableObject {
    let pageSize: Int
    var pagination: Pagination? = nil
    
    @Published var words: [ViewModel] = []
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var searchWords: [Response.Word] = []

    let service: any WordMethods
    
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

extension DictionaryModel {
    
    @Sendable
    func loadWords() async {
        do {
            let response = try await service.words(page: pagination?.nextPage(), pageSize: pageSize)
            words = Self.map(response)
            
        } catch let error as Networking.NetworkError {
            PHLogger.networking.error("\(error.description)")
        } catch {
            print("Unknown error: \(error.localizedDescription)")
        }
    }
    
    func searchForWords() {
        guard !searchString.isEmpty else { return }
        
        //        let request = AF.request("http://localhost:3002/words/nekaj/1")
//            .serializingDecodable(Response.Word.self)
//
//        Task {
//
//            if let word = await request.response.value {
//                DispatchQueue.main.async { [weak self] in
//                    self?.searchWords.append(word)
//                }
//            }
//        }
    }
    
    func shouldShowNextPage(word: ViewModel) -> Bool {
//        print("\(pagination?.hasNextPage() as Any) and \(word.id == words.last?.id)")
       return word.id == words.last?.id && pagination?.hasNextPage() ?? false
    }
    
}

extension DictionaryModel {
    struct ViewModel: Identifiable {
        let id: String
        let word: String
        let language: String
        let translation: String
    }
}


private extension DictionaryModel {
    
    static func map(_ model: Response.BaseResponse<[Response.Word]>) -> [ViewModel] {
        return model.data.compactMap { word -> DictionaryModel.ViewModel in
            
            let translations = word.translations?.filter { translation in  word.language == "sl" ? translation.language != "en" : translation.language != "sl" }
            
            return DictionaryModel.ViewModel(id: word._id, word: word.word, language: word.language, translation: translations?.first?.word ?? "")
            
        }
    }

}
