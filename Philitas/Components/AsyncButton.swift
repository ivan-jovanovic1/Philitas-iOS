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

    init(
        action: @escaping () async -> Void
    ) {
        self.action = action
    }
}

struct AsyncButton<Label: View>: View {
    @ViewBuilder let label: () -> Label
    @ObservedObject private var store: AsyncButtonStore

    init(
        action: @escaping () async -> Void,
        label: @escaping () -> Label
    ) {
        self.label = label
        self.store = AsyncButtonStore(action: action)
    }

    var body: some View {
        Button(
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
