//
//  WordService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Alamofire
import Foundation

typealias URLParams = [String : Any]

extension URLParams {
    func string() -> String {
       "?" + self.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
    }

}

protocol WordServiceable {
    func list(
        page: Int?,
        pageSize: Int,
        completionHandler: @escaping(_ response: BaseResponse?, _ error: AFError?) -> Void
    )
    
    func singleWord()
    
}



class WordService: ServicePresentation {
    var baseURL: String {
        "http://localhost:3002/"
    }
    var firstComponent: String { "words/" }
    
}

extension WordService: WordServiceable {
    func list(
        page: Int?,
        pageSize: Int,
        completionHandler: @escaping(_ response: BaseResponse?, _ error: AFError?) -> Void
    ) {
        let params: URLParams = [
            "page": page ?? 1,
            "pageSize": pageSize
        ]
        
        Task {
            let response = await AF.request(url(endpoint: "/list", params: params))
                .serializingDecodable(BaseResponse.self).response
            
            DispatchQueue.main.async {
                completionHandler(response.value, response.error)
            }
            
        }
    }
    
    func singleWord() {
        
    }
    
}
