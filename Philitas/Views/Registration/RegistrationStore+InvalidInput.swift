//
//  RegistrationStore+InvalidInput.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

extension RegistrationStore {
    enum InvalidInput: Error, LocalizedError {
        case requiredUsername
        case requiredPassword
        case requiredEmail
        case weakPassword
        
        var errorDescription: String? {
            switch self {
            case .requiredUsername:
                return "Prosimo vnesite uporabniško ime."
            case .requiredPassword:
                return "Prosimo vnesite geslo."
            case .requiredEmail:
                return "Prosimo vnesite e-naslov."
            case .weakPassword:
                return "Geslo je prešibko. Prosimo, da vnesete geslo z vsaj 8 znakov."
            }
        }
    }
}
