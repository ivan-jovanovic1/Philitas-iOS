//
//  WordDetailsModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

class WordDetailsModel: ObservableObject {
    
    @Published private(set) var singleWord: Word
    
    var title: String {
        (singleWord.language == "sl" ? singleWord.word : singleWord.translatedWord ?? singleWord.word).capitalized
    }
    
    var subtitle: String? {
        if singleWord.language == "sl" {
            return singleWord.translatedWord
        }
        return singleWord.word
    }
        
    init(singleWord: Word) {
        self.singleWord = singleWord
    }
    
    func loadWordDetails() {
        
    }

    
}
