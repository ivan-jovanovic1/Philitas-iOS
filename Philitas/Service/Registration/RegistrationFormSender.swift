//
//  RegistrationFormSender.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

protocol RegistrationFormSender: AnyObject {
    typealias User = Response.UserData
    typealias Form = Request.RegistrationForm
    func register(form: Form) async throws -> User
}
