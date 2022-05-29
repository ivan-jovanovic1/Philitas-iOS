//
//  DictionaryStore+ViewModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

extension DictionaryStore {
    struct ViewModel: Identifiable {
        let _id: String
        let word: String
        let language: String
        let translation: String

        var id: String {
            _id
        }
    }
}

extension DictionaryStore.ViewModel: Equatable {
    static func == (lhs: DictionaryStore.ViewModel, rhs: DictionaryStore.ViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension DictionaryStore.ViewModel: Comparable {
    static func < (lhs: DictionaryStore.ViewModel, rhs: DictionaryStore.ViewModel) -> Bool {
        return lhs.word < rhs.word
    }
}

extension DictionaryStore.ViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}
