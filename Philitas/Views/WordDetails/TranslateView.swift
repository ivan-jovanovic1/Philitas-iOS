//
//  TranslateView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI


class TranslationModel: ObservableObject {
    var from: TranslateCountryCode
    @Published var to: TranslateCountryCode = .en
    let word: Word
    
    init(word: Word) {
        self.word = word
        from = TranslateCountryCode(rawValue: word.language) ?? .sl
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
                
                Image(systemName: "arrow.right")
                
                Picker(selection: $model.from, label: Text(model.to.sloveneTranslate)) {
                    ForEach(TranslateCountryCode.allCases) { code in
                        Text(code.sloveneTranslate)
                        
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
