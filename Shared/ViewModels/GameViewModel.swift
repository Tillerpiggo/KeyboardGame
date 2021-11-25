//
//  GameViewModel.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/25/21.
//

import Foundation

class GameViewModel: ObservableObject {
    var word: String
    @Published private(set) var lettersFilled: Int
    
    @Published private(set) var keyboard: Keyboard
    
    func tapLetterAt(_ row: Int, _ column: Int) {
        guard lettersFilled < word.count else { return }
        
        let firstUnfilledLetter = String(word[word.index(word.startIndex, offsetBy: lettersFilled)])
        
        if let letterTapped = keyboard.keyValueIfPressedAt(row, column),
           letterTapped == firstUnfilledLetter {
            lettersFilled += 1
            let _ = keyboard.pressKeyAt(row, column)
        }
    }
    
    func scrambleKeyboard() {
        keyboard.scramble()
    }
    
    init(word: String, keyboard: Keyboard) {
        self.word = word
        self.lettersFilled = 0
        self.keyboard = keyboard
    }
}
