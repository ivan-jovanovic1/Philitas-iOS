//
//  String+urlEncoded.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

extension String {
    /// Returns encoded string if succeeds, otherwise an empty string.
    /// This is useful if string has non-ascii values.
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
