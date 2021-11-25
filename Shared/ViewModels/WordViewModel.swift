//
//  WordViewModel.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/25/21.
//

import SwiftUI

class WordViewModel: ObservableObject {
    var filledWord: String { String(word[..<cutoffIndex]) }
    var unfilledWord: String {
        return String(word[cutoffIndex..<word.endIndex])
    }
    
    let filledWordColor = Color(white: 0.2)
    let unfilledWordColor = Color(white: 0.9)
    let wordFont = Font.system(size: 72, weight: .bold)
    
    private var word: String
    private var lettersFilled: Int
    
    private var cutoffIndex: String.Index {
        return word.index(word.startIndex, offsetBy: lettersFilled)
    }
    
    init(word: String, lettersFilled: Int = 0) {
        self.word = word
        self.lettersFilled = lettersFilled
    }
}
