//
//  LoginView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct LoginView<T: SessionLoader & SessionUpdater>: View {
    @EnvironmentObject private var session: Session
    @Environment(\.dismiss) private var dismiss

    @State var isValidData = true
    @StateObject private var model: LoginStore<T>
    init(
        loader: T
    ) {
        _model = StateObject(wrappedValue: LoginStore(loader: loader))
    }

    var body: some View {
        VStack(alignment: .leading) {
            loginSection()
                .padding(.horizontal, 16)

            LineDivider("ALI")
                .padding(.horizontal, 16)
                .padding(.vertical, 40)
            //                .hidden()

            button("Registriraj se", action: {})
                .padding(.horizontal, 16)
        }
        .onReceive(model.$userData) {
            if let value = $0 {
                session.user = value
                dismiss()
            }
        }
        .onReceive(model.$username) { _ in model.showInvalidInput = false }
        .onReceive(model.$password) { _ in model.showInvalidInput = false }
    }
}

extension LoginView {
    @ViewBuilder
    private func loginSection() -> some View {
        Section(
            header: Text("Prijava").font(.largeTitle),
            footer: button("Prijavi se", action: model.login)
        ) {
            VStack {
                TextField("Uporabniško ime", text: $model.username)
                    .disableAutocorrection(true)

                SecureField("Geslo", text: $model.password)
                    .disableAutocorrection(true)

                if model.showInvalidInput {
                    Text("Vneseno uporabniško ime ali geslo ni pravilno.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .textFieldStyle(.roundedBorder)
            .animation(.spring(), value: model.showInvalidInput)
            .padding(.bottom, 80)
        }
    }

    @ViewBuilder
    private func button(_ text: String, action: @escaping () async -> Void) -> some View {
        AsyncButton(action: action) {
            Text(text).frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Previews
struct LoginView_Previews: PreviewProvider {
    private class SessionServiceMock: SessionLoader, SessionUpdater {
        func logout() async throws -> Bool {
            true
        }
        
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

    private static let firstService = SessionServiceMock()
    private static let secondService = SessionServiceMock()

    private static let firstSession = Session(service: firstService)
    private static let secondSession = Session(service: secondService)

    static var previews: some View {
        LoginView(loader: firstService)
            .environmentObject(firstSession)
            .previewDevice("iPhone 13 Pro")

        LoginView(loader: secondService)
            .environmentObject(secondSession)
            .previewDevice("iPhone 8")
    }
}
