//
//  WordMethods.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Alamofire

protocol WordMethods {
    
    func words(
        page: Int?,
        pageSize: Int,
        completionHandler: @escaping(_ response: Response.BaseResponse?, _ error: AFError?) -> Void
    )
    
}
