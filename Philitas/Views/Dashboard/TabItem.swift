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

    var zIndex: Double {
        Double(rawValue)
    }

    @ViewBuilder
    var mainView: some View {
        switch self {
        case .dictionary:
            DictionaryView(service: DictionaryService(pageSize: 25))
        case .profile:
            ProfileView()
        case .favorites:
            DictionaryView(service: DictionaryService(pageSize: 25))
        }
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
