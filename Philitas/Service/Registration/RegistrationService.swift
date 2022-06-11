//
//  RegistrationService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationService: RegistrationValidator {
    private let emailPredicate = NSPredicate(
        format:"SELF MATCHES %@",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    )
    
    private let passwordPredicate = NSPredicate(
        format: "SELF MATCHES %@ ",
        "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$"
    )

    func isUsernameValid(username: String) -> Bool {
        (3...64).contains(username.count)
    }
    
    func isPasswordValid(password: String) -> Bool {
        return passwordPredicate.evaluate(with: password)
    }
    
    func isEmailValid(email: String) -> Bool {
        emailPredicate.evaluate(with: email)
    }
}

extension RegistrationService: RegistrationFormSender {
    func register(form: RegistrationForm) async throws -> RegistrationFormSender.User {
        .init(username: "", email: "", jwsToken: "")
    }
}
