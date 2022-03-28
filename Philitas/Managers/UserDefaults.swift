//
//  UserDefaults.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation


extension UserDefaults {
    var jwsToken: String? {
        get {
            string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
