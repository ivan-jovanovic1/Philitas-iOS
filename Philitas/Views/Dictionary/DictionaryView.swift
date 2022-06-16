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
            switch store.words {
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
        .task { await store.loadWords() }

    }

    @ViewBuilder
    func wordList(_ data: [DictionaryLoader.Item]) -> some View {
        List(data) { word in
            NavigationLink(destination: wordDetails(id: word.id)) {
                WordRow(
                    word: word.word,
                    language: word.language,
                    translated: ""
                )
            }
            .swipeActions {
                Button {
                    Task {
                        store.addToFavorites(word: word)
                    }
                } label: {
                    Text("Dodaj med priljubljene")
                }
            }

            if store.shouldShowNextPage(word: word) {
                ProgressView()
                    .task { await store.loadWords() }
            }
        }
        .refreshable { await store.loadWords(refreshing: true) }
        .searchable(
            text: $store.searchString,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Iskanje"
        )
        .onSubmit(of: .search) {
            //            Task { await store.searchForWord() }
        }
        .navigationTitle("Slovar")
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

#if DEBUG
struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView(service: DictionaryServiceMock())
            .previewDevice("iPhone 13 Pro")
    }
}
#endif
