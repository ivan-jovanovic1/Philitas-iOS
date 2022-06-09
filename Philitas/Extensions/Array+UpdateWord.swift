//
//  Array+UpdateWord.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

extension Array where Element == DictionaryLoader.Item {
    /// Updates current array of words with unique elements.
    func update(with new: [Element]) -> [Element] {
        var array = self
        array.append(contentsOf: new)
        var seen = Set<Element>()
        return array.filter { seen.insert($0).inserted }
    }

    func sortByLanguage() -> [Element] {
        sorted { (lhs, rhs) in
            if lhs.language == "sl" && rhs.language == "sl" {
                return lhs.word < rhs.word
            }

            return lhs.language == "sl"
        }
    }

}
