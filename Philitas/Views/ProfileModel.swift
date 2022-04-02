//
//  ProfileModel.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class ProfileModel: ObservableObject {
    weak var session: Session?
    var presentedSubview: Subview = .none
}

extension ProfileModel {
    @MainActor func checkIfLogged() {
        if session?.user == nil {
            presentedSubview = .login
        }
    }
}

extension ProfileModel {
    enum Subview: Int {
        case login
        case none
    }
}
