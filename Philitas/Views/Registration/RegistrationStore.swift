//
//  RegistrationStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationStore<T: RegistrationValidator & RegistrationFormSender>: ObservableObject {
    @Published var inputs: [String] = [String](repeating: "", count: Field.allCases.count)
    @Published var invalidInput: InvalidInput?
    @Published var userData: RegistrationFormSender.User?
    @Published var showErrorAlert = false
    @Published var isCompleteRegistrationEnabled: Bool = false
    
    private let service: T
    
    init(service: T) {
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
    
    private func shouldChangeFocusToNext(field: Field?) -> Bool {
        guard let field = field else {
            return false
        }
        invalidInput = invalidInput(from: field)
                
        return invalidInput == nil
    }
    
    private func invalidInput(from field: Field) -> InvalidInput? {
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
    
    private var isEmailValid: Bool {
        service.isEmailValid(email: inputs[Field.email.rawValue])
    }
    
    private var isUsernameValid: Bool {
        service.isUsernameValid(username: inputs[Field.username.rawValue])
    }
    
    private var isPasswordValid: Bool {
        service.isPasswordValid(password: inputs[Field.password.rawValue])
    }
    
    private var form: T.Form {
        T.Form(
            username: inputs[Field.username.rawValue],
            password: inputs[Field.password.rawValue],
            email: inputs[Field.email.rawValue],
            firstName: inputs[Field.firstName.rawValue],
            lastName: inputs[Field.lastName.rawValue]
        )
    }
}
