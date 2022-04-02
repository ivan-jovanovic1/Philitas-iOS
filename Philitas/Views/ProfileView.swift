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
                } label:  {
                    Text("Prijava")
                }
            } else {
                Text("Seznam")
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            LoginView(session: session)
        }
        .onAppear {
            isSheetPresented = session.user == nil
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 13 Pro")
    }
}
