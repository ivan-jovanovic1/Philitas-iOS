//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView: View {
    
    @StateObject private var model: DictionaryModel
    
    init() {
        self._model = StateObject(wrappedValue: DictionaryModel())
    }
    
    var body: some View {
        NavigationView {
            List(model.words) { word in
                
//                NavigationLink(destination: WordDetailsView(word: word) {
                NavigationLink(destination: VStack {Text(word.word) } ) {
                    WordRow(
                        word: word.word,
                        language: word.language,
                        translated: ""
                    )
                }
                
                if model.shouldShowNextPage(word: word) {
                    ProgressView()
                        .task(model.loadWords)
//                        .onAppear(perform: model.loadWords)
                }
            }
            .searchable(text: $model.searchString, prompt: "Iskanje") {
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
        .task(model.loadWords)
        .refreshable(action: model.loadWords)
        .onReceive(model.$searchString.debounce(for: 0.5, scheduler: DispatchQueue .main)) { _ in
            model.searchForWords()
        }
    }
}


struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .previewDevice("iPhone 13 Pro")
    }
}
