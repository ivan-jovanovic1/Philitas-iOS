//
//  WordListStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

class WordListStore: ObservableObject {
    weak var session: Session?
    @Published var allWords: DataState<[WordListLoader.Item]> = .loading
    private let service: WordListLoader
    
    init(service: WordListLoader) {
        self.service = service
    }
}

extension WordListStore {
    @MainActor
    @Sendable
    func loadItems(refreshing: Bool = false) async {
        if refreshing {
            service.resetPagination()
        }
        
        do {
            let result = try await service.load()
            guard let values = allWords.value, !refreshing else {
                return allWords = .data(result.sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
            }
            allWords = .data( Array(Set(values + result)) .sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
            
        } catch {
            allWords = .error(error)
        }
    }
    
    func shouldShowNextPage(wordId: String) -> Bool {
        service.shouldShowNextPage(isLastWord: wordId == allWords.value?.last?.id)
    }
    
    @MainActor
    func processStateAfterWordDetailsDisappear(id: String) {
        Task {
            await loadItems(refreshing: true)
         }
    }
}
