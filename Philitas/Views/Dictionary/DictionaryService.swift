//
//  DictionaryService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

class DictionaryService {
    var pageSize: Int
    var pagination: Pagination?

    init(
        pageSize: Int,
        pagination: Pagination? = nil
    ) {
        self.pageSize = pageSize
        self.pagination = pagination
    }
}

extension DictionaryService: DictionaryLoader {
    func load() async throws -> [DictionaryLoader.Item] {
        let response = try await WordAPI.words(
            page: pagination?.nextPage(),
            pageSize: pageSize
        )

        pagination = response.pagination

        return response.data
    }
}

extension DictionaryService: DictionaryUpdater {
    func addToFavorites(id: String) async throws -> Bool {
        try await UserAPI.addToFavorites(id: id).data
    }
}
