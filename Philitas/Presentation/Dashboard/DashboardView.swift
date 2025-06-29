//
//  DashboardView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var session: Session
    @State private var selection: TabItem = .dictionary
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(TabItem.allCases) { item in
                tabView(item)
            }
        }
        .environment(\.currentTab, selection)
    }
}

extension DashboardView {
    @ViewBuilder
    private func tabView(_ item: TabItem) -> some View {
        Group {
            switch item {
            case .dictionary:
                DictionaryView(service: DictionaryService(pageSize: Constants.pageSize))
                    .tag(item)
            case .profile:
                ProfileView()
                    .tag(item)
            case .favorites:
                if session.user != .none {
                    WordList(title: item.description, service: WordListService(pageSize: Constants.pageSize, list: .favorites))
                    .tag(item)
                } else {
                    EmptyView()
                }
            case .history:
                if session.user != .none {
                    WordList(title: item.description, service: WordListService(pageSize: Constants.pageSize, list: .history))
                    .tag(item)
                } else {
                    EmptyView()
                }

            }
        }
        .tabItem {
            Label(item.description, systemImage: item.iconSystemName)
        }
    }
    
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .previewDevice("iPhone 13 Pro")
    }
}
