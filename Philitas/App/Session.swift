//
//  Session.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class Session: ObservableObject {
    @Published var user: SessionLoader.User?
    let loader: any SessionLoader

    init(
        loader: any SessionLoader
    ) {
        self.loader = loader
    }
}

extension Session {
    @Sendable
    func verifyJWSToken() async {
        guard UserDefaults.standard.jwsToken != nil else {
            return user = nil
        }

        do {
            user = try await loader.loadFromToken()
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: any Error) {
        UserDefaults.standard.jwsToken = nil
        PHLogger.networking.error("\(error.localizedDescription)")
    }
}
