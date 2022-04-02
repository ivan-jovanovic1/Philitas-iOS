//
//  WordDetailsViewModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation


extension WordDetailsStore {
    
    struct ViewModel: Equatable {
        static func == (lhs: WordDetailsStore.ViewModel, rhs: WordDetailsStore.ViewModel) -> Bool {
            lhs.id == rhs.id
        }
        
        let id: String
        /// The word in its main language
        let word: String
        /// The word translated to other languages.
        let translations: [Translation]
        /// The word main language
        let language: String
        /// An array of all dictionaries with their explanations
        let dictionaries: [Dictionary]
    }

    struct Dictionary: Identifiable{
        let explanations: [String]
        let dictionaryName: String
        let source: String
        
        var id: String {
            dictionaryName+source
        }
    }
    
}
