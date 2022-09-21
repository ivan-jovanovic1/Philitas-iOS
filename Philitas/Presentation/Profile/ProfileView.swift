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
            .background(Color(uiColor: .systemGray6))
            
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
        VStack {
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
        .background(Color(uiColor: .systemGray6))
    }
}

// MARK: - Main view
private extension ProfileView {
    func mainView(user: SessionLoader.User) -> some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            Form {
                section(user: user)
                section(email: user.email)
                evidenceSection(user: user)
                logout {
                    await session.logout()
                }
            }
        }
        .sheet(isPresented: store.isPresented(view: .favorites)) {
            WordList(title: "Priljubljeno", service: WordListService(pageSize: 25, list: .favorites))
        }
        .sheet(isPresented: store.isPresented(view: .history)) {
            WordList(title: "Zgodovina", service: WordListService(pageSize: 25, list: .history))
        }
    }
    
    func section(user: SessionLoader.User) -> some View {
        Section {
            HStack {
                Text("Uporabniško ime")
                Spacer()
                Text(user.username)
            }
            nameRow(user: user)
        } header: {
            header(imageName: "person", description: "Ime")
        }
    }
    
    @ViewBuilder
    func nameRow(user: SessionLoader.User) -> some View {
        if
            let firstName = user.firstName,
            let lastName = user.lastName {
            
            HStack {
                Text("Ime in priimek")
                Spacer()
                Text(store.fullName(firstName: firstName, lastName: lastName))
            }
        }
        else {
            EmptyView()
        }
    }
    
    func section(email: String) -> some View {
        Section {
            Text(email.lowercased())
        } header: {
            header(imageName: "envelope", description: "E-naslov")
        }
    }
    
    @ViewBuilder
    func evidenceSection(user: SessionLoader.User) -> some View {
        if
            let favorites = user.favoritesCount,
            let history = user.historyCount {
            let elements = [
                Evidence(count: favorites, title: "Priljubljene besede", list: .favorites),
                Evidence(count: history, title: "Ogledane besede", list: .history),
            ]
            
            Section {
                ForEach(elements, id: \.title) { element in
                    HStack {
                        Text(element.title)
                        Spacer()
                        Text("\(element.count)")
                    }
                    .background(Color.white.opacity(0.000001))
                    .onTapGesture {
                        store.presented = element.list
                    }
                }
            } header: {
                header(imageName: "note.text", description: "Evidenca")
            }
        }
        else {
            EmptyView()
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
    
    struct Evidence {
        let count: Int
        let title: String
        let list: WordLists
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
