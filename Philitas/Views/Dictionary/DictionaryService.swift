//
//  DictionaryService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation

class DictionaryService: DictionaryLoader {
    var pageSize: Int
    private(set) var pagination: Pagination?

    init(
        pageSize: Int,
        pagination: Pagination? = nil
    ) {
        self.pageSize = pageSize
        self.pagination = pagination
    }
}

extension DictionaryService {
    func shouldShowNextPage(isLastWord: Bool) -> Bool {
        isLastWord && pagination?.hasNextPage() ?? false
    }

    func load() async throws -> [DictionaryLoader.Item] {
        let response = try await WordAPI.words(
            page: pagination?.nextPage(),
            pageSize: pageSize
        )

        pagination = response.pagination

        return response.data
    }

    func resetPagination() {
        pagination = nil
    }
}
