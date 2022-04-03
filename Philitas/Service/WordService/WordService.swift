//
//  WordService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Networking

class WordService: WordServiceRepresentable {
	func words(
		page: Int?,
		pageSize: Int
	) async throws -> Response.BaseResponse<[Response.Word]> {
		try await APIRequest(
			Endpoint.listOfWords,
			params: [
				"page": page ?? 1,
				"pageSize": pageSize,
			],
			method: .get
		)
		.perform()
	}
}
