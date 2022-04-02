//
//  UserMethods.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import Foundation

protocol UserMethods {
    func login(payload: Request.User) async throws -> Response.BaseResponse<Response.UserData>
    func userFromToken() async throws -> Response.BaseResponse<Response.UserData>
}
