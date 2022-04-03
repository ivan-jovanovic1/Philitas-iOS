//
//  Session.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class Session: ObservableObject {
    @Published var user: Response.UserData?
    let service: any UserServiceRepresentable

    init(service: any UserServiceRepresentable = UserService()) {
        self.service = service
    }
}

extension Session {
    @Sendable
    func verifyJWSToken() async {
        guard UserDefaults.standard.jwsToken != nil else {
            user = nil
            return
        }

        do {
            user = try await service.userFromToken().data
            print(String(describing: user))
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: any Error) {
        UserDefaults.standard.jwsToken = nil
        PHLogger.networking.error("\(error.localizedDescription)")
    }
}
