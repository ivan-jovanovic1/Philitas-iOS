//
//  Networking+Headers.swift
//  Philitas
//
//  Created by Ivan Jovanović on 01/04/2022.
//

import Foundation

public typealias Headers = [String: String]

extension Networking {
    enum APIHeaders {
        static var headers: Headers = [:]
    }

    static func addHeadersToRequest(_ request: inout URLRequest) {
        APIHeaders.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

extension Networking {
    public static func setHeaders(_ headers: Headers) {
        APIHeaders.headers = headers
    }
}
