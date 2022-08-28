//
//  SessionService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation
import Networking

class SessionService { }


// MARK: - SessionLoader conformation
extension SessionService: SessionLoader {
    func loadFromToken() async throws -> SessionLoader.User {
        try await APIRequest(Endpoint.verifyToken, method: .get)
            .perform(Response.BaseResponse<Response.UserData>.self)
            .data
    }
}

// MARK: - SessionUpdater conformation
extension SessionService: SessionUpdater {
    func login(username: String, password: String) async throws -> SessionLoader.User {
        struct User: Encodable {
            let username: String
            let password: String
        }

        return try await APIRequest(Endpoint.login, method: .post)
            .setBody(User(username: username, password: password))
            .perform(Response.BaseResponse<Response.UserData>.self)
            .data
    }
    
    func logout() async throws -> Bool {
        try await APIRequest(Endpoint.logout, method: .post)
            .perform(Response.BaseResponse<Bool>.self)
            .data
    }
}

// MARK: - Fake SessionService
#if DEBUG
class SessionServiceMock: SessionLoader, SessionUpdater {
    func logout() async throws -> Bool {
        true
    }
    
    func loadFromToken() async throws -> SessionLoader.User {
        .init(
            id: UUID().uuidString,
            username: "Ivan",
            email: "ivan.jovanovic@student.um.si",
            authToken: UUID().uuidString,
            favoriteWordIds: []
        )
    }
    
    func login(username: String, password: String) async throws -> SessionLoader.User {
        .init(
            id: UUID().uuidString,
            username: "Ivan",
            email: "ivan.jovanovic@student.um.si",
            authToken: UUID().uuidString,
            favoriteWordIds: []
        )
    }
}
#endif
