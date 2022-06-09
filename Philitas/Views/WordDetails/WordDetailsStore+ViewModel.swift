//
//  WordDetailsViewModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation

extension WordDetailsStore {

    /// Represents Word
    struct ViewModel {
        let id: String
        /// The word in its main language.
        let word: String
        /// The word translated to other languages.
        let translations: [Translation]
        /// The word main language.
        let language: String
        /// The array of all dictionaries with their explanations.
        let dictionaries: [Dictionary]
    }

    struct Dictionary: Identifiable {
        /// The explanations.
        let explanations: [String]
        /// The dictionary name (e.g. Slovar slovenskega knjižnega jezika).
        let dictionaryName: String
        /// The source from which we scrapped
        let source: String

        var id: String {
            dictionaryName + source
        }
    }

}

extension WordDetailsStore.ViewModel: Equatable {
    static func == (lhs: WordDetailsStore.ViewModel, rhs: WordDetailsStore.ViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
