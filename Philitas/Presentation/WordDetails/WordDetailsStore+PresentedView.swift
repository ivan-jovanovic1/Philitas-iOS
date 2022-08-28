//
//  WordDetailsStore+PresentedView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import SwiftUI

extension WordDetailsStore {
    enum PresentedView: Int, Identifiable {
        case translate

        var id: Int {
            rawValue
        }
    }
}
