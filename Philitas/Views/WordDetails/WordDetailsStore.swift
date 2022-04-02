//
//  WordDetailsStore.swift
//  Philitas
//
//  Created by Ivan Jovanović on 27/03/2022.
//

import SwiftUI

class WordDetailsStore: ObservableObject {
	@Published private(set) var wordId: String
	@Published var presented: Presentation? = .none
    @Published var state: DataState<ViewModel> = .loading

	var title: String {
		""
		//        singleWord.word
	}

	var subtitle: String? {
		""
		//        if singleWord.language == "sl" {
		//            return singleWord.translatedWord
		//        }
		//        return singleWord.word
	}

	init(wordId: String) {
		self.wordId = wordId
	}
}

extension WordDetailsStore {
    
    func loadWordDetails() {
    }
    
	func isPresented(view: Presentation) -> Binding<Bool> {
		Binding {
			view == self.presented
		} set: {
            if !$0 {
                self.presented = .none
            }
		}
	}
}

