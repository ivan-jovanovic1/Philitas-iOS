//
//  WordService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Networking

enum WordAPI {
    static func singleFromId(id: String) async throws -> Response.BaseResponse<Response.Word> {
        try await APIRequest(
            Endpoint.wordFromId,
            params: [
                "id": id
            ],
            method: .get
        )
        .perform()
    }

    static func singleWord(query: String) async throws -> Response.BaseResponse<Response.Word> {
        try await APIRequest(
            Endpoint.wordFromQuery,
            params: [
                "word": query
            ],
            method: .get
        )
        .perform()
    }

    static func words(
        page: Int?,
        pageSize: Int
    ) async throws -> Response.BaseResponse<[Response.Word]> {
        try await APIRequest(
            Endpoint.listOfWords,
            queryItems: [
                "page": String(page ?? 1),
                "pageSize": String(pageSize),
            ],
            method: .get
        )
        .perform()
    }
}
