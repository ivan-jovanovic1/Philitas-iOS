//
//  ProfileStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

@MainActor
class ProfileStore: ObservableObject {
    weak var session: Session?
    @Published var fullName: String?
    @Published var isRegistrationPresented = false
    @Published var isLoginPresented = false
    var presentedSubview: Subview = .none
    var evidenceSection: [(Int, String)]? {
        guard
            let favorites = session?.user?.favoritesCount,
            let history = session?.user?.historyCount
        else {
            return .none
        }
        
        return [(favorites, "Priljubljeno"), (history, "Pregledano")]
    }
    
    private let formatter = PersonNameComponentsFormatter()
}

extension ProfileStore {
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
