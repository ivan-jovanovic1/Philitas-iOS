//
//  WordService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Alamofire
import Foundation

protocol WordServiceable {
    func words(
        page: Int?,
        pageSize: Int,
        completionHandler: @escaping(_ response: Response.BaseResponse?, _ error: AFError?) -> Void
    )
    
    func singleWord()
    
}


class WordService: WordServiceable {
    func words(
        page: Int?,
        pageSize: Int,
        completionHandler: @escaping(_ response: Response.BaseResponse?, _ error: AFError?) -> Void
    ) {
        let params: URLParams = [
            "page": page ?? 1,
            "pageSize": pageSize
        ]
        
        Task {
            let response = await AF.request(.url(.listOfWords, params: params))
                .serializingDecodable(Response.BaseResponse.self).response
            
            DispatchQueue.main.async {
                completionHandler(response.value, response.error)
            }
            
        }
    }
    
    func singleWord() {
        
    }
    
}
