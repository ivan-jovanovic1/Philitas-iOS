//
//  APIRequest.swift
//  Philitas
//
//  Created by Ivan Jovanović on 31/03/2022.
//

import Foundation


/**
 Represents an request which supports "GET, POST, PUT and DELETE" methods.
 */
public struct APIRequest<URLBase> where URLBase: BaseURL {

    private var request: URLRequest
    
    /**
      Initializes a new APIRequest
     
      - Parameters:
         - url: The url that conforms to `BaseURL` protocol.
         - param: The query params which will be added after the `url` param.
         - method: The HTTP method.
      */
    init(
        _ url: URLBase,
        params: [String: Any] = [:],
        method: Networking.HttpMethod
    ) throws {
        guard var urlComponents = URLComponents(string: url.fullURL) else {
            throw Networking.NetworkError.invalidURL(url: url.fullURL)
        }
        
        urlComponents.queryItems = Networking.toQueryItems(params)
        
        guard let urlRequest = urlComponents.url else {
            throw Networking.NetworkError.invalidURL(url: urlComponents.url?.description ?? url.fullURL)
        }
        
        self.request = URLRequest(url: urlRequest)
        self.request.httpMethod = method.name
        Networking.addHeadersToRequest(&self.request)
    }
}

public extension APIRequest {
    
    /// Adds body to the HTTP method.
    ///
    /// - Parameter encodable: A type that conforms to  `Encodable`.
    func setBody<E: Encodable>(_ encodable: E) throws -> APIRequest {
        var request = self
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        request.request.httpBody = try encoder.encode(encodable)
        return request
    }
    
    ///  Performs the api request.
    ///
    ///  - Returns: A decoded response.
    func perform<D: Decodable>() async throws -> D {
        let (data, response) = try await URLSession.shared.data(for: self.request)
        
        Networking.logRequest(request: self.request)
        
        
        // Uncomment the following line if you want to see the response
//         Networking.logResponse(response: response, data: data)
        
        if let error = Networking.Response.verify(response: response) {
            throw error
        }
        
        guard let value = try? JSONDecoder().decode(D.self, from: data) else {
            throw Networking.NetworkError.decodingError(D.self)
        }
        
        return value
    }
}

