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

extension BaseURL {
    public var fullURL: String {
        baseURL + rawValue
    }
}
