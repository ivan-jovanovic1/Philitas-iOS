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

// MARK: - Fake DictionaryService
#if DEBUG
class DictionaryServiceMock: DictionaryLoader, DictionaryUpdater {
    var pageSize: Int = 25

    var pagination: Pagination?

    func shouldShowNextPage(isLastWord: Bool) -> Bool {
        true
    }

    func load() async throws -> [DictionaryLoader.Item] {
        [.dummy, .dummy, .dummy, .dummy]
    }

    func resetPagination() {
        pagination = nil
    }
    
    func addToFavorites(id: String) async throws -> Bool {
        return true
    }
}
#endif
