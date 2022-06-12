//
//  WordDetailsService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

class WordDetailsService: WordDetailsLoader, FavoriteUpdater {
    let wordId: String

    init(wordId: String) {
        self.wordId = wordId
    }

    func load() async throws -> WordDetailsLoader.Item {
        try await WordAPI.singleFromId(id: wordId).data
    }
}

// MARK: - Fake WordDetailsService
#if DEBUG
class WordDetailsServiceMock: WordDetailsLoader, FavoriteUpdater {
    func load() async throws -> WordDetailsLoader.Item {
        return WordDetailsLoader.Item.dummy
    }

    func addToFavorites(id: String) async throws -> Bool {
        return true
    }
}
#endif
