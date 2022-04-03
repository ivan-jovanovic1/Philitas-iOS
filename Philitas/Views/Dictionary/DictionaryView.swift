//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView: View {
	@StateObject private var store: DictionaryStore

	init() {
		_store = StateObject(wrappedValue: DictionaryStore())
	}

	var body: some View {

		NavigationView {
            switch store.words {
            case .loading:
                ProgressView()
            case .error(let error):
                Text(error.localizedDescription)
            case .data(let data):
                wordsList(data)
            }
		}
		.navigationViewStyle(.stack)
		.background(.red)
		.task { await store.loadWords() }
//		.onReceive(store.$searchString.debounce(for: 0.5, scheduler: DispatchQueue.main)) { _ in
//
//		}
	}
    
    @ViewBuilder
    func wordsList(_ data: [DictionaryStore.ViewModel]) -> some View {
        List(data) { word in
            NavigationLink(destination: WordDetailsView(wordId: word._id)) {
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
            prompt: "Iskanje"
        ) {
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
        .onSubmit(of: .search) {
            Task { await store.searchForWord() }
        }
        .navigationTitle("Slovar")
    }
}

#if DEBUG
	struct DictionaryView_Previews: PreviewProvider {
		static var previews: some View {
			DictionaryView()
				.previewDevice("iPhone 13 Pro")
		}
	}
#endif
