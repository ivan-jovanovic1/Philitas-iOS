//
//  LoginView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: LoginStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: LoginStore.Field?
    
    init(service: SessionUpdater) {
        _store = StateObject(wrappedValue: LoginStore(service: service))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                loginSection()
                    .padding(.horizontal, 16)
                Spacer()
            }
            .background(Color(uiColor: .systemGray6))
            .onReceive(store.$userData) {
                if let value = $0 {
                    session.user = value
                    dismiss()
                }
            }
            .onReceive(store.$username) { _ in store.loginError = .none }
            .onReceive(store.$password) { _ in store.loginError = .none }
        }
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
                
                if let error = store.loginError {
                    Text(error.localizedDescription)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .textFieldStyle(.roundedBorder)
            .animation(.spring(), value: store.loginError)
            .padding(.bottom, 80)
        } header: {
            Text("Prijava").font(.largeTitle)
        } footer: {
            AsyncButton(action: store.login) {
                Text("Prijava").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .onSubmit { store.process(focusedField: &focusedField) }
    }
}



// MARK: - Previews
struct LoginView_Previews: PreviewProvider {
    private static let firstService = SessionServiceMock()
    private static let secondService = SessionServiceMock()
    
    private static let firstSession = Session(service: firstService)
    private static let secondSession = Session(service: secondService)
    
    static var previews: some View {
        LoginView(service: firstService)
            .environmentObject(firstSession)
            .previewDevice("iPhone 13 Pro")
        
        LoginView(service: secondService)
            .environmentObject(secondSession)
            .previewDevice("iPhone 8")
    }
}
