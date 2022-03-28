//
//  ProfileView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI


struct ProfileView: View {
    
    @EnvironmentObject private var session: Session
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
