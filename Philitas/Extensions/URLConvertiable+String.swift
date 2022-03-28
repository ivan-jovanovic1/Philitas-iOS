//
//  URLConvertiable+String.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Alamofire

extension URLConvertible where Self == String {
    static func url(_ endpoint: Endpoint, params: URLParams? = nil) -> URLConvertible {
        endpoint.fullURL + (params?.string() ?? "")
    }
}
