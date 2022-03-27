//
//  DictionaryExplanation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

struct DictionaryExplanation: Decodable {
    let explanations: [String]
    let dictionaryName: String
    let source: String
}

// MARK: Identifiable conformation
extension DictionaryExplanation: Identifiable {
    var id: Int {
        var hasher = Hasher()
        hasher.combine(source)
        hasher.combine(dictionaryName)
        return hasher.finalize()
    }
}
