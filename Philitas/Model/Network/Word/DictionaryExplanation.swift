//
//  DictionaryExplanation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

extension Response {
    struct DictionaryExplanation: Decodable {
        let explanations: [String]
        let dictionaryName: String
        let source: String
    }
}

// MARK: Identifiable conformation

extension Response.DictionaryExplanation: Identifiable {
    var id: Int {
        var hasher = Hasher()
        hasher.combine(source)
        hasher.combine(dictionaryName)
        return hasher.finalize()
    }
}

extension Response.DictionaryExplanation {
    static var dummy: Response.DictionaryExplanation {
        Response.DictionaryExplanation(
            explanations: .init(
                repeating: UUID().uuidString,
                count: Int.random(in: 5 ... 15)
            ),
            dictionaryName: UUID().uuidString,
            source: "https://www.termania.net"
        )
    }
}
