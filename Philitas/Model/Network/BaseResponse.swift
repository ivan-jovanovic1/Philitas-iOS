//
//  BaseResponse.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

extension Response {
    
    struct BaseResponse<T: Decodable>: Decodable {
        let pagination: Pagination?
        let errorMessage: String?
        let errorCode: Int? 
        let data: T
    }
    
}
