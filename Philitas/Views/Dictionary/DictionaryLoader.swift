//
//  DictionaryLoader.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

protocol DictionaryLoader: AnyObject {
    typealias Item = Response.Word

    var pageSize: Int { get }
    var pagination: Pagination? { get }

    func shouldShowNextPage(isLastWord: Bool) -> Bool

    func load() async throws -> [Item]

    func resetPagination()
}
