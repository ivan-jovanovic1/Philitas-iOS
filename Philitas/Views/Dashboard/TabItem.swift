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
        self.rawValue
    }
    
    var zIndex: Double {
        Double(self.rawValue)
    }
    
    @ViewBuilder
    var mainView: some View {
        switch self {
        case .dictionary:
            DictionaryView()
        case .profile:
            EmptyView()
        case .favorites:
            DictionaryView()
        }
    }
    
    var description: String {
        switch self {
        case .dictionary:
            return "Dictionary"
        case .favorites:
            return "Favorites"
        case .profile:
            return "Profile"
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
