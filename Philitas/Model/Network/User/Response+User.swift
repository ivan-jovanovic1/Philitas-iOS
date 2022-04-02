//
//  Response+User.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

public extension Response {
        
    struct UserData: Decodable {
        private(set) var username: String
        private(set) var email: String
        private(set) var jwsToken: String
        private(set) var firstName: String?
        private(set) var lastName: String? 
    }
    
}
