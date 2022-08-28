//
//  UserAPI.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Networking

enum UserAPI {
    static func login(
        username: String,
        password: String
    ) async throws -> Response.BaseResponse<Response.UserData> {
        struct User: Encodable {
            let username: String
            let password: String
        }

        return try await APIRequest(Endpoint.login, method: .post)
            .setBody(User(username: username, password: password))
            .perform()
    }
    
    static func logout() async throws -> Response.BaseResponse<Bool> {
        try await APIRequest(Endpoint.logout, method: .post)
            .perform()
    }
    
    static func register(form: Request.RegistrationForm) async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.register, method: .post)
            .setBody(form)
            .perform()
    }

    static func userFromToken() async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.verifyToken, method: .get)
            .perform()
    }
    
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
