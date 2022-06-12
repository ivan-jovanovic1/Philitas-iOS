//
//  TranslateView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI

class TranslationStore: ObservableObject {
    @Published var to: TranslateCountryCode
    var from: TranslateCountryCode
    let word: Response.Word

    init(word: Response.Word) {
        self.word = word
        from = TranslateCountryCode(rawValue: word.language) ?? .sl
        to = .en
    }

    var availableLanguages: [TranslateCountryCode] {
        TranslateCountryCode.allCases.filter { $0 != from }
    }
}

struct TranslateView: View {
    @StateObject private var store: TranslationStore

    init(word: Response.Word) {
        _store = StateObject(wrappedValue: TranslationStore(word: word))
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                } label: {
                    Text(model.from.sloveneTranslate)
                }
                .frame(maxWidth: .infinity)
                .disabled(true)

                Image(systemName: "arrow.right")

                Picker(model.to.sloveneTranslate, selection: $model.to) {
                    ForEach(model.availableLanguages) { code in
                        Text(code.sloveneTranslate)
                            .disabled(model.from.id == code.id)
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Spacer()

            WordRow(word: model.word.word, language: model.word.language)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews
struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(word: .dummy)
            .previewDevice("iPhone 13 Pro")
    }
}
