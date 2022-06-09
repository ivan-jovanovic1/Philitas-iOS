//
//  WordDetailsStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import Foundation

class WordDetailsStore<T: WordDetailsLoader>: ObservableObject, ViewPresentable {
    @Published var presented: PresentedView? = .none
    @Published var state: DataState<T.Item> = .loading
    private let loader: T

    init(
        loader: T
    ) {
        self.loader = loader
    }
}

extension WordDetailsStore {
    @MainActor
    @Sendable
    func loadWordDetails() async {
        state = .loading
        do {
            let wordFromResponse: T.Item = try await loader.load()
            state = .data(wordFromResponse)
        }
        catch {
            state = .error(error)
        }
    }
}
