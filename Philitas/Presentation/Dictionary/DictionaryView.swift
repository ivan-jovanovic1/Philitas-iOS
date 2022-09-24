//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: DictionaryStore
    
    init(service: any DictionaryLoader & FavoriteUpdater) {
        _store = StateObject(wrappedValue: DictionaryStore(service: service))
    }
    
    var body: some View {
        NavigationView {
            switch (store.searchWords ?? store.allWords) {
            case .loading:
                ProgressView()
            case let .error(error):
                List {
                    Text(error.localizedDescription)
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .refreshable {
                    await store.loadWords(refreshing: true)
                }
            case let .data(data):
                wordList(data)
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: store.searchString) {
            guard $0.isEmpty else { return }
            store.searchWords = .none
        }
        .task {
            guard store.allWords == .loading else { return }
            await store.loadWords() }
    }
    
    @ViewBuilder
    func wordList(_ data: [DictionaryLoader.Item]) -> some View {
        BaseWordList(
            items: data.map { BaseWordViewModel(word: $0) },
            shouldShowNextPage: store.shouldShowNextPage,
            loadNextPage: {  await store.loadWords() },
            destination: wordDetails,
            swipeContent: swipeContent
        )
        .navigationTitle("Slovar")
        .refreshable { await store.loadWords(refreshing: true) }
        .searchable(
            text: $store.searchString,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Iskanje"
        )
        .onSubmit(of: .search) {
            Task { await store.performSearch() }
        }
    }
    
    func wordDetails(id: String) -> some View {
        WordDetailsView(service: WordDetailsService(wordId: id))
            .onDisappear() {
                Task {
                    await session.verifyJWSToken()
                }
            }
    }
    
    @ViewBuilder
    func swipeContent(wordId: String) -> some View {
        if session.user != .none {
            Button {
                Task {
                    store.addToFavorites(wordId: wordId)
                }
            } label: {
                Text("Dodaj med priljubljene")
            }
        }
    }
}

#if DEBUG
struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView(service: DictionaryServiceMock())
            .environmentObject(Session(service: SessionServiceMock()))
            .previewDevice("iPhone 13 Pro")
    }
}
#endif
