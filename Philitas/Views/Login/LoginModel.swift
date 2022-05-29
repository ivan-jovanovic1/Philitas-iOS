//
//  LoginModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class LoginModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var userData: Response.UserData?

    @Published var showInvalidInput: Bool = false
    let service: any UserServiceRepresentable

    init(
        service: any UserServiceRepresentable = UserService()
    ) {
        self.service = service
        username = ""
        password = ""
    }
}

extension LoginModel {
    @Sendable
    func login() async {
        guard
            validateUsername(),
            validatePassword()
        else {
            showInvalidInput = true
            return
        }

        let payload = Request.User(username: username, password: password)

        do {
            userData = try await service.login(payload: payload).data
            UserDefaults.standard.jwsToken = userData?.jwsToken
        }
        catch {
            PHLogger.networking.error("Unknown error: \(error.localizedDescription)")
        }
    }
}

extension LoginModel {
    func validateUsername() -> Bool {
        return username.count >= 8
    }

    func validatePassword() -> Bool {
        return password.count >= 8
    }
}
