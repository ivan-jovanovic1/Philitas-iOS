//
//  Pagination.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

struct Pagination: Codable {
    let currentPage: Int
    let allPages: Int
    let pageSize: Int
}

extension Pagination {
    func hasNextPage() -> Bool {
        currentPage < allPages
    }

    func nextPage() -> Int {
        currentPage < allPages ? currentPage + 1 : allPages
    }
}
