//
//  ViewPresentable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 03/04/2022.
//

import SwiftUI

protocol ViewPresentable: AnyObject {
    associatedtype E: RawRepresentable, Identifiable where E.RawValue == Int
    var presented: E? { get set }

    func isPresented(view: E) -> Binding<Bool>
}

extension ViewPresentable {

    func isPresented(view: E) -> Binding<Bool> {
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
