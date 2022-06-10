//
//  FavoriteView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 10/06/2022.
//

import SwiftUI


struct FavoriteView<T: FavoriteLoader>: View {
  
  @EnvironmentObject private var session: Session
  @StateObject private var store: FavoriteStore<T>
  
  init(
    service: T,
    selectedTab: Binding<TabItem>
  ) {
    _store = StateObject(wrappedValue: FavoriteStore(service: service))
  }
  
  var body: some View {
    NavigationView {
      switch store.favorites {
      case .loading:
        ProgressView()
      case let .error(error):
        Text(error.localizedDescription)
      case let .data(data):
        wordList(data)
      }
    }
    .navigationViewStyle(.stack)
    .background(.red)
    .task { await store.loadFavorites() }
  }
  
  @ViewBuilder
  func wordList(_ data: [T.Item]) -> some View {
    List(data) { word in
      NavigationLink(
        destination: WordDetailsView(loader: WordDetailsService(wordId: word._id))
      ) {
        WordRow(
          word: word.word,
          language: word.language,
          translated: ""
        )
      }
      if store.shouldShowNextPage(word: word) {
        ProgressView()
          .task { await store.loadFavorites() }
      }
    }
    .refreshable { await store.loadFavorites(refreshing: true) }
    //        .searchable(
    //            text: $store.searchString,
    //            placement: .navigationBarDrawer(displayMode: .always),
    //            prompt: "Iskanje",
    //            suggestions: searchView
    //        )
    //        .onSubmit(of: .search) {
    //            //            Task { await store.searchForWord() }
    //        }
    .navigationTitle("Priljubljeno")
  }
}
