//
//  WordListStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import Foundation

@MainActor
class WordListStore: ObservableObject {
    weak var session: Session?
    @Published var allWords: DataState<[WordListLoader.Item]> = .loading
    private let service: WordListLoader
    
    init(service: WordListLoader) {
        self.service = service
    }
}

extension WordListStore {
    @Sendable
    func loadItems(refreshing: Bool = false) async {
        if refreshing {
            service.resetPagination()
        }
        
        do {
            let result = try await service.load()
            guard let values = allWords.value else {
                return allWords = .data(result.sorted(by: { $0.name < $1.name }))
            }
            allWords = .data( Array(Set(values + result)) .sorted(by: { $0.name < $1.name }))
            
        } catch {
            allWords = .error(error)
        }
    }
    
    func shouldShowNextPage(word: WordListLoader.Item) -> Bool {
        service.shouldShowNextPage(isLastWord: word.id == allWords.value?.last?.id)
    }
    
    func processStateAfterWordDetailsDisappear(id: String) {
        Task {
            await loadItems(refreshing: true)
         }
    }
}
