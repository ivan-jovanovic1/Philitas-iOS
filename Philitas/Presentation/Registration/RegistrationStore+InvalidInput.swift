//
//  RegistrationStore+InvalidInput.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import Foundation

extension RegistrationStore {
    enum InvalidInput: Error, LocalizedError {
        case invalidUsername
        case invalidPassword
        case invalidEmail
        
        var errorDescription: String? {
            switch self {
            case .invalidUsername:
                return "Prosimo vnesite uporabniško ime. Dolžina uporabniškega imena mora biti od 3 do 64 znakov."
            case .invalidPassword:
                return "Prosimo vnesite geslo. Geslo mora imeti vsaj eno veliko črko in vsaj eno številko."
            case .invalidEmail:
                return "Prosimo vnesite veljaven e-naslov."
            }
        }
    }
}
