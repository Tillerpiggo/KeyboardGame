//
//  KeyboardViewModel.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/25/21.
//

import SwiftUI

class KeyboardViewModel: ObservableObject {
    @Published private(set) var keyboard: Keyboard
    @Published private(set) var tappedKey: (Int, Int) -> Void
    
    let numRows: Int
    let numColumns: Int
    
    let keyboardBackgroundColor = Color(white: 0.1)
    let keyboardRadius = 12.0
    
    // Spacing constants
    let keyHeight: CGFloat = 44.0
    private let xSpacing: CGFloat = 8.0
    private let ySpacing: CGFloat = 20.0
    private let xBorderSpacing: CGFloat = 16
    private let yBorderSpacing: CGFloat = 8
    
    // Spacing/width/height functions
    var totalHeight: CGFloat {
        return keyHeight * CGFloat(keyboard.numRows) +
        ySpacing * (CGFloat(keyboard.numRows) - 1) +
        2 * yBorderSpacing
    }
    
    func keyWidth(width: CGFloat) -> CGFloat {
        let widthWithoutSpacing = width - xSpacing * CGFloat(keyboard.numColumns / 2) - xBorderSpacing * 2.0
        return widthWithoutSpacing / CGFloat(keyboard.numColumns / 2)
    }
    
    func xOffset(_ column: Int, width: CGFloat) -> CGFloat {
        // Width of keys if they were all equal (including nil keys)
        // and took up the entire screen 'width' (no spacing)
        let equalSizeKeyWidth = (width - xBorderSpacing * 2.0) / CGFloat(keyboard.numColumns)
        
        // The center of where the keys should be if they were equal
        let equalSizeKeyOffset = (CGFloat(column) + 0.5) * equalSizeKeyWidth
        
        return equalSizeKeyOffset - keyWidth(width: width) / 2 + xBorderSpacing
    }
    
    func yOffset(_ row: Int, height: CGFloat) -> CGFloat {
        // Height of the keys if they were all equal
        // and took up the entire screen 'height' (no spacing)
        let equalSizeKeyHeight = (height - yBorderSpacing * 2.0) / CGFloat(keyboard.numRows)
        
        //The center of where the keys should be if they were equal
        let equalSizeKeyOffset = (CGFloat(row) + 0.5) * equalSizeKeyHeight
        
        return equalSizeKeyOffset - keyHeight / 2 + yBorderSpacing
    }
    
    // Other helper methods
    func keyStatus(at indices: (Int, Int)) -> KeyView.Status {
        let pressableKeys = keyboard.pressableKeys()
        if let lastPressedIndices = keyboard.lastPressedIndices, pressableKeys.contains(where: { $0 == indices }) {
            return indices == lastPressedIndices ? .pressed : .pressable
        } else {
            return .normal
        }
    }
    
    func keyAt(_ row: Int, _ column: Int) -> Key? {
        return keyboard.keyAt(row, column)
    }
    
    init(keyboard: Keyboard, tappedKey: @escaping (Int, Int) -> Void) {
        self.keyboard = keyboard
        self.tappedKey = tappedKey
        
        numRows = keyboard.numRows
        numColumns = keyboard.numColumns
    }
}
