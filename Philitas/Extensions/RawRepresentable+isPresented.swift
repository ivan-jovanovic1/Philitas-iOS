//
//  RawRepresentable+isPresented.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

extension RawRepresentable where RawValue == Int {
    func isPresented(subview: Self) -> Binding<Bool> {
        .constant(subview.rawValue == rawValue)
    }
}
