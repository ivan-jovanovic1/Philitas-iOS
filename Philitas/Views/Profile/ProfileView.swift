//
//  ProfileView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var model = ProfileModel()
    @State private var isSheetPresented = false

    var body: some View {
        VStack {
            if session.user == nil {
                Text("Hello,xr world!")

                Button {
                    isSheetPresented = true
                } label: {
                    Text("Prijava")
                }
            }
            else {
                Text("Seznam")
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            LoginView(loader: SessionService())
        }
        .onAppear {
            isSheetPresented = session.user == nil
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
                jwsToken: UUID().uuidString
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
