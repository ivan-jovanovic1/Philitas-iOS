//
//  ServicePresentation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//


enum Endpoint: String, BaseURL {
        
    case listOfWords = "/words/list"
    
    case login = "/users/login"
    
}

// MARK: - BaseURL conformation
extension Endpoint {
    
    var baseURL: String {
        "http://localhost:3002"
    }
    
}
