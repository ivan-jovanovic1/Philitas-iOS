//
//  WordDetailsPresentation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation
extension WordDetailsStore {
    enum Presentation: Int, Identifiable {
        case translate

        var id: Int {
            rawValue
        }
    }
}
