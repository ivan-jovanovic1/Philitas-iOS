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
    }
}

extension DashboardView {
    @ViewBuilder
    private func tabView(_ item: TabItem) -> some View {
        //        if item == .profile, session.user == nil {
        //            EmptyView()
        //        } else {
        item.mainView
            .tabItem {
                Label(item.description, systemImage: item.iconSystemName)
            }
        //        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .previewDevice("iPhone 13 Pro")
    }
}
