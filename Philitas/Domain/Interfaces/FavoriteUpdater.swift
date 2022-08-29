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
