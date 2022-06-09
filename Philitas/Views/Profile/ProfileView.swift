//
//  ProfileView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store = ProfileStore()
    @State private var isSheetPresented = false
    let service = SessionService()
    
    var body: some View {
        VStack {
            if let user = session.user {
                mainView(user: user)
            } else {
                Text("Hello,xr world!")
                Button {
                    isSheetPresented = true
                } label: {
                    Text("Prijava")
                }
            }
        }
        .sheet(
            isPresented: $isSheetPresented,
            content: loginSheet
        )
        .onAppear {
            isSheetPresented = session.user == nil
            store.session = session
            store.checkForFullName()
        }
    }
    
    @ViewBuilder
    private func mainView(user: SessionLoader.User) -> some View {
        NavigationView{
            List {
                Section {
                    Text(user.username)
                    Text(user.email)
                    if let fullName = store.fullName {
                        Text(fullName)
                    }
                } header: {
                    Text("Osebni podatki")
                }
            }
            .navigationTitle("Profil")
        }
    }
    
    @ViewBuilder
    private func loginSheet() -> some View {
        NavigationView {
            LoginView(loader: service)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Zapri") {
                            isSheetPresented.toggle()
                        }
                    }
                }
        }
    }
}

// MARK: - Previews
struct ProfileView_Previews: PreviewProvider {
    private class SessionServiceMock: SessionLoader {
        func loadFromToken() async throws -> SessionLoader.User {
            .init(
                username: "Ivan",
                email: "ivan.jovanovic@student.um.si",
                jwsToken: UUID().uuidString
            )
        }
        
        func login(username: String, password: String) async throws -> SessionLoader.User {
            .init(
                username: "Ivan",
                email: "ivan.jovanovic@student.um.si",
                jwsToken: UUID().uuidString
            )
        }
    }
    
    private struct Preview: View {
        @StateObject private var session: Session
        init() {
            let session = Session(loader: SessionServiceMock())
            session.user = .init(
                username: "Ivan",
                email: "ivan.jovanovic@student.um.si",
                jwsToken: UUID().uuidString,
                firstName: "Ivan",
                lastName: "Jovanović"
            )
            _session = StateObject(wrappedValue: session)
        }
        var body: some View {
            ProfileView()
                .environmentObject(session)
            
        }
    }
    
    static var previews: some View {
        Preview()
            .previewDevice("iPhone 13 Pro")
    }
}
