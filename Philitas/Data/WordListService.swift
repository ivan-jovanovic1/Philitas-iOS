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
    let endpoint: Endpoint
    
    init(
        pageSize: Int,
        pagination: Pagination? = .none,
        endpoint: Endpoint
    ) {
        self.pageSize = pageSize
        self.pagination = pagination
        self.endpoint = endpoint
    }
}

// MARK: - FavoriteLoader conformation
extension WordListService: WordListLoader {
    func load() async throws-> [WordListLoader.Item] {
        let response = try await APIRequest(
            endpoint.url,
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

extension WordListService {
    enum Endpoint {
        case favorites
        case history
        
        var url: Philitas.Endpoint {
            switch self {
            case .favorites:
                return Philitas.Endpoint.favoriteWords
            case .history:
                return Philitas.Endpoint.historyWords
            }
        }
    }
}
