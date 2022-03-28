//
//  UserMethods.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation
import Alamofire

protocol UserMethods {
    
    func login(
        payload: Request.User,
        completionHandler: @escaping(_ response: Response.User?, _ error: AFError?) -> Void
    )
}

