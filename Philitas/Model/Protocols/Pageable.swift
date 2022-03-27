//
//  Pageable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

protocol Pageable {
    var pageSize: Int { get }
    var pagination: Pagination? { get set }
}
