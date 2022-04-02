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
        APIConfigure.configure()
        self._session = StateObject(wrappedValue: Session())
    }
    
    var body: some Scene {
        WindowGroup {
            AppContainer()
                .environmentObject(session)
        }
    }
}

fileprivate extension PhilitasApp {
    struct AppContainer: View {

        @EnvironmentObject private var session: Session
        
        var body: some View {
            DashboardView()
                .task(session.verifyJWSToken)
                
                
            
        }
        
    }
}
