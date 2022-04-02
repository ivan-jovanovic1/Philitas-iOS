//
//  SearchHit.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

extension Response {
    struct SearchHit: Decodable {
        let hits: Int
        let month: Int
        let year: Int
    }
}
