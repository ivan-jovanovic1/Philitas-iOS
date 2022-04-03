//
//  DictionaryStore+Map.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation
extension DictionaryStore {
    static func map(_ data: [Response.Word]) -> [ViewModel] {
        data.compactMap { word -> ViewModel in
            Self.mapSingle(word)
        }
    }
    
    static func mapSingle(_ data: Response.Word) -> ViewModel {
        let translations = data.translations?.filter { translation in
            data.language == "sl" ? translation.language != "en" : translation.language != "sl"
        }
            return ViewModel(
            _id: data._id,
            word: data.word,
            language: data.language,
            translation: translations?.first?.word ?? ""
        )
    }
}

