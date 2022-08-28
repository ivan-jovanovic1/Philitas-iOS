//
//  FavoriteUpdater+DefaultImplementation.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/08/2022.
//

import Foundation

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
