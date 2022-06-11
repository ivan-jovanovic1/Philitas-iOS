//
//  Registration.swift
//  Philitas
//
//  Created by Ivan Jovanović on 11/06/2022.
//

import SwiftUI

struct RegistrationView: View {    
    @FocusState private var focusedField: RegistrationStore.Field?
    @StateObject private var store: RegistrationStore

    init() {
        _store = StateObject(wrappedValue: RegistrationStore())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Vnesite podatke. Polja **označena z zvezdico** so obvezna polja.")
                    .padding(.horizontal, 15)
                    .font(.body)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 24)
                
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
                    AsyncButton(action: {}) {
                        Text("Registriraj se").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 40)
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 16)
                
                Spacer()
//                    .animation(.spring(), value: store.invalidInput)
            }
            .onSubmit {
                focusedField = focusedField?.next()
                if focusedField == nil {
                    // register
                }
            }
            .navigationTitle("Registracija")
            
        }
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
        RegistrationView()
            .previewDevice("iPhone 13 Pro")
    }
}
