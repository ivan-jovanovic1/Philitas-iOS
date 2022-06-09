//
//  ProfileStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class ProfileStore: ObservableObject {
    weak var session: Session?
    var presentedSubview: Subview = .none
}

extension ProfileStore {
    @MainActor func checkIfLogged() {
        if session?.user == nil {
            presentedSubview = .login
        }
    }
}

extension ProfileStore {
    enum Subview: Int {
        case login
        case none
    }
}
