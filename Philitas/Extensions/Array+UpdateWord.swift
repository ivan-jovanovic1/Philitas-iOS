//
//  Array+UpdateWord.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

extension Array where Element == Response.Word {
    /// Updates current array of words with unique elements.
    mutating func update(with new: [Element]) {
        append(contentsOf: new)
        var seen = Set<Element>()
        self = filter { seen.insert($0).inserted }.sorted()
    }
}
