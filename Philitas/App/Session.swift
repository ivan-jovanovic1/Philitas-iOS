//
//  Session.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class Session: ObservableObject {
    @Published var user: SessionLoader.User? {
        didSet {
            APIConfigure.configure()
        }
    }
    let service: any SessionLoader & SessionUpdater

    init(
        service: any SessionLoader & SessionUpdater
    ) {
        self.service = service
    }
}

extension Session {
    @Sendable
    func verifyJWSToken() async {
        guard UserDefaults.standard.jwsToken != nil else {
            return user = nil
        }

        do {
            user = try await service.loadFromToken()
        }
        catch {
            handleError(error)
        }
    }
    
    @MainActor
    @Sendable
    func logout() async {
        do {
            if try await service.logout() {
                user = nil
            }
        } catch {
            print("Ivan error \(error.localizedDescription)")
        }
    }

    private func handleError(_ error: any Error) {
        UserDefaults.standard.jwsToken = nil
        PHLogger.networking.error("\(error.localizedDescription)")
    }
}
