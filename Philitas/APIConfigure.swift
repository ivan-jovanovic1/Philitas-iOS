//
//  APIConfigure.swift
//  Philitas
//
//  Created by Ivan Jovanović on 01/04/2022.
//

import Foundation

enum APIConfigure {
    
    static func configure() {
        Networking.setHeaders(
            [
                "Content-Type": "application/json; charset=utf-8",
                "Accept": "application/json; charset=utf-8"
            ]
        
        )
    }
}
