//
//  Queryable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

protocol Queryable {
    var params: [String: Any] { get  }
    
    func urlParams() -> String
}

extension Queryable {
    func urlParams() -> String {
       "?" + params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
    }
}
