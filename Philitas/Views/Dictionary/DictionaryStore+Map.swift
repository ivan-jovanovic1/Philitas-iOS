//
//  DictionaryStore+Map.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation
extension DictionaryStore {
    static func map(_ model: Response.BaseResponse<[Response.Word]>) -> [ViewModel] {
        model.data.compactMap { word -> DictionaryStore.ViewModel in

            let translations = word.translations?.filter { translation in
                word.language == "sl" ? translation.language != "en" : translation.language != "sl"
            }

            return DictionaryStore.ViewModel(
                id: word._id,
                word: word.word,
                language: word.language,
                translation: translations?.first?.word ?? ""
            )
        }
    }
}
