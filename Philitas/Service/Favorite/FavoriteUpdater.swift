//
//  FavoriteUpdater.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

protocol FavoriteUpdater: AnyObject {
    func updateFavorites(id: String, shouldBeInFavorites: Bool) async throws -> Bool
}

extension FavoriteUpdater {
    func updateFavorites(id: String, shouldBeInFavorites: Bool) async throws -> Bool {
        switch shouldBeInFavorites {
        case true:
            let selected = try await UserAPI.addToFavorites(id: id).data
            return selected
        case false:
            let deselected = try await UserAPI.removeFromFavorites(id: id).data
            return !deselected
        }
    }
}
