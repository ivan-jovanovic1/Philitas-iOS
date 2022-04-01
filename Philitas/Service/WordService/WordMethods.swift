//
//  WordMethods.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

protocol WordMethods {
    
    func words(
        page: Int?,
        pageSize: Int
    ) async throws -> Response.BaseResponse<[Response.Word]>
    
}
