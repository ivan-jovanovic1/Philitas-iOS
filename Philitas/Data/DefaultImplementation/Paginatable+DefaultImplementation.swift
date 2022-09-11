//
//  Pagination+DefaultImplementation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/08/2022.
//

import Foundation

extension Paginatable {
    func shouldShowNextPage(isLastWord: Bool) -> Bool {
        isLastWord && pagination?.hasNextPage() ?? false
    }
    
    func resetPagination() {
        pagination = .none
    }
}
