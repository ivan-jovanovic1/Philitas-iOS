//
//  BaseResponse.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

extension Response {
    
    struct BaseResponse: Decodable {
        let pagination: Pagination
        let words: [Response.Word]
    }    
}
