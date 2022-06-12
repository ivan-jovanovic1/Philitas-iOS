//
//  AsyncButton.swift
//  Philitas
//
//  Created by Ivan Jovanović on 01/04/2022.
//

import SwiftUI

class AsyncButtonStore: ObservableObject {
    @Published var isPerformingTask = false
    let action: () async -> Void

    init(action: @escaping () async -> Void) {
        self.action = action
    }
}

struct AsyncButton<Label: View>: View {
    @ObservedObject private var store: AsyncButtonStore
    @ViewBuilder let label: () -> Label
    let role: ButtonRole?
    
    init(
        role: ButtonRole? = nil,
        action: @escaping () async -> Void,
        label: @escaping () -> Label
    ) {
        self.label = label
        self.role = role
        self.store = AsyncButtonStore(action: action)
    }

    var body: some View {
        Button(
            role: role,
            action: {
                store.isPerformingTask = true

                Task {
                    await store.action()
                    store.isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    // We hide the label by setting its opacity
                    // to zero, since we don't want the button's
                    // size to change while its task is performed:
                    label().opacity(store.isPerformingTask ? 0 : 1)

                    if store.isPerformingTask {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(store.isPerformingTask)
    }
}

// MARK: - Previews
struct AsyncButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AsyncButton {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } label: {
                Text("Click me")
            }
                       
            AsyncButton(role: .destructive) {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } label: {
                Text("Delete")
            }
            
            AsyncButton {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } label: {
                Image(systemName: "star.fill")
            }
            
            AsyncButton {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } label: {
                Text("Click me")
            }
            .buttonStyle(.bordered)

            AsyncButton {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } label: {
                Text("Click me")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
