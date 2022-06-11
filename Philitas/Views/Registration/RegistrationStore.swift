//
//  RegistrationStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

class RegistrationStore<T: RegistrationValidator & RegistrationFormSender>: ObservableObject {
    @Published var inputs: [String] = [String](repeating: "", count: Field.allCases.count)
    @Published var invalidInput: InvalidInput? = nil
    private let service: T
    
    init(service: T) {
        self.service = service
    }
}
