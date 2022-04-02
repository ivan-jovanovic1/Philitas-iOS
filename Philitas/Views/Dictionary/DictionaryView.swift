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
			List(store.words) { word in
                NavigationLink(destination: WordDetailsView(wordId: word.id)) {
					WordRow(
						word: word.word,
						language: word.language,
						translated: ""
					)
				}

				if store.shouldShowNextPage(word: word) {
					ProgressView()
						.task(store.loadWords)
					//                        .onAppear(perform: model.loadWords)
				}
			}

			.searchable(
				text: $store.searchString,
				placement: .navigationBarDrawer(displayMode: .always),
				prompt: "Iskanje"
			) {
				//                ForEach(model.searchWords) { word in
				//                        WordRow(
				//                            word: word.word,
				//                            language: word.language,
				//                            translated: word.translation
				//                        )
				//                }
			}
			.navigationTitle("Slovar")
		}
		.background(.red)
		.task(store.loadWords)
		.refreshable(action: store.loadWords)
		.onReceive(store.$searchString.debounce(for: 0.5, scheduler: DispatchQueue.main)) { _ in
			store.searchForWords()
		}
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
