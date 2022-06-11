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
        
        [Field.firstName, .lastName, nil].forEach {
            if $0 == focusedField {
                isCompleteRegistrationEnabled = true
            }
        }
    }
    
    private func shouldChangeFocusToNext(field: Field?) -> Bool {
        guard let field = field else {
            return false
        }
        invalidInput = invalidInput(from: field)
                
        return invalidInput == nil
    }
    
    private func invalidInput(from field: Field) -> InvalidInput? {
        let currentValue = inputs[field.rawValue]
        switch field {
        case .username:
            return service.isUsernameValid(username: currentValue) ? nil : .invalidUsername
        case .password:
            return service.isPasswordValid(password: currentValue) ? nil : .invalidPassword
        case .email:
            return service.isEmailValid(email: currentValue) ? nil : .invalidEmail
        default:
            return nil
        }
    }
}
