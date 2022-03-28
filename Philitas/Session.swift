//
//  Session.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class Session: ObservableObject {
    
    @Published var user: Response.User?
    let service: UserMethods
    
    init(service: UserMethods = UserService()) {
        self.service = service
    }
}

extension Session {
    
    func verifyJWSToken() {
        guard let token = UserDefaults.standard.jwsToken else {
            return
        }
        
        // TODO: Add method to the back-end which returns isLoggedIn bool property.
        // service.verifyJWSToken(...) { [weak self] in
        // if let user = $0 {
        // self?.user = user
        // } else {
        // UserDefaults.standard.jwsToken = nil
        // }
        //
        //if let error = $1 {
        //  self?.handleError(error)
        //}
    }
    
}
