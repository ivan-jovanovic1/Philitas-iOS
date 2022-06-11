//
//  RegistrationStore+Field.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

extension RegistrationStore {
    enum Field: Int, Hashable, CaseIterable, Identifiable {
        case username
        case password
        case email
        case firstName
        case lastName
        
        var id: Int {
            rawValue
        }
        
        var isSecureField: Bool {
            self == .password
        }
        
        var description: String {
            switch self {
            case .username:
                return "Uporabniško ime*"
            case .password:
                return "Geslo*"
            case .email:
                return "E-naslov*"
            case .firstName:
                return "Ime"
            case .lastName:
                return "Priimek"
            }
        }
                
        mutating func next() -> Field? {
            guard
                let index = Field.allCases.firstIndex(of: self),
                index + 1 < Field.allCases.count
            else { return nil }
            
            return Field.allCases[index + 1]
        }
    }
}
