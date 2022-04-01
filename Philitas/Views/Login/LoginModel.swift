//
//  LoginModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class LoginModel: ObservableObject {
    
    let session: Session
    @Published var username: String
    @Published var password: String
    
    @Published var showInvalidInput: Bool = false
    let service: any UserMethods
    
    init(session: Session, service: any UserMethods = UserService()) {
        self.session = session
        self.service = service
        self.username = ""
        self.password = ""
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
            let response = try await service.login(payload: payload)
//            UserDefaults.standard.jwsToken = response.data.jwsToken
            
        } catch let error as Networking.NetworkError {
            PHLogger.networking.error("\(error.description)")
        } catch {
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
