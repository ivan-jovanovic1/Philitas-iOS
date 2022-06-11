//
//  FavoriteService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

class FavoriteService {
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

extension FavoriteService: FavoriteLoader {
    func load() async throws-> [FavoriteLoader.Item] {
        let response = try await WordAPI.favorites(page: pagination?.nextPage(), pageSize: pageSize)
        
        pagination = response.pagination
        
        return response.data
    }
}
