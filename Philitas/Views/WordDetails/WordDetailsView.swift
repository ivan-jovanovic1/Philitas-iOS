//
//  WordDetails.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

struct WordDetailsView: View {
//	@Environment(\.dismiss) private var dismiss

	@StateObject private var model: WordDetailsStore
	@State private var isAlertPresented = false
	@State private var error: Error? = nil

	init(
		wordId: String
	) {
		_model = StateObject(wrappedValue: .init(wordId: wordId))
	}

	var body: some View {
		Group {
			switch model.state {
			case .loading:
                wordList(Self.dummy)
                    .redacted(reason: .placeholder)
            case .error(let error):
                
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 40)
                    .foregroundColor(.red)
                    .opacity(0.5)
                    .onAppear {
                        isAlertPresented.toggle()
                        self.error = error
                    }

			case .data(let viewModel):
				wordList(viewModel)
			}
		}
		.sheet(
			isPresented: model.isPresented(view: .translate),
			content: translateSheet
		)
		.alert(isPresented: $isAlertPresented) {
			Alert(
				title: Text("Prišlo je do napake"),
				message: Text("\(error?.localizedDescription ?? "")"),
				dismissButton: .cancel(Text("Zapri"), action: {  })
			)
		}
		.task(model.loadWordDetails)
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

extension WordDetailsView {
	fileprivate init(
		_ store: WordDetailsStore
	) {
		_model = StateObject(wrappedValue: store)
	}

	fileprivate static var dummy: WordDetailsStore.ViewModel {
		WordDetailsStore.ViewModel(
			id: UUID().uuidString,
			word: "beseda",
			translations: [
				Translation(language: "en", word: "word"),
				Translation(language: "sr", word: "реч"),
			],
			language: "sl",
			dictionaries: [
				WordDetailsStore.Dictionary(
                    explanations: ["a", "b", "c", "d"],
					dictionaryName: "Some dictionary",
					source: "www.example.com"
				)
			]
		)
	}
}

// MARK: - Previews

#if DEBUG
	struct WordDetailsView_Previews: PreviewProvider {
		static var previews: some View {
			WordDetailsView(wordId: "623f5833575f79e453e16a40")
				.previewDevice("iPhone 13 Pro")
		}
	}
#endif
