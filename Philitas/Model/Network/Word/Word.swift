//
//  Word.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import Foundation

extension Response {
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

        var id: String {
            word
        }
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
