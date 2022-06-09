//
//  UserAPI.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Networking

enum UserAPI {
    static func login(
        payload: Request.User
    ) async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.login, method: .post)
            .setBody(payload)
            .perform()
    }

    static func userFromToken() async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.verifyToken, method: .get)
            .perform()
    }
}
