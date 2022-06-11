//
//  Paginatable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

protocol Paginatable: AnyObject {
    var pageSize: Int { get }
    var pagination: Pagination? { get set }

    func shouldShowNextPage(isLastWord: Bool) -> Bool
    func resetPagination()
}

extension Paginatable {
    func shouldShowNextPage(isLastWord: Bool) -> Bool {
        isLastWord && pagination?.hasNextPage() ?? false
    }
    
    func resetPagination() {
        pagination = nil
    }
}
