//
//  LoginView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct LoginView<T: SessionLoader & SessionUpdater>: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: LoginStore<T>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    init(loader: T) {
        _store = StateObject(wrappedValue: LoginStore(loader: loader))
    }

    var body: some View {
        VStack(alignment: .leading) {
            loginSection()
                .padding(.horizontal, 16)
            Spacer()
        }
        .onReceive(store.$userData) {
            if let value = $0 {
                session.user = value
                dismiss()
            }
        }
        .onReceive(store.$username) { _ in store.showInvalidInput = false }
        .onReceive(store.$password) { _ in store.showInvalidInput = false }
    }
}

extension LoginView {
    private func loginSection() -> some View {
        Section {
            VStack {
                TextField("Uporabniško ime", text: $store.username)
                    .focused($focusedField, equals: .username)
                    .disableAutocorrection(true)

                SecureField("Geslo", text: $store.password)
                    .focused($focusedField, equals: .password)
                    .disableAutocorrection(true)

                if store.showInvalidInput {
                    Text("Vneseno uporabniško ime ali geslo ni pravilno.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .textFieldStyle(.roundedBorder)
            .animation(.spring(), value: store.showInvalidInput)
            .padding(.bottom, 80)
        } header: {
            Text("Prijava").font(.largeTitle)
        } footer: {
            AsyncButton(action: store.login) {
                Text("Prijava").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .onSubmit(processFocusState)
    }
    
    private func processFocusState() {
        if focusedField == .username {
            focusedField = .password
        }
        if focusedField == .password {
            focusedField = nil
            Task {
                await store.login()
            }
        }
    }
}

private extension LoginView {
    enum Field: Hashable {
        case username
        case password
    }
}

// MARK: - Previews
struct LoginView_Previews: PreviewProvider {
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
