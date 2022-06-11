//
//  DictionaryLoader.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

protocol DictionaryLoader: Paginatable {
    typealias Item = Response.Word
    
    func load() async throws -> [Item]
}
