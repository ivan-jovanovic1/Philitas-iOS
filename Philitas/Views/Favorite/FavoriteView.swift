//
//  FavoriteView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import SwiftUI

struct FavoriteView<T: FavoriteLoader>: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: FavoriteStore<T>
    
    init(
        service: T,
        selectedTab: Binding<TabItem>
    ) {
        _store = StateObject(wrappedValue: FavoriteStore(service: service))
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
    func wordList(_ data: [T.Item]) -> some View {
        List(data) { word in
            NavigationLink(destination: wordDetails(id: word.id)) {
                WordRow(
                    word: word.word,
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
        .navigationTitle("Priljubljeno")
    }
    
    func wordDetails(id: String) -> some View {
        WordDetailsView(loader: WordDetailsService(wordId: id))
            .onDisappear() {
                Task {
                    await session.verifyJWSToken()
                }
            }
    }
}
