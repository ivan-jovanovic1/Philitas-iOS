//
//  Networking+Error.swift
//  Philitas
//
//  Created by Ivan Jovanović on 31/03/2022.
//

import Foundation

public extension Networking {
    enum NetworkError: Error {
        case invalidURL(url: String)
        case notHttpResponse
        case decodingError(_ type: any Decodable.Type)
        case encodingError(_ type: any Encodable.Type)
        case unexpectedStatusCode(code: Int)
        case unknown
    }
}

extension Networking.NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "URL \(url) is not valid."
        case .notHttpResponse:
            return "URL Response is not a valid http response."
        case let .decodingError(type):
            return "Error while trying to decode \(type.self)"
        case let .encodingError(type):
            return "Error while trying to encode \(type.self)"
        case let .unexpectedStatusCode(code):
            return "Unexpected status code \(code)"
        case .unknown:
            return "Unknown networking error"
        }
    }
}
