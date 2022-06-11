//
//  RegistrationValidator.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

protocol RegistrationValidator: AnyObject {
    func isUsernameValid(username: String) -> Bool
    func isPasswordValid(password: String) -> Bool
    func isEmailValid(email: String) -> Bool
}
