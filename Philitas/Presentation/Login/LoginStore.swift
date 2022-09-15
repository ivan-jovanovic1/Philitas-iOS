//
//  LoginModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class LoginStore: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var userData: SessionLoader.User?
    @Published var loginError: LoginError?
    let service: SessionUpdater
    
    init(service: SessionUpdater) {
        self.service = service
    }
}

extension LoginStore {
    @Sendable
    func login() async {
        guard validateUsername() else { return loginError = .invalidUsername }
        guard validatePassword() else { return loginError = .invalidPassword }
        
        do {
            let userData = try await service.login(username: username, password: password)
            UserDefaults.standard.jwsToken = userData.jwsToken
            self.userData = userData
        } catch {
            loginError = .networkingError
            PHLogger.networking.error("Unknown error: \(error.localizedDescription)")
        }
    }
    
    func process(focusedField: inout Field?) {
        if focusedField == .username {
            focusedField = .password
        }
        if focusedField == .password {
            focusedField = nil
            Task {
                await login()
            }
        }
    }
}

extension LoginStore {
    enum Field: Hashable {
        case username
        case password
    }
    
    enum LoginError: Error, LocalizedError {
        case invalidUsername
        case invalidPassword
        case networkingError
        
        var errorDescription: String? {
            switch self {
            case .invalidUsername:
                return "Vneseno uporabniško ime ni veljavno."
            case .invalidPassword:
                return "Vneseno geslo ni veljavno."
            case .networkingError:
                return "Napaka pri prijavi."
            }
        }
    }
}

private extension LoginStore {
    func validateUsername() -> Bool {
        return username.count >= 8
    }
    
    func validatePassword() -> Bool {
        return password.count >= 8
    }
}
