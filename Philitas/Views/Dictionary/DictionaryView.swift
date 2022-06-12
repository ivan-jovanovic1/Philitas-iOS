//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView<T: DictionaryLoader & FavoriteUpdater>: View {
    @StateObject private var store: DictionaryStore<T>
    let wordDetails: (String) -> WordDetailsView<WordDetailsService>

    init(service: T) {
        _store = StateObject(wrappedValue: DictionaryStore(service: service))
        wordDetails = { WordDetailsView(loader: WordDetailsService(wordId: $0)) }
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
    func wordList(_ data: [T.Item]) -> some View {
        List(data) { word in
            NavigationLink(destination: wordDetails(word.id)) {
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
            prompt: "Iskanje",
            suggestions: searchView
        )
        .onSubmit(of: .search) {
            //            Task { await store.searchForWord() }
        }
        .navigationTitle("Slovar")
    }

    @ViewBuilder
    func searchView() -> some View {
        switch store.wordFromSearch {
        case .loading:
            ProgressView()
        case .error(let error):
            Text(error.localizedDescription)
        case .data(let data):
            Text(data.word)
        case .none:
            EmptyView()
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
