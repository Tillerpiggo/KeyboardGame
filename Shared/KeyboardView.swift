//
//  ContentView.swift
//  Shared
//
//  Created by Tyler Gee on 11/20/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            WordView(word: "hello")
//            KeyboardView(Keyboard(rows: ["q w e r t y u i o p",
//                                         " a s d f g h j k l ",
//                                         "   z x c v b n m   "])!) { _ in }
//                .padding()
//        }
        GameView(word: "tree", keyboard: Keyboard(rows: ["q w e r t y u i o p",
                                                         "a s d f  g  h j k l",
                                                         "z x   c  v  b   n m"])!)
    }
    
}

struct GameView: View {
    var word: String
    @State var keyboard: Keyboard
    @State var lettersFilled = 0
    
    var body: some View {
        VStack {
            WordView(word: word, lettersFilled: lettersFilled)
            KeyboardView(keyboard) { row, column in
                guard lettersFilled < word.count else { return }
                
                if let letterTapped = keyboard.keyValueIfPressedAt(row, column),
                   letterTapped == String(word[word.index(word.startIndex, offsetBy: lettersFilled)]) {
                    lettersFilled += 1
                    let _ = keyboard.pressKeyAt(row, column)
                }
            }
                .padding()
            Button("Scramble Keyboard") {
                keyboard.scramble()
            }
        }
    }
    
    init(word: String, keyboard: Keyboard) {
        self.word = word
        self._keyboard = State(initialValue: keyboard)
    }
}

struct KeyboardView: View {
    var keyboard: Keyboard
    var tappedKey: (Int, Int) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(keyboardBackgroundColor)
            keyboardView
        }
        .frame(height: totalHeight)
    }
    
    var keyboardView: some View {
        GeometryReader { geometry in
            ForEach(0..<keyboard.numRows) { row in
                ForEach(0..<keyboard.numColumns) { column in
                    KeyView(keyboard.keyAt(row, column),
                            status: keyStatus(at: (row, column)))
                        .frame(width: keyWidth(width: geometry.size.width),
                               height: keyHeight)
                        .offset(x: xOffset(column, width: geometry.size.width),
                                y: yOffset(row, height: geometry.size.height))
                        .onTapGesture {
                            tappedKey(row, column)
                        }
                }
            }
        }
    }
    
    private func keyStatus(at indices: (Int, Int)) -> KeyView.Status {
        let pressableKeys = keyboard.pressableKeys()
        if let lastPressedIndices = keyboard.lastPressedIndices, pressableKeys.contains(where: { $0 == indices }) {
            return indices == lastPressedIndices ? .pressed : .pressable
        } else {
            return .normal
        }
    }
    
    private let keyboardBackgroundColor = Color(white: 0.1)
    
    private let keyHeight: CGFloat = 44.0
    private let xSpacing: CGFloat = 8.0
    private let ySpacing: CGFloat = 20.0
    private let xBorderSpacing: CGFloat = 16
    private let yBorderSpacing: CGFloat = 8
    
    private var totalHeight: CGFloat {
        return keyHeight * CGFloat(keyboard.numRows) +
        ySpacing * (CGFloat(keyboard.numRows) - 1) +
        2 * yBorderSpacing
    }
    
    private func keyWidth(width: CGFloat) -> CGFloat {
        let widthWithoutSpacing = width - xSpacing * CGFloat(keyboard.numColumns / 2) - xBorderSpacing * 2.0
        return widthWithoutSpacing / CGFloat(keyboard.numColumns / 2)
    }

    private func xOffset(_ column: Int, width: CGFloat) -> CGFloat {
        // Width of keys if they were all equal (including nil keys)
        // and took up the entire screen 'width' (no spacing)
        let equalSizeKeyWidth = (width - xBorderSpacing * 2.0) / CGFloat(keyboard.numColumns)
        
        // The center of where the keys should be if they were equal
        let equalSizeKeyOffset = (CGFloat(column) + 0.5) * equalSizeKeyWidth
        
        return equalSizeKeyOffset - keyWidth(width: width) / 2 + xBorderSpacing
    }
//
    private func yOffset(_ row: Int, height: CGFloat) -> CGFloat {
        // Height of the keys if they were all equal
        // and took up the entire screen 'height' (no spacing)
        let equalSizeKeyHeight = (height - yBorderSpacing * 2.0) / CGFloat(keyboard.numRows)
        
        //The center of where the keys should be if they were equal
        let equalSizeKeyOffset = (CGFloat(row) + 0.5) * equalSizeKeyHeight
        
        return equalSizeKeyOffset - keyHeight / 2 + yBorderSpacing
        //CGFloat(row) * (keyHeight + ySpacing) + yBorderSpacing
    }
    
    init(_ keyboard: Keyboard, tappedKey: @escaping (Int, Int) -> Void) {
        self.keyboard = keyboard
        self.tappedKey = tappedKey
    }
}

struct KeyView: View {
    var key: Key?
    var status: Status
    
    var body: some View {
        ZStack {
            if let key = key {
                RoundedRectangle(cornerRadius: 4)
                    .fill(status.keyColor)
                Text(key.string)
                    .foregroundColor(status.textColor)
                    .font(.system(size: 24))
            }
        }
    }
    
    init(_ key: Key?, status: Status) {
        self.key = key
        self.status = status
    }
    
    enum Status {
        case normal, pressable, pressed
        
        var keyColor: Color {
            var white: CGFloat
            
            switch self {
            case .normal: white = 0.2
            case .pressable: white = 0.4
            case .pressed: white = 0.8
            }
            
            return Color(white: white)
        }
        
        var textColor: Color {
            var white: CGFloat
            
            switch self {
            case .normal: white = 1.0
            case .pressable: white = 0.8
            case .pressed: white = 0.1
            }
            
            return Color(white: white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
