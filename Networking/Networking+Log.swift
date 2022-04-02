//
//  Networking+Log.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import OSLog

extension Networking {
	static let logger = Logger(subsystem: "ivan.Philitas.networking", category: "NetworkingLibrary")

	static func logRequest(request: URLRequest) {
		Networking.logger.debug(
			"""

			💬📡 REQUEST:
			\(request.cURL)
			######################################################################
			"""
		)
	}

	static func logResponse(response: URLResponse, data: Data) {
		Networking.logger.debug(
			"""

			💬📡 RESPONSE:
			\(response.description)
			💬📡 RESPONSE BODY:
			\(String(data: data, encoding: .utf8) ?? "")
			######################################################################
			"""
		)
	}
}
