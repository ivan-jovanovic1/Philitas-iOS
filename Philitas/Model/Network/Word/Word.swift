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
        let word: String
        /// The word translated to other languages.
        let translations: [Translation]?
        /// The word main language
        let language: String
        /// An array of all dictionaries with their explanations
        let dictionaryExplanations: [DictionaryExplanation]
        /// An array of search hit counts per month.
        let searchHits: [SearchHit]

        public var id: String {
            _id
        }
    }
}

extension Response.Word: Hashable {
    public static func == (lhs: Response.Word, rhs: Response.Word) -> Bool {
        lhs._id == rhs._id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }

}

#if DEBUG
    extension Response.Word {
        static var dummy: Response.Word {
            Response.Word(
                _id: UUID().uuidString,
                word: UUID().uuidString,
                translations: [
                    Translation(language: "en", word: UUID().uuidString),
                    Translation(language: "de", word: UUID().uuidString),
                ],
                language: "sl",
                dictionaryExplanations: [.dummy, .dummy, .dummy],
                searchHits: []
            )
        }
    }
#endif
