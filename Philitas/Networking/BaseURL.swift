//
//  BaseURL.swift
//  Philitas
//
//  Created by Ivan Jovanović on 31/03/2022.
//

import Foundation

public protocol BaseURL: RawRepresentable where RawValue == String {
    var baseURL: String { get }
}

public extension BaseURL {
    var fullURL: String {
        baseURL + self.rawValue
    }
}
