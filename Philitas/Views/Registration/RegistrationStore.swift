//
//  RegistrationStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationStore<T: RegistrationValidator & RegistrationFormSender>: ObservableObject {
    @Published var inputs: [String] = [String](repeating: "", count: Field.allCases.count)
    @Published var invalidInput: InvalidInput? = nil
    @Published var isCompleteRegistrationEnabled: Bool = false
    
    private let service: T
    
    init(service: T) {
        self.service = service
    }
}

extension RegistrationStore {
    @Sendable
    func register() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
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
}
