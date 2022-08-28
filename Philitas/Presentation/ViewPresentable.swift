//
//  ViewPresentable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 03/04/2022.
//

import SwiftUI

protocol ViewPresentable: AnyObject {
    associatedtype Subview: RawRepresentable, Identifiable where Subview.RawValue == Int
    var presented: Subview? { get set }

    func isPresented(view: Subview) -> Binding<Bool>
}

extension ViewPresentable {
    func isPresented(view: Subview) -> Binding<Bool> {
        Binding {
            if let presented = self.presented {
                return view == presented
            }
            return false
        } set: {
            if !$0 {
                self.presented = .none
            }
        }
    }
}
