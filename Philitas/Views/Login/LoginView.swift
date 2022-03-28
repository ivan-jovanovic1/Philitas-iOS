//
//  LoginView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct LoginView: View {
    
    @State var isValidData = true
    @StateObject private var model: LoginModel
    init(session: Session) {
        self._model = StateObject(wrappedValue: LoginModel(session: session))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
           loginSection()
            .padding(.horizontal, 16)
            
            LineDivider("ALI")
                .padding(.horizontal, 16)
                .padding(.vertical, 80)
                .hidden()
            
            button("Registracija", action: {})
                .padding(.horizontal, 16)
                .hidden()
        }
    }
}

extension LoginView {
    
    @ViewBuilder
    private func loginSection() -> some View {
        Section(
            header: Text("Login").font(.largeTitle),
            footer: button("Prijava", action: model.login)
        ) {
            VStack {
                TextField("Uporabniško ime", text: $model.username)
                    .disableAutocorrection(true)
 
                SecureField("Password", text: $model.password)
                
                if model.showInvalidInput {
                    Text("Vneseno uporabniško ime ali geslo ni pravilno.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                
            }
            .textFieldStyle(.roundedBorder)
            .padding(.bottom, 80)
        }
    }
    
    @ViewBuilder
    private func button(_ text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
