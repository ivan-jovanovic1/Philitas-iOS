//
//  BaseWordList.swift
//  Philitas
//
//  Created by Ivan Jovanović on 25/09/2022.
//

import SwiftUI

struct BaseWordList<T, D>: View where T: View, D: View {
    let items: [BaseWordViewModel]
    let shouldShowNextPage: (String) -> Bool
    let loadNextPage: () async -> Void
    @ViewBuilder let destination: (String) -> D
    @ViewBuilder let swipeContent: (String) -> T
    
    var body: some View {
        List(items) { item in
            NavigationLink(destination: { destination(item.id)}) {
                WordRow(
                    word: item.name.capitalized,
                    language: item.language,
                    translated: item.translation
                )
            }
            .swipeActions {
                swipeContent(item.id)
            }
            
            if shouldShowNextPage(item.id) {
                ProgressView()
                    .task { await loadNextPage() }
            }
        }
    }
}
