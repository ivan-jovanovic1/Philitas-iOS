//
//  RegistrationStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationStore: ObservableObject {
    @Published var inputs: [String] = [String](repeating: "", count: Field.allCases.count)
    @Published var invalidInput: InvalidInput?
    @Published var userData: RegistrationFormSender.User?
    @Published var showErrorAlert = false
    @Published var isCompleteRegistrationEnabled: Bool = false
    private let service: RegistrationValidator & RegistrationFormSender
    
    init(service: RegistrationValidator & RegistrationFormSender) {
        self.service = service
    }
}

extension RegistrationStore {
    @MainActor
    @Sendable
    func register() async {
        do {
            userData = try await service.register(form: form)
        } catch {
            showErrorAlert = true
        }
    }
    
    func process(focusedField: inout Field?) {
        guard shouldChangeFocusToNext(field: focusedField) else { return }
        focusedField = focusedField?.next()
    }
    
    func updateCompleteButton() {
        isCompleteRegistrationEnabled =  isEmailValid && isUsernameValid && isPasswordValid
    }
}

// MARK: - Private
private extension RegistrationStore {
    func shouldChangeFocusToNext(field: Field?) -> Bool {
        guard let field = field else {
            return false
        }
        invalidInput = invalidInput(from: field)
        
        return invalidInput == nil
    }
    
    func invalidInput(from field: Field) -> InvalidInput? {
        switch field {
        case .username:
            return isUsernameValid ? nil : .invalidUsername
        case .password:
            return isPasswordValid ? nil : .invalidPassword
        case .email:
            return isEmailValid ? nil : .invalidEmail
        default:
            return nil
        }
    }
    
    var isEmailValid: Bool {
        service.isEmailValid(email: inputs[Field.email.rawValue])
    }
    
    var isUsernameValid: Bool {
        service.isUsernameValid(username: inputs[Field.username.rawValue])
    }
    
    var isPasswordValid: Bool {
        service.isPasswordValid(password: inputs[Field.password.rawValue])
    }
    
    var form: RegistrationFormSender.Form {
        RegistrationFormSender.Form(
            username: inputs[Field.username.rawValue],
            password: inputs[Field.password.rawValue],
            email: inputs[Field.email.rawValue],
            firstName: inputs[Field.firstName.rawValue],
            lastName: inputs[Field.lastName.rawValue]
        )
    }
}
