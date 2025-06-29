//
//  FavoriteView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import SwiftUI

struct WordList: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: WordListStore
    let title: String
    
    init(title: String, service: WordListLoader) {
        _store = StateObject(wrappedValue: WordListStore(service: service))
        self.title = title
    }
    
    var body: some View {
        NavigationView {
            switch store.allWords {
            case .loading:
                ProgressView()
            case let .error(error):
                List {
                    Text(error.localizedDescription)
                }
                .refreshable {
                    await store.loadItems(refreshing: true)
                }
            case let .data(data):
                wordList(data)
            }
        }
        .navigationViewStyle(.stack)
        .background(.red)
        .task { await store.loadItems() }
        .onReceive(session.$user) { user in
            Task {
                await store.loadItems(refreshing: true)
            }
        }
    }
    
    @ViewBuilder
    func wordList(_ data: [WordListLoader.Item]) -> some View {
        BaseWordList(
            items: data.map { BaseWordViewModel(word: $0) },
            shouldShowNextPage: store.shouldShowNextPage,
            loadNextPage: { await store.loadItems() },
            destination: wordDetails,
            swipeContent: { _ in EmptyView() }
        )
        .animation(.spring(), value: store.allWords)
        .refreshable { await store.loadItems(refreshing: true) }
        .navigationTitle(title)
    }
    
    func wordDetails(id: String) -> some View {
        WordDetailsView(service: WordDetailsService(wordId: id))
            .onDisappear() {
                Task {
                    await session.verifyJWSToken()
                }
            }
    }
}
