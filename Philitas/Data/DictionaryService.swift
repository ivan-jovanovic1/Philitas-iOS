//
//  DictionaryService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 09/06/2022.
//

import Foundation
import Networking

class DictionaryService: FavoriteUpdater {
    var pageSize: Int
    var pagination: Pagination?
    
    init(
        pageSize: Int,
        pagination: Pagination? = .none
    ) {
        self.pageSize = pageSize
        self.pagination = pagination
    }
}

// MARK: - DictionaryLoader conformation
extension DictionaryService: DictionaryLoader {
    func load() async throws -> [DictionaryLoader.Item] {
        let response = try await APIRequest(
            Endpoint.listOfWords,
            queryItems: [
                "page": String(pagination?.nextPage() ?? 1),
                "pageSize": String(pageSize),
            ],
            method: .get
        )
            .perform(Response.BaseResponse<[Response.Word]>.self)
        
        pagination = response.pagination
        
        return response.data
    }
    
    func loadFromSearch(query: String) async throws -> [DictionaryLoader.Item] {
        try await APIRequest(
            Endpoint.searchWord,
            params: [
                "query": query
            ],
            method: .get
        )
        .perform(Response.BaseResponse<[Response.Word]>.self)
        .data
    }

}

// MARK: - Fake DictionaryService
#if DEBUG
class DictionaryServiceMock: DictionaryLoader, FavoriteUpdater {
    var pageSize: Int = 25
    
    var pagination: Pagination?
    
    func shouldShowNextPage(isLastWord: Bool) -> Bool {
        true
    }
    
    func load() async throws -> [DictionaryLoader.Item] {
        [.dummy, .dummy, .dummy, .dummy]
    }
    
    func loadFromSearch(query: String) async throws -> [DictionaryLoader.Item] {
        [.dummy, .dummy]
    }
    
    func resetPagination() {
        pagination = nil
    }
    
    func addToFavorites(id: String) async throws -> Bool {
        return true
    }
}
#endif
