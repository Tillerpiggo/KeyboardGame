//
//  WordView.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/24/21.
//

import SwiftUI

struct WordView: View {
    var word: String
    var lettersFilled: Int
    
    // The index where the unfilled portion of word beings
    private var cutoffIndex: String.Index {
        return word.index(word.startIndex, offsetBy: lettersFilled)
    }
    private var filledWord: String { String(word[..<cutoffIndex]) }
    
    private var unfilledWord: String {
        return String(word[cutoffIndex..<word.endIndex])
        //return lettersFilled > 0 ? String(word[cutoffIndex...word.endIndex]) : ""
    }
    
    var body: some View {
        Group {
            Text(filledWord)
                .foregroundColor(Color(white: 0.2)) +
            Text(unfilledWord)
                .foregroundColor(Color(white: 0.9))
        }
        .font(.system(size: 72, weight: .bold))
    }
    
    init(word: String, lettersFilled: Int) {
        self.word = word
        self.lettersFilled = lettersFilled
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(word: "hello", lettersFilled: 3)
    }
}
