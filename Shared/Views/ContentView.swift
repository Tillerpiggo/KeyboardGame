//
//  ContentView.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/25/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView(word: "tree", keyboard: Keyboard(rows: ["q w e r t y u i o p",
                                                         "a s d f  g  h j k l",
                                                         "z x   c  v  b   n m"])!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
