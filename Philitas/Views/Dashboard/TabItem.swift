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
        case .profile:
            return "Račun"
        }
    }

    var iconSystemName: String {
        switch self {
        case .dictionary:
            return "character.book.closed"
        case .favorites:
            return "star"
        case .profile:
            return "person"
        }
    }
}
