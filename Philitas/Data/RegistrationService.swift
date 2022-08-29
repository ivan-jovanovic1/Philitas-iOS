//
//  RegistrationService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation
import Networking

class RegistrationService {
    private let emailPredicate = NSPredicate(
        format:"SELF MATCHES %@",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    )
    
    private let passwordPredicate = NSPredicate(
        format: "SELF MATCHES %@",
        "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
    )
}

// MARK: - RegistrationValidator conformation
extension RegistrationService: RegistrationValidator {
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

// MARK: - RegistrationFormSender conformation
extension RegistrationService: RegistrationFormSender {
    func register(form: RegistrationFormSender.Form) async throws -> Response.UserData {
        try await APIRequest(Endpoint.register, method: .post)
            .setBody(form)
            .perform(Response.BaseResponse<Response.UserData>.self)
            .data
    }
}
