//
//  PhilitasApp.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI


class Session: ObservableObject {
    
    @Published var user: Response.User? = nil
    
}

@main
struct PhilitasApp: App {
    
    @StateObject private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(session)
        }
    }
}
