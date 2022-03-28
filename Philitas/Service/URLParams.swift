//
//  URLParams.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

typealias URLParams = [String: Any]

extension URLParams {
    func string() -> String {
        "?" + compactMap({ (key, value) -> String in
            "\(key)=\(value)"
        }).joined(separator: "&")
    }
}
