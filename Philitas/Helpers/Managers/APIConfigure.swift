//
//  APIConfigure.swift
//  Philitas
//
//  Created by Ivan Jovanović on 01/04/2022.
//

import Foundation
import Networking

enum APIConfigure {
    static var headers: Headers {
        [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json; charset=utf-8",
            "Authorization": Self.authrozitationToken,
        ]
        .compactMapValues { $0 }
    }

    static func configure(userId: String?) {
        var headers = Self.headers
        if let userId {
            headers["User-Id"] = userId
        }
        
        APIHeaders.setHeaders(headers)
    }

    static var authrozitationToken: String? {
        if let token = UserDefaults.standard.jwsToken {
            return "Bearer \(token)"
        }
        return nil
    }    
}
