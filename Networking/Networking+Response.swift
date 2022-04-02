//
//  Networking+Response.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation

extension Networking {
	enum Response {
		/// Verifies an API response.
		/// - Parameter response: An API response.
		/// - Returns: An error of type `Networking.NetworkError` if not valid, nil otherwise.
		static func verify(response: URLResponse) -> Networking.NetworkError? {
			guard let response = response as? HTTPURLResponse else {
				return .notHttpResponse
			}

			return response.statusCode == 200 ? nil : .unexpectedStatusCode(code: response.statusCode)
		}
	}
}
