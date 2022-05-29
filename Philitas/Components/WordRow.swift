//
//  WordRow.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI

struct WordRow: View {
    let word: String
    let translated: String?
    let language: String

    init(
        word: String,
        language: String,
        translated: String? = nil
    ) {
        self.word = word
        self.language = language
        self.translated = translated
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(word.capitalized)
                    .font(.body)

                if let translated = translated {
                    Text(translated)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            ZStack(alignment: .center) {
                Circle().fill()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue.opacity(0.2))

                Text(language.prefix(2))
            }
        }
    }
}
