//
//  Word.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import Foundation

public extension Response {
    struct Word: Decodable, Identifiable {
        let _id: String
        /// The word in its main language
        let name: String
        /// The word translated to other languages.
        let translation: Translation?
        /// The word main language
        let language: String
        
        public var id: String {
            _id
        }
    }
    
    struct WordDetails: Decodable, Identifiable {
        public let id: String
        /// The word in its main language
        let word: String
        /// The word translated to other languages.
        let translations: [Translation]?
        /// The word main language
        let language: String
        /// An array of all dictionaries with their explanations
        let dictionaryExplanations: [DictionaryExplanation]
        
        let isFavorite: Bool

    }
}

extension Response.Word: Hashable {
    public static func == (lhs: Response.Word, rhs: Response.Word) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}


extension Response.WordDetails: Hashable {
    public static func == (lhs: Response.WordDetails, rhs: Response.WordDetails) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}


#if DEBUG
    extension Response.Word {
        static var dummy: Response.Word {
            Response.Word(
                _id: UUID().uuidString,
                name: UUID().uuidString,
                translation: Translation(language: "de", word: UUID().uuidString),
                language: "sl"
            )
        }
    }

extension Response.WordDetails {
    static var dummy: Response.WordDetails {
        Response.WordDetails(
            id: UUID().uuidString,
            word: UUID().uuidString,
            translations: [
                Translation(language: "en", word: UUID().uuidString),
                Translation(language: "de", word: UUID().uuidString),
            ],
            language: "sl",
            dictionaryExplanations: [.dummy, .dummy, .dummy],
            isFavorite: false
        )
    }
}
#endif
