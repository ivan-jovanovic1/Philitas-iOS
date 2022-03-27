//
//  ContentView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

struct DictionaryView: View {
    
    @StateObject private var model = DictionaryModel()
    
    var body: some View {
        NavigationView {
            List(model.words) { word in
                
                NavigationLink(destination: WordDetailsView(word: word)) {
                    
                    
                    WordRow(
                        word: word.word,
                        language: word.language,
                        translated: word.translatedWord
                    )
                    
                    
                    

                }
                
                if model.shouldShowNextPage(word: word) {
                    ProgressView()
                        .onAppear(perform: model.getWords)
                }
            }
            .searchable(text: $model.searchString) {
                ForEach(model.searchWords) { word in
                    Text(word.word.capitalized)
//                    Text(word.word.capitliz)
                    
                }
                

//                ForEach(model.searchResult) { result in
//
//                    Text(result.name.capitalized).searchCompletion(result.name)
//                }
            }
            .navigationTitle("Dictionary")
        }
        .background(.red)
        .onAppear(perform: model.getWords)
        .onReceive(model.$searchString.debounce(for: 0.5, scheduler: DispatchQueue .main)) { _ in
            model.searchForWords()
        }
//        .refreshable(action: model.updateCurrentMostPopular)
        
        
    }
}


struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .previewDevice("iPhone 13 Pro")
    }
}
