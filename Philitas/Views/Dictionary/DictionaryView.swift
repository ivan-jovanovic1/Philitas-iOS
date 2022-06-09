//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView<T: DictionaryLoader>: View {

    @Environment(\.isSearching) var isSearching
    @StateObject private var store: DictionaryStore<T>

    init(
        loader: T
    ) {
        _store = StateObject(wrappedValue: DictionaryStore(loader: loader))
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
        .onChange(of: isSearching) {
            if !$0 {
                store.resetSearchState()
            }
        }
    }

    @ViewBuilder
    func wordList(_ data: [T.Item]) -> some View {
        List(data) { word in
            NavigationLink(
                destination: WordDetailsView(loader: WordDetailsService(wordId: word._id))
            ) {
                WordRow(
                    word: word.word,
                    language: word.language,
                    translated: ""
                )
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
        private class DictionaryServiceMock: DictionaryLoader {
            var pageSize: Int = 25

            var pagination: Pagination?

            func shouldShowNextPage(isLastWord: Bool) -> Bool {
                true
            }

            func load() async throws -> [DictionaryLoader.Item] {
                [.dummy, .dummy, .dummy, .dummy]
            }

            func resetPagination() {
                pagination = nil
            }
        }

        static var previews: some View {
            DictionaryView(loader: DictionaryServiceMock())
                .previewDevice("iPhone 13 Pro")
        }
    }
#endif
