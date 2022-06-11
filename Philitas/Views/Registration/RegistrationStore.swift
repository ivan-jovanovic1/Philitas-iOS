//
//  RegistrationStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationStore: ObservableObject {
    @Published var inputs: [String] = [String](repeating: "", count: Field.allCases.count)
    @Published var invalidInput: InvalidInput? = nil
}
