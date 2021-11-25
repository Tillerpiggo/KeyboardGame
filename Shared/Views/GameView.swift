//
//  GameView.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/25/21.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack {
            WordView(word: gameViewModel.word, lettersFilled: gameViewModel.lettersFilled)
            KeyboardView(gameViewModel.keyboard) { row, column in
                gameViewModel.tapLetterAt(row, column)
            }
                .padding()
            Button("Scramble Keyboard") {
                gameViewModel.scrambleKeyboard()
            }
        }
    }
    
    init(word: String, keyboard: Keyboard) {
        self.gameViewModel = GameViewModel(word: word, keyboard: keyboard)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(word: "hello", keyboard: Keyboard.qwerty)
    }
}
