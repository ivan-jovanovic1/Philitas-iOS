//
//  DictionaryStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Alamofire
import Foundation

class DictionaryModel: ObservableObject, Pageable {
    let pageSize: Int
    var pagination: Pagination? = nil
    
    @Published var words: [Word] = []
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var searchWords: [Word] = []

    let service: any WordServiceable
    
    init(
        pageSize: Int = 25,
        words: [Word] = [],
        service: any WordServiceable = WordService()
    ) {
        self.pageSize = pageSize
        self.words = words
        self.service = service
    }
    
}

extension DictionaryModel {
    
    func loadWords()  {
        
        service.list(
            page: pagination?.nextPage(),
            pageSize: pageSize
        ) { [weak self] in
            if let response = $0 {
                self?.words.update(with: response.words)
                self?.pagination = response.pagination
            }
            
            self?.handleError($1)
        }
        
        
    }
    
    func searchForWords() {
        
        let request = AF.request("http://localhost:3002/words/nekaj/1")
            .serializingDecodable(Word.self)
        
        Task {

            if let word = await request.response.value {
                DispatchQueue.main.async { [weak self] in
                    self?.searchWords.append(word)
                }
            }
        }
    }
    
    func shouldShowNextPage(word: Word) -> Bool {
//        print("\(pagination?.hasNextPage() as Any) and \(word.id == words.last?.id)")
       return word.id == words.last?.id && pagination?.hasNextPage() ?? false
    }
    
}


extension DictionaryModel {
    
    private func handleError(_ error: AFError?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
