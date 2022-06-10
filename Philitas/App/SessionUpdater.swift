//
//  SessionUpdater.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

protocol SessionUpdater: AnyObject {
    func login(username: String, password: String) async throws -> SessionLoader.User
    func logout() async throws -> Bool
}
