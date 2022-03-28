//
//  ServicePresentation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//


enum Endpoint: String {
    
    case listOfWords = "/words/list"
    
    
    var baseURL: String {
        "http://localhost:3002"
    }
    
    var fullURL: String {
        baseURL + self.rawValue
    }
        
}
