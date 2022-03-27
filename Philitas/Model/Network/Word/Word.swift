//
//  Word.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

struct Word: Decodable, Identifiable {
    
    let _id: String
    /// The word in its main language
    let word: String
    /// The word translated to English or Slovene based on property `language`
    let translatedWord: String?
    /// The word main language
    let language: String
    /// An array of all dictionaries with their explanations
    let dictionaryExplanations: [DictionaryExplanation]
    /// An array of search hit counts per month.
    let searchHits: [SearchHit]
    
    var id: String {
        self.word
    }
}

// MARK: - Equatable conformation
extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
}

extension Word: Comparable {
    static func <(lhs: Word, rhs: Word) -> Bool {
        return lhs.word < rhs.word
    }
}


extension Word: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}
