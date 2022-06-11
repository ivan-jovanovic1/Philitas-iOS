//
//  WordDetails.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/02/2022.
//

import SwiftUI

struct WordDetailsView<T: WordDetailsLoader>: View {
    @StateObject private var model: WordDetailsStore<T>
    @State private var isAlertPresented = false
    @State private var error: Error? = nil

    init(
        loader: T
    ) {
        _model = StateObject(wrappedValue: WordDetailsStore(loader: loader))
    }

    var body: some View {
        Group {
            switch model.state {
            case .loading:
                ProgressView()
            case .error(let error):
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 40)
                    .foregroundColor(.red)
                    .opacity(0.5)
                    .onAppear {
                        isAlertPresented.toggle()
                        self.error = error
                    }

            case .data(let viewModel):
                wordList(viewModel)
            }
        }
        .sheet(
            isPresented: model.isPresented(view: .translate),
            content: translateSheet
        )
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Prišlo je do napake"),
                message: Text("\(error?.localizedDescription ?? "")"),
                dismissButton: .cancel(Text("Zapri"), action: {})
            )
        }
        .task(model.loadWordDetails)
    }
}

// MARK: - View components

extension WordDetailsView {

    @ViewBuilder
    fileprivate func wordList(_ viewModel: T.Item) -> some View {
        List {
            Section(header: Text("Beseda v izvirni obliki").font(.headline)) {
                WordRow(word: viewModel.word, language: viewModel.language)
            }

            if viewModel.translations?.isEmpty != true {
                Section(header: Text("PREVODI").font(.headline)) {
                    ForEach(viewModel.translations ?? []) { translation in
                        WordRow(word: translation.word, language: translation.language)
                    }
                }
            }

            ForEach(viewModel.dictionaryExplanations) { dict in
                Section(
                    header: Text("Razlage").font(.headline),
                    footer: dictionaryFooter(
                        name: dict.dictionaryName,
                        source: dict.source
                    )
                ) {
                    ForEach(dict.explanations, id: \.self) { description in
                        Text(description)
                    }
                }
            }

        }
        .listStyle(.insetGrouped)
        .navigationTitle(viewModel.word.capitalized)
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    model.presented = .translate
                } label: {
                    Text("Prevedi")
                }
            }
        }
    }

    @ViewBuilder
    fileprivate func translateSheet() -> some View {
        //        TranslateView(word: model.singleWord)
    }

    @ViewBuilder
    fileprivate func dictionaryFooter(name: String, source: String) -> some View {
        if let url = URL(string: source.urlEncoded) {
            Link(name, destination: url)
        }
        else {
            Text(name)
        }
    }

    @ViewBuilder
    fileprivate func languageCell(
        _ language: String,
        _ languageFullName: String
    ) -> some View {
        ZStack {
            VStack {
                Text(languageFullName)
                    .fontWeight(.light)
                    .font(.body)

                Text(language.uppercased())
                    .fontWeight(.ultraLight)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.purple, lineWidth: 1)
        )
    }

}

// MARK: - Previews
#if DEBUG
    struct WordDetailsView_Previews: PreviewProvider {
        private static let service = WordDetailsServiceMock()

        static var previews: some View {
            WordDetailsView(loader: service)
                .previewDevice("iPhone 13 Pro")
        }
    }
#endif
