//
//  Response+User.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

public extension Response {
    struct UserData: Decodable, Equatable {
        private(set) var id: String
        private(set) var username: String
        private(set) var email: String
        private(set) var jwsToken: String
        private(set) var firstName: String?
        private(set) var lastName: String?
        private(set) var favoritesCount: Int?        
    }
}

#if DEBUG
public extension Response.UserData {
    static var dummy: Self {
        .init(
            id: UUID().uuidString,
            username: "Ivan",
            email: "ivan.jovanovic@student.um.si",
            jwsToken: UUID().uuidString,
            firstName: "Ivan",
            lastName: "Jovanović"
        )
    }
}
#endif
