//
//  WordDetailsService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation
import Networking

class WordDetailsService: FavoriteUpdater {
    let wordId: String

    init(wordId: String) {
        self.wordId = wordId
    }
}

// MARK: - WordDetailsLoader
extension WordDetailsService: WordDetailsLoader {
    func load() async throws -> WordDetailsLoader.Item {
        try await APIRequest(
            Endpoint.wordFromId,
            params: [
                "id": wordId
            ],
            method: .get
        )
        .perform(Response.BaseResponse<Response.Word>.self)
        .data
    }
}

// MARK: - Fake WordDetailsService
#if DEBUG
class WordDetailsServiceMock: WordDetailsLoader, FavoriteUpdater {
    func load() async throws -> WordDetailsLoader.Item {
        return Response.Word.dummy
    }

    func addToFavorites(id: String) async throws -> Bool {
        return true
    }
}
#endif
