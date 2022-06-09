//
//  SessionService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

class SessionService: SessionLoader {
    func loadFromToken() async throws -> SessionLoader.User {
        try await UserAPI.userFromToken().data
    }

    func login(username: String, password: String) async throws -> SessionLoader.User {
        try await UserAPI.login(username: username, password: password).data
    }
}
