//
//  WordView.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/24/21.
//

import SwiftUI

struct WordView: View {
    @ObservedObject var model: WordViewModel
    
    var body: some View {
        Group {
            Text(model.filledWord)
                .foregroundColor(model.filledWordColor) +
            Text(model.unfilledWord)
                .foregroundColor(model.unfilledWordColor)
        }
        .font(model.wordFont)
    }
    
    init(word: String, lettersFilled: Int) {
        self.model = WordViewModel(word: word, lettersFilled: lettersFilled)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(word: "hello", lettersFilled: 3)
    }
}
