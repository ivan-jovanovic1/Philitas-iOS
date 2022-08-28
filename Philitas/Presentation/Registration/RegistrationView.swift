//
//  Registration.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store: RegistrationStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: RegistrationStore.Field?
    
    init(service: RegistrationValidator & RegistrationFormSender) {
        _store = StateObject(wrappedValue: RegistrationStore(service: service))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                instructions
                section
                Spacer()
            }
            .alert("Napaka pri registraciji", isPresented: $store.showErrorAlert) {
                Button("V redu", role: .cancel) { }
            }
            .onSubmit {
                store.process(focusedField: &focusedField)
            }
            .onReceive(store.$inputs.debounce(for: 0.5, scheduler: DispatchQueue.main)) { _ in
                store.updateCompleteButton()
            }
            .onReceive(store.$userData) {
                if let userData = $0 {
                    session.user = userData
                    dismiss()
                }
            }
            .navigationTitle("Registracija")
        }
    }
    
    private var instructions: some View {
        Text("Vnesite podatke. Polja **označena z zvezdico** so obvezna polja.")
            .padding(.horizontal, 15)
            .font(.body)
            .foregroundColor(.accentColor)
            .padding(.vertical, 24)
    }
    
    private var section: some View {
        Section {
            ForEach(RegistrationStore.Field.allCases) { field in
                inputField(for: field)
            }
            
            if let invalidInput = store.invalidInput {
                Text(invalidInput.localizedDescription)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        } footer: {
            AsyncButton(action: store.register) {
                Text("Registriraj se").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!store.isCompleteRegistrationEnabled)
            .padding(.top, 40)
        }
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal, 16)
        .animation(.spring(), value: store.invalidInput)
    }
    
    @ViewBuilder
    private func inputField(for field: RegistrationStore.Field) -> some View {
        if field.isSecureField {
            SecureField(field.description, text: $store.inputs[field.rawValue])
                .focused($focusedField, equals: field)
                .disableAutocorrection(true)
        } else {
            TextField(field.description, text: $store.inputs[field.rawValue])
                .focused($focusedField, equals: field)
                .disableAutocorrection(true)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(service: RegistrationService())
            .previewDevice("iPhone 13 Pro")
    }
}
