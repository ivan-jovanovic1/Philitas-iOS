//
//  SessionLoader.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

protocol SessionLoader: AnyObject {
    typealias User = Response.UserData

    func loadFromToken() async throws -> User
}
