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
    @Published var showInvalidInput: Bool = false
    let service: SessionUpdater
    
    init(service: SessionUpdater) {
        self.service = service
    }
}

extension LoginStore {
    @Sendable
    func login() async {
        guard
            validateUsername(),
            validatePassword()
        else {
            return showInvalidInput = true
        }
        
        do {
            let userData = try await service.login(username: username, password: password)
            UserDefaults.standard.jwsToken = userData.authToken
            self.userData = userData
        }
        catch {
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
}

private extension LoginStore {
    func validateUsername() -> Bool {
        return username.count >= 8
    }
    
    func validatePassword() -> Bool {
        return password.count >= 8
    }
}
