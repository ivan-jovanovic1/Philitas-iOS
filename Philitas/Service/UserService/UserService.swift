//
//  UserService.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Alamofire
import Foundation

class UserService: UserMethods {
    
    func login(
        payload: Request.User,
        completionHandler: @escaping (Response.User?, AFError?) -> Void
    ) {
        Task {
            let response = await AF.request(
                .url(.login),
                method: .post,
                parameters: payload,
                encoder: JSONParameterEncoder.default
            )
                .serializingDecodable(Response.User.self)
                .response
            
            DispatchQueue.main.async {
                completionHandler(response.value, response.error)
            }
            
        }
    }
    
}
