//
//  DictionaryStore+ViewModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

extension DictionaryStore {
    struct ViewModel: Identifiable {
        let id: String
        let word: String
        let language: String
        let translation: String
    }
}
