//
//  WordListService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation
import Networking

class WordListService {
    var pageSize: Int
    var pagination: Pagination?
    let list: WordLists
    
    init(
        pageSize: Int,
        pagination: Pagination? = .none,
        list: WordLists
    ) {
        self.pageSize = pageSize
        self.pagination = pagination
        self.list = list
    }
}

// MARK: - FavoriteLoader conformation
extension WordListService: WordListLoader {
    func load() async throws-> [WordListLoader.Item] {
        print("ivan url \(list.url.rawValue)")
        
        let response = try await APIRequest(
            list.url,
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
}

