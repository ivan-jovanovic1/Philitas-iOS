//
//  FavoriteUpdater+DefaultImplementation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/08/2022.
//

import Foundation
import Networking

extension FavoriteUpdater {
    func updateFavorites(id: String, shouldBeInFavorites: Bool) async throws -> Bool {
        let response = try await APIRequest(
            Endpoint.favoriteWords,
            method: shouldBeInFavorites ? .post : .delete
        )
        .setBody(WordId(id: id))
        .perform(Response.BaseResponse<Bool>.self)
        
        return shouldBeInFavorites ? response.data : !response.data
    }
}

fileprivate struct WordId: Encodable {
    let id: String
}
