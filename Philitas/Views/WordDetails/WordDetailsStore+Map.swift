//
//  WordDetailsMap.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation

extension WordDetailsStore {
    static func map(_ word: Response.Word) -> ViewModel {
        ViewModel(
            id: word._id,
            word: word.word,
            translations: word.translations ?? [],
            language: word.language,
            dictionaries: Self.mapDictionaries(word.dictionaryExplanations)
        )
    }

    static func mapDictionaries(_ dictionaries: [Response.DictionaryExplanation]) -> [Dictionary] {
        dictionaries.map {
            return Dictionary(
                explanations: $0.explanations,
                dictionaryName: $0.dictionaryName,
                source: $0.source
            )
        }
    }
}
