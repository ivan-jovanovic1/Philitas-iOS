//
//  ProfileStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class ProfileStore: ObservableObject {
    weak var session: Session?
    @Published var fullName: String?
    @Published var isRegistrationPresented = false
    @Published var isLoginPresented = false
    var presentedSubview: Subview = .none
    private let formatter = PersonNameComponentsFormatter()
}

extension ProfileStore {
    @MainActor
    func checkForFullName() {
        guard
            let firstName = session?.user?.firstName,
            let lastName = session?.user?.lastName
        else { return }
        
        var components = PersonNameComponents()
        components.givenName = firstName
        components.familyName = lastName

        fullName = formatter.string(from: components)
    }
    
    @MainActor
    func checkForUpdate(tabItem: TabItem) {
        guard tabItem == .profile else { return }
        Task {
            await session?.verifyJWSToken()
            checkForFullName()
        }
    }
}

extension ProfileStore {
    enum Subview: Int {
        case login
        case none
    }
}
