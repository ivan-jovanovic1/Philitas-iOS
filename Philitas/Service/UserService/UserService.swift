//
//  UserService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class UserService: UserMethods {
    
    func login(payload: Request.User) async throws -> Response.User {
        try await APIRequest(
            Endpoint.login,
            method: .post
        )
        .setBody(payload)
        .perform()
    }
    
}
