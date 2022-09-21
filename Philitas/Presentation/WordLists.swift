//
//  WordLists.swift
//  Philitas
//
//  Created by Ivan Jovanović on 21/09/2022.
//

import Foundation

enum WordLists: Int, Identifiable {
    var id: Int {
        self.rawValue
    }
    
    case favorites
    case history
    
    var url: Endpoint {
        switch self {
        case .favorites:
            return Endpoint.favoriteWords
        case .history:
            return Endpoint.historyWords
        }
    }
}
