//
//  APIConfigure.swift
//  Philitas
//
//  Created by Ivan Jovanović on 01/04/2022.
//

import Foundation

enum APIConfigure {
    static var headers: Headers {
        [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json; charset=utf-8",
            "Authorization": Self.authrozitationToken,
        ]
        .compactMapValues { $0 }
    }

    static func configure() {
        Networking.setHeaders(Self.headers)
    }

    static var authrozitationToken: String? {
        if let token = UserDefaults.standard.jwsToken {
            return "Bearer \(token)"
        }
        return nil
    }
}
