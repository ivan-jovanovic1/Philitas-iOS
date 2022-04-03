//
//  UserService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Networking

class UserService: UserServiceRepresentable {
    func login(payload: Request.User) async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.login, method: .post)
            .setBody(payload)
            .perform()
    }

    func userFromToken() async throws -> Response.BaseResponse<Response.UserData> {
        try await APIRequest(Endpoint.verifyToken, method: .get)
            .perform()
    }
}
