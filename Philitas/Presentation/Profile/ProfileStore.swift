//
//  ProfileStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

class ProfileStore: ObservableObject, ViewPresentable {
    weak var session: Session?
    @Published var fullName: String?
    @Published var isRegistrationPresented = false
    @Published var isLoginPresented = false
    @Published var presented: WordLists? = .none    
}

extension ProfileStore {
    func checkForUpdate(tabItem: TabItem) {
        guard tabItem == .profile else { return }
        Task {
            await session?.verifyJWSToken()
        }
    }
    
    func fullName(firstName: String, lastName: String) -> String {
        let formatter = PersonNameComponentsFormatter()
        var components = PersonNameComponents()
        components.givenName = firstName
        components.familyName = lastName
        return formatter.string(from: components)
    }
}
