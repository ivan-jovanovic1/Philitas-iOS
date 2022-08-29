//
//  UserAPI.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Networking

enum UserAPI {

    
    static func addToFavorites(id: String) async throws -> Response.BaseResponse<Bool> {
        struct WordId: Encodable {
            let id: String
        }
        
        return try await APIRequest(
            Endpoint.wordIdToFavorites,
            method: .post
        )
        .setBody(WordId(id: id))
        .perform()
    }
    
    static func removeFromFavorites(id: String) async throws -> Response.BaseResponse<Bool> {
        struct WordId: Encodable {
            let id: String
        }
        
        return try await APIRequest(
            Endpoint.wordIdToFavorites,
            method: .delete
        )
        .setBody(WordId(id: id))
        .perform()
    }
}
