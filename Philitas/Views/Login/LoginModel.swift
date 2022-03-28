//
//  LoginModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

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
    
    func login() {
        guard
            validateUsername(),
            validatePassword()
        else {
            showInvalidInput = true
            return
        }
        
        let payload = Request.User(username: username, password: password)
        
        service.login(payload: payload) { [weak self] user, error in
            if let user = user {
                print(user)
            }
            
            if let error = error {
                print(error)
            }
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
