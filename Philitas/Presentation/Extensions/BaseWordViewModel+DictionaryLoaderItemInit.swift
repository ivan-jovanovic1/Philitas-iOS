//
//  BaseWordViewModel+DictionaryLoaderItemInit.swift
//  Philitas
//
//  Created by Ivan Jovanović on 25/09/2022.
//

import Foundation

extension BaseWordViewModel {
    init(word: DictionaryLoader.Item) {
        self.id = word.id
        self.name = word.name
        self.language = word.language
        self.translation = word.translation?.word ?? ""
    }
}
