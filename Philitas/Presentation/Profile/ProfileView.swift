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
    @Environment(\.currentTab) private var currentTab
    
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
            .navigationBarHidden(session.user != nil)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            store.session = session
        }
        .onChange(of: currentTab) {
            store.checkForUpdate(tabItem: $0)
        }
    }
}

// MARK: - Login or Register
private extension ProfileView {
    @ViewBuilder
    var loginOrRegister: some View {
        Text("""
        \(Image(systemName: "info.circle")) Za ogled profila se morate prijaviti.
        V primeru da še nimate računa, Vam je na voljo registracija.
        Račun Vam omogoča dodajanje priljubljenih besed ter pregled zgodovine iskanja besed.
        """
        )
        .font(.title3)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
        
        NavigationLink(isActive: $store.isLoginPresented) {
            LoginView(service: SessionService())
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

// MARK: - Main viewx
private extension ProfileView {
    func mainView(user: SessionLoader.User) -> some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            Form {
                section(username: user.username, fullName: store.fullName)
                section(email: user.email)
                if let favoriteWords  = user.favoritesCount {
                                    section(favorites: favoriteWords)

                }
                logout {
                    await session.logout()
                }
            }
        }
    }
    
    func section(username: String, fullName: String?) -> some View {
        Section {
            HStack {
                Text("Uporabniško ime")
                Spacer()
                Text(username)
            }
            
            if let fullName = fullName {
                HStack {
                    Text("Ime in priimek")
                    Spacer()
                    Text(fullName)
                }
            }
        } header: {
            header(imageName: "person", description: "Ime")
        }
    }
    
    func section(email: String) -> some View {
        Section {
            Text(email)
        } header: {
            header(imageName: "envelope", description: "E-naslov")
        }
    }
    
    func section(favorites: Int) -> some View {
        Section {
            HStack {
                Text("Število")
                Spacer()
                Text("\(favorites)")
            }
        } header: {
            header(imageName: "star", description: "Priljubljene besede")
        }
    }
    
    func logout(action: @escaping () async -> Void) -> some View {
        Section {
            AsyncButton(role: .destructive, action: action) {
                HStack {
                    Text("Odjava")
                }
            }
        } header: {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.title2)
                .foregroundColor(.red)
        }
    }
    
    func header(imageName: String, description: String) -> some View {
        HStack {
            Text("\(Image(systemName: imageName))")
                .font(.title2)
            
            Text(description)
                .font(.body)
        }
    }
}

// MARK: - Previews
struct ProfileView_Previews: PreviewProvider {    
    private struct Preview: View {
        @StateObject private var session: Session
        
        init() {
            let session = Session(service: SessionServiceMock())
            session.user = .dummy
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
