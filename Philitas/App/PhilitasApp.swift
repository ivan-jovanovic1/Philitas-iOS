//
//  PhilitasApp.swift
//  Philitas
//
//  Created by Ivan Jovanović on 26/02/2022.
//

import SwiftUI

@main
struct PhilitasApp: App {
    @StateObject private var session: Session

    init() {
        APIConfigure.configure(userId: .none)
        _session = StateObject(wrappedValue: Session(service: SessionService()))
    }

    var body: some Scene {
        WindowGroup {
            AppContainer()
                .environmentObject(session)
        }
    }
}

private extension PhilitasApp {
    struct AppContainer: View {
        @EnvironmentObject private var session: Session

        var body: some View {
            DashboardView()
                .task(session.verifyJWSToken)
                .onAppear {
                    print(sumAll([1,2,3], [1, 3, 4], [3, 4, 6]))
                }
        }
        
        func sumAll2(_ arrays: [Int]...) -> Int {
            arrays.reduce(into: .zero) {
                $0 += $1.reduce(into: .zero) {
                    $0 += $1
                }
            }
        }
        
        func sumImperative(_ arrays: [Int]...) -> Int {
            var sum = 0
            for array in arrays {
                for value in array {
                    sum += value
                }
            }
            
            return sum
        }
        
        func sumAll(_ arrays: [Int]...) -> Int {
            arrays.reduce(into: .zero) {
                $0 += $1.reduce(into: .zero, +=)
            }
        }

    }
    
}
