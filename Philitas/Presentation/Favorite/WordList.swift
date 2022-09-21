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
            switch store.favorites {
            case .loading:
                ProgressView()
            case let .error(error):
                Text(error.localizedDescription)
            case let .data(data):
                wordList(data)
            }
        }
        .navigationViewStyle(.stack)
        .background(.red)
        .task { await store.loadFavorites() }
        .onReceive(session.$user) { user in
            Task {
                await store.loadFavorites(refreshing: true)
            }
        }
    }
    
    @ViewBuilder
    func wordList(_ data: [WordListLoader.Item]) -> some View {
        List(data) { word in
            NavigationLink(destination: wordDetails(id: word.id)) {
                WordRow(
                    word: word.name,
                    language: word.language,
                    translated: ""
                )
            }
            if store.shouldShowNextPage(word: word) {
                ProgressView()
                    .task { await store.loadFavorites() }
            }
        }
        .animation(.spring(), value: store.favorites)
        .refreshable { await store.loadFavorites(refreshing: true) }
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
