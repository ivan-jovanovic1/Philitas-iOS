//
//  ServicePresentation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//


protocol ServicePresentation {
    var baseURL: String { get }
    
    var firstComponent: String { get }
    
    func url(endpoint: String, params: URLParams) -> String
}

extension ServicePresentation {
    func url(endpoint: String, params: URLParams) -> String {
        baseURL + firstComponent + endpoint + params.string()
    }
}

