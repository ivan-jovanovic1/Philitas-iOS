//
//  WordServiceRepresentable.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

protocol WordServiceRepresentable {

	func singleFromId(id: String) async throws -> Response.BaseResponse<Response.Word>
    
    func singleWord(query: String) async throws -> Response.BaseResponse<Response.Word>

	func words(
		page: Int?,
		pageSize: Int
	) async throws -> Response.BaseResponse<[Response.Word]>
}
