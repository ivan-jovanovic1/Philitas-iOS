//
//  TranslateView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI


class TranslationModel: ObservableObject {
    var from: TranslateCountryCode
    @Published var to: TranslateCountryCode
    let word: Word
    
    init(word: Word) {
        self.word = word
        self.from = TranslateCountryCode(rawValue: word.language) ?? .sl
        self.to = .en
    }
    
    var availableLanguages: [TranslateCountryCode] {
        TranslateCountryCode.allCases.filter { $0 != from }
    }
}


struct TranslateView: View {
    
    @StateObject private var model: TranslationModel
    
    
    init(word: Word) {
        self._model = StateObject(wrappedValue: TranslationModel(word: word))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
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

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(word: .dummy)
            .previewDevice("iPhone 13 Pro")
    }
}
