//
//  WordDetailsModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI

class WordDetailsModel: ObservableObject {
    @Published private(set) var singleWord: Response.Word
    @Published var presented: Subview? = .none

    var title: String {
        singleWord.word
//        (singleWord.language == "sl" ? singleWord.word : singleWord.translatedWord ?? singleWord.word).capitalized
    }

    var subtitle: String? {
        ""
//        if singleWord.language == "sl" {
//            return singleWord.translatedWord
//        }
//        return singleWord.word
    }

    init(singleWord: Response.Word) {
        self.singleWord = singleWord
    }

    func loadWordDetails() {
    }
}

extension WordDetailsModel {
    func isPresented(subview: Subview) -> Binding<Bool> {
        Binding {
            subview == self.presented
        } set: { _ in
        }
    }
}

extension WordDetailsModel {
    enum Subview: Int, Identifiable {
        case translate

        var id: Int {
            rawValue
        }
    }
}
