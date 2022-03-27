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
    var pagination: Pagination? = nil {
        didSet {
            print(String(describing: pagination))
        }
    }
    
    @Published var words: [Word] = []
    @Published var wordsFromSearch = false
    @Published var searchString = ""
    @Published var searchWords: [Word] = []
    
    
    init(
        pageSize: Int = 25,
        words: [Word] = []
    ) {
        self.pageSize = pageSize
        self.words = words
    }
    
}

extension DictionaryModel: Queryable {
    var params: [String : Any] {
        [
            "page": pagination?.nextPage() ?? 1,
            "pageSize": pageSize
        ]
    }
}

extension DictionaryModel {
    
    func getWords()  {
        
        let request = AF.request("http://localhost:3002/words/list\(urlParams())")
            .serializingDecodable(BaseResponse.self)
        
        Task {
            
            if let response = await request.response.value {
                print(String(describing: response))
     
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.words.update(with: response.words)
                    self.pagination = response.pagination
                }
            }
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
