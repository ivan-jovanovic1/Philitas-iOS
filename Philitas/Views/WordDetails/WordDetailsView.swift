//
//  WordDetails.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

struct WordDetailsView: View {
	@StateObject private var model: WordDetailsStore

	init(wordId: String) {
		_model = StateObject(wrappedValue: .init(wordId: wordId))
	}

	var body: some View {
		Group {
			switch model.state {
			case .loading:
				ProgressView()
					.progressViewStyle(.circular)
			case let .error(error):
				Text("Prislo je do napake \(error.localizedDescription)")
			case let .data(viewModel):
				wordList(viewModel)
			}
		}
		.animation(.easeInOut, value: model.state)
		.navigationTitle("Podrobnosti")
		.toolbar {
			ToolbarItem(placement: .status) {
				Button {
					model.presented = .translate
				} label: {
					Text("Prevedi")
				}
			}
		}
		.onAppear(perform: model.loadWordDetails)
		.sheet(
			isPresented: model.presented?.isPresented(subview: .translate) ?? .constant(false),
			content: translateSheet
		)
	}
}

// MARK: - View components

extension WordDetailsView {

	@ViewBuilder
	fileprivate func wordList(_ viewModel: WordDetailsStore.ViewModel) -> some View {
		List {
			Section(header: Text("Beseda v izvirni obliki").font(.headline)) {
				WordRow(word: viewModel.word, language: viewModel.language)
			}

			if !viewModel.translations.isEmpty {
				Section(header: Text("PREVODI").font(.headline)) {
					ForEach(viewModel.translations) { translation in
						WordRow(word: translation.word, language: translation.language)
					}
				}
			}

			ForEach(viewModel.dictionaries) { dict in
				Section(
					header: Text("Razlage").font(.headline),
					footer: dictionaryFooter(
						name: dict.dictionaryName,
						source: dict.source
					)
				) {
					ForEach(dict.explanations, id: \.self) { description in
						Text(description)
					}
				}
			}
		}
		.listStyle(.insetGrouped)
	}

	@ViewBuilder
	fileprivate func translateSheet() -> some View {
		//        TranslateView(word: model.singleWord)
	}

	@ViewBuilder
	fileprivate func dictionaryFooter(name: String, source: String) -> some View {
		if let url = URL(string: source.urlEncoded) {
			Link(name, destination: url)
		}
		else {
			Text(name)
		}
	}

	@ViewBuilder
	fileprivate func languageCell(
		_ language: String,
		_ languageFullName: String
	) -> some View {
		ZStack {
			VStack {
				Text(languageFullName)
					.fontWeight(.light)
					.font(.body)

				Text(language.uppercased())
					.fontWeight(.ultraLight)
					.font(.caption)
			}
			.padding(.vertical, 4)
		}
		.frame(maxWidth: .infinity)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color.purple, lineWidth: 1)
		)
	}

}

// MARK: - Previews

#if DEBUG
	extension WordDetailsView {
		fileprivate init(
			_ store: WordDetailsStore
		) {
			_model = StateObject(wrappedValue: store)
		}
	}

	struct WordDetailsView_Previews: PreviewProvider {
		struct Preview: View {
			let word = WordDetailsStore.ViewModel(
				id: UUID().uuidString,
				word: "beseda",
				translations: [
					Translation(language: "en", word: "word"),
					Translation(language: "sr", word: "реч"),
				],
				language: "sl",
				dictionaries: [
					WordDetailsStore.Dictionary(
						explanations: .init(repeating: "some explanation", count: 10),
						dictionaryName: "Some dictionary",
						source: "www.example.com"
					)
				]
			)
			var body: some View {
				WordDetailsView(store)
			}

			var store: WordDetailsStore {
				let store = WordDetailsStore(wordId: "")
				store.state = .data(word)
				return store
			}
		}

		static var previews: some View {
			Preview()
				.previewDevice("iPhone 13 Pro")
		}
	}
#endif
