//
//  WordDetailsService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

class WordDetailsService: WordDetailsLoader {
    let wordId: String

    init(
        wordId: String
    ) {
        self.wordId = wordId
    }

    func load() async throws -> WordDetailsLoader.Item {
        try await WordAPI.singleFromId(id: wordId).data
    }
}
