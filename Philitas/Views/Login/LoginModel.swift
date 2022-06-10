//
//  LoginModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class LoginStore<T: SessionLoader & SessionUpdater>: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var userData: T.User?
    @Published var showInvalidInput: Bool = false
    let loader: T

    init(
        loader: T
    ) {
        self.loader = loader
        username = ""
        password = ""
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
            let userData = try await loader.login(username: username, password: password)
            await updateUI(user: userData)
            UserDefaults.standard.jwsToken = userData.jwsToken
        }
        catch {
            PHLogger.networking.error("Unknown error: \(error.localizedDescription)")
        }
    }
}

private extension LoginStore {
    @MainActor
    func updateUI(user: T.User) async {
        userData = user
    }

    func validateUsername() -> Bool {
        return username.count >= 8
    }

    func validatePassword() -> Bool {
        return password.count >= 8
    }
}
