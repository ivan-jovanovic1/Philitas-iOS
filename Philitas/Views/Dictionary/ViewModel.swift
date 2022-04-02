//
//  ViewModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

extension DictionaryModel {
    struct ViewModel: Identifiable {
        let id: String
        let word: String
        let language: String
        let translation: String
    }
}
