//
//  WordListLoader.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

protocol WordListLoader: Paginatable {
    typealias Item = Response.Word
    
    func load() async throws -> [Item]
}
