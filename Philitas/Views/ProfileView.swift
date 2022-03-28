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
        
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .sheet(
            isPresented: .constant(true)
        ) {
            if let session = model.session {
                LoginView(session: session)
            }
        }
        .onAppear {
            model.session = session
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 13 Pro")
    }
}
