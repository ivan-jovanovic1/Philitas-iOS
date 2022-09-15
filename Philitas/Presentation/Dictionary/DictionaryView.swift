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
        .task { await store.loadWords() }
    }
    
    @ViewBuilder
    func wordList(_ data: [DictionaryLoader.Item]) -> some View {
        List(data) { item in
            NavigationLink(destination: wordDetails(id: item.id)) {
                WordRow(
                    word: item.word,
                    language: item.language,
                    translated: item.translations?.first?.word ?? ""
                )
            }
            .swipeActions {
                Button {
                    Task {
                        store.addToFavorites(word: item)
                    }
                } label: {
                    Text("Dodaj med priljubljene")
                }
            }
            
            if store.shouldShowNextPage(word: item) {
                ProgressView()
                    .task { await store.loadWords() }
            }
        }
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
