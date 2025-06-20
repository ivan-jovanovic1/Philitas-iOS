//
//  PhilitasApp.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

@main
struct PhilitasApp: App {
    @StateObject private var session: Session

    init() {
        APIConfigure.configure(userId: .none)
        _session = StateObject(wrappedValue: Session(service: SessionService()))
    }

    var body: some Scene {
        WindowGroup {
            AppContainer()
                .environmentObject(session)
        }
    }
}

private extension PhilitasApp {
    struct AppContainer: View {
        @EnvironmentObject private var session: Session

        var body: some View {
            DashboardView()
                .task(session.verifyJWSToken)
        }

    }
    
}
