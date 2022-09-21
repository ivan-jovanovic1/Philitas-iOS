//
//  TabItem.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

enum TabItem: Int, Hashable, CaseIterable, Identifiable {
    case dictionary
    case favorites
    case history
    case profile

    var id: Int {
        rawValue
    }
    
    var description: String {
        switch self {
        case .dictionary:
            return "Seznam besed"
        case .favorites:
            return "Priljubljeno"
        case .history:
            return "Zgodovina"
        case .profile:
            return "Račun"
        }
    }

    var iconSystemName: String {
        switch self {
        case .dictionary:
            return "character.book.closed"
        case .history:
            return "clock"
        case .favorites:
            return "star"
        case .profile:
            return "person"
        }
    }
}

// MARK: - Environment value 
extension TabItem: EnvironmentKey {
    static let defaultValue: TabItem = .dictionary
}

extension EnvironmentValues {
    var currentTab: TabItem {
        get { self[TabItem.self] }
        set { self[TabItem.self] = newValue }
    }
}

