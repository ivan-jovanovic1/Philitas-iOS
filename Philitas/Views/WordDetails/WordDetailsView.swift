//
//  WordDetails.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

struct WordDetailsView: View {
    
    @StateObject private var model: WordDetailsModel
    
    init(word: Word) {
        self._model = StateObject(wrappedValue: .init(singleWord: word))
    }
    
    var body: some View {
        
        VStack {
                List {
                    Section(header: Text("Beseda v izvirni obliki").font(.headline)) {
                        Text(model.singleWord.word).font(.title3)
                    }
                    
                    if let translatedWord = model.singleWord.translatedWord {
                        Section(header: Text("PREVODI").font(.headline)) {
                            #warning("Change logic to an array with translations and languages")
                            WordRow(word: translatedWord, language: model.singleWord.language == "sl" ? "en" : "sl")
                        }
                    }
                                        
                    ForEach(model.singleWord.dictionaryExplanations) { dict in
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

        }
        .listStyle(.insetGrouped)
        .navigationTitle("Podrobnosti")
        .onAppear(perform: model.loadWordDetails)
        
    }
    
    @ViewBuilder
    private func dictionaryFooter(name: String, source: String) -> some View {
        if let url = URL(string: source.urlEncoded) {
            Link(name, destination: url)
        } else {
            Text(name)
        }
    }
    
    @ViewBuilder
    private func languageCell(_ language: String, _ languageFullName: String) -> some View {
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




struct WordDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailsView(word: .dummy)
            .previewDevice("iPhone 13 Pro")
    }
}
