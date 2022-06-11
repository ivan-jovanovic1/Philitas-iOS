//
//  RegistrationFormSender.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

struct RegistrationForm: Encodable {
    let username: String
    let password: String
    let email: String
    let firstName: String?
    let lastName: String?
}

protocol RegistrationFormSender: AnyObject {
    typealias User = Response.UserData
    
    func register(form: RegistrationForm) async throws -> User
}
