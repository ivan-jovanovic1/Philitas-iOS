//
//  ServicePresentation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Networking

enum Endpoint: String {
    case listOfWords = "/words/list/all"

    case wordFromId = "/words/byId/{id}"
    case wordFromQuery = "/words/{word}"

    case login = "/users/login"
    case verifyToken = "/users/me"
}

// MARK: - BaseURL conformation

extension Endpoint: BaseURL {
    var baseURL: String {
        "http://localhost:3002"
    }
}
