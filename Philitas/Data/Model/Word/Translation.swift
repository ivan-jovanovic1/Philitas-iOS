//
//  Translation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 31/03/2022.
//

import Foundation

struct Translation: Decodable {
    let language: String
    let word: String
}

// MARK: - Identifiable conformation
extension Translation: Identifiable {
    var id: String {
        language + word
    }
}
