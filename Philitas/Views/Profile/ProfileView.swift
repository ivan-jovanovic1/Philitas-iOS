//
//  ProfileView.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: Session
    @StateObject private var store = ProfileStore()
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = session.user {
                    mainView(user: user)
                } else {
                    loginOrRegister
                }
            }
            .animation(.easeInOut, value: session.user)
            .navigationTitle("Profil")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            store.session = session
            store.checkForFullName()
        }
    }
    
    @ViewBuilder
    private func mainView(user: SessionLoader.User) -> some View {
        VStack {
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
            
            Form {
                Section {
                    HStack {
                        Text("Uporabniško ime")
                        Spacer()
                        Text(user.username)
                    }
                    
                    if let fullName = store.fullName {
                        HStack {
                            Text("Ime in priimek")
                            Spacer()
                            Text(fullName)
                        }
                    }
                } header: {
                    header(imageName: "person", description: "Ime")
                }
                
                Section {
                    Text(user.email)
                } header: {
                    header(imageName: "envelope", description: "E-naslov")
                }
                
                
                Section {
                    HStack {
                        Text("Število")
                        Spacer()
                        Text("\(user.favoriteWordIds.count)")
                    }
                } header: {
                    header(imageName: "star", description: "Priljubljene besede")
                }
                
                Section {
                    AsyncButton(role: .destructive) {
                        await session.logout()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Odjava")
                        }
                    }
                }
            }
        }
    }
    
    private func header(imageName: String, description: String) -> some View {
        HStack {
            Text("\(Image(systemName: imageName))")
                .font(.title2)
            
            Text(description)
                .font(.body)
        }
    }
    
    @ViewBuilder
    private var loginOrRegister: some View {
        Text("""
        Za ogled profila se morate prijaviti.
        V primeru da še nimate računa, Vam je na voljo registracija.
        Račun Vam omogoča dodajanje priljubljenih besed ter zgodovino iskanja besed.
        """
        )
        .font(.title3)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
        
        NavigationLink(isActive: $store.isLoginPresented) {
            LoginView(loader: SessionService())
        } label: {
            Button("Prijava") { store.isLoginPresented.toggle() }
                .buttonStyle(.bordered)
        }
        .padding(.horizontal, 16)
        
        LineDivider("ALI")
            .padding(.horizontal, 16)
            .padding(.vertical, 40)
        
        NavigationLink(isActive: $store.isRegistrationPresented) {
            RegistrationView(service: RegistrationService())
        } label: {
            Button("Registracija") { store.isRegistrationPresented.toggle() }
                .buttonStyle(.bordered)
        }
        .padding(.horizontal, 16)
        
        Spacer()
    }
}

// MARK: - Previews
struct ProfileView_Previews: PreviewProvider {    
    private struct Preview: View {
        @StateObject private var session: Session
        init() {
            let session = Session(service: SessionServiceMock())
            session.user = .init(
                id: UUID().uuidString,
                username: "Ivan",
                email: "ivan.jovanovic@student.um.si",
                authToken: UUID().uuidString,
                firstName: "Ivan",
                lastName: "Jovanović",
                favoriteWordIds: []
            )
            _session = StateObject(wrappedValue: session)
        }
        var body: some View {
            ProfileView()
                .environmentObject(session)
            
        }
    }
    
    static var previews: some View {
        Preview()
            .previewDevice("iPhone 13 Pro")
    }
}
