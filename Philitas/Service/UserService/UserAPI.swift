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

    static func userFromToken() async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.verifyToken, method: .get)
            .perform()
    }
}
