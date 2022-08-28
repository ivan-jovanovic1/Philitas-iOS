//
//  FavoriteService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation
import Networking

class FavoriteService {
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

// MARK: - FavoriteLoader conformation
extension FavoriteService: FavoriteLoader {
    func load() async throws-> [FavoriteLoader.Item] {
        let response = try await APIRequest(
            Endpoint.wordIdToFavorites,
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
