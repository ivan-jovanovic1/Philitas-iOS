//
//  File.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

extension Request {
    struct RegistrationForm: Encodable {
        let username: String
        let password: String
        let email: String
        let firstName: String?
        let lastName: String?
    }
}
