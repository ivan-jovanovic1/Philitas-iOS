//
//  Request+User.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

public extension Request {
    
    struct User: Encodable {
        let username: String
        let password: String
        
        init(
            username: String,
            password: String
        ) {
            self.username = username
            self.password = password
        }
    }
    
}
