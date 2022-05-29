//
//  LoginView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: Session
    @Environment(\.dismiss) private var dismiss

    @State var isValidData = true
    @StateObject private var model: LoginModel
    init(
        session: Session
    ) {
        _model = StateObject(wrappedValue: LoginModel())
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(session: Session())
            .previewDevice("iPhone 13 Pro")

        LoginView(session: Session())
            .previewDevice("iPhone 8")
    }
}
