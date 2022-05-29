//
//  WordDetailsStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI

class WordDetailsStore: ObservableObject, ViewPresentable {
    @Published var presented: PresentedView?
    @Published var state: DataState<ViewModel> = .loading

    private let wordId: String
    private let service: any WordServiceRepresentable

    init(
        wordId: String,
        service: any WordServiceRepresentable = WordService()
    ) {
        self.wordId = wordId
        self.service = service
    }
}

extension WordDetailsStore {

    @MainActor
    @Sendable
    func loadWordDetails() async {
        state = .loading
        do {
            let wordFromResponse = try await service.singleFromId(id: wordId).data
            state = .data(Self.map(wordFromResponse))
        }
        catch {
            state = .error(error)
        }

    }
}
