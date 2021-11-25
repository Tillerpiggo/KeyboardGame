//
//  Keyboard.swift
//  keyboardGame
//
//  Created by Tyler Gee on 11/20/21.
//

import Foundation

struct Keyboard {
    private(set) var rows: [KeyboardRow]
    private(set) var lastPressedIndices: (Int, Int)? // (row, column)
    private var lastRowIndex: Int { rows.count - 1 }
    
    let numRows: Int
    let numColumns: Int
    
    // Returns the indices of all pressable keys at a given time. If no key has been pressed yet,
    // returns an empty array.
    func pressableKeys() -> [(Int, Int)] {
        var pressableKeys = [(Int, Int)]()
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let indices = (row, column)
                if canPressKey(at: indices) {
                    pressableKeys.append(indices)
                }
            }
        }
        
        return pressableKeys
    }
    
    // Randomly rearranges all of the keys on the keyboard while maintaining
    // their positions
    mutating func scramble() {
        var keyIndices = [(Int, Int)]()
        var keyValues = [String]()
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let indices = (row, column)
                if let key = keyAt(row, column) {
                    keyIndices.append(indices)
                    keyValues.append(key.string)
                }
            }
        }
        
        keyValues.shuffle()
        
        for (index, indices) in keyIndices.enumerated() {
            setKey(at: indices, to: keyValues[index])
        }
        
        lastPressedIndices = nil
    }
    
    // Presses a key if it can be pressed and returns the String value of the key.
    // If the key doesn't exist or can't be pressed, returns nil
    mutating func pressKeyAt(_ row: Int, _ column: Int) -> String? {
        let value: String? = keyValueIfPressedAt(row, column)
        if value != nil { lastPressedIndices = (row, column) }
        return value
    }
    
    // Sets the given key to
    private mutating func setKey(at indices: (Int, Int), to value: String) {
        rows[indices.0].keys[indices.1]?.char = Character(value)
    }
    
    // Returns the value of a key if it were to be pressed, but doesn't press it.
    // If the key doesn't exist or can't be pressed, returns nil
    func keyValueIfPressedAt(_ row: Int, _ column: Int) -> String? {
        guard let key = keyAt(row, column) else { return nil }
        if canPressKey(at: (row, column)) {
            return key.string
        } else {
            return nil
        }
    }
    
    // Returns true if the key can be pressed (based on the last key that was pressed)
    // Otherwise returns false.
    private func canPressKey(at indices: (Int, Int)) -> Bool {
        guard let selectedIndices = lastPressedIndices else {
            // If nothing is selected, you can select any key
            return true
        }
        
        if selectedIndices.0 == indices.0 { // They are on the same row
            return rows[indices.0].canPressKey(at: indices.1, selectedColumn: selectedIndices.1)
        } else if abs(indices.0 - selectedIndices.0) == 1 || // adjacent rows
                    // if they connect by wrapping the top and bottom rows
                    (indices.0 == 0 && selectedIndices.0 == lastRowIndex) ||
                    (indices.0 == lastRowIndex && selectedIndices.0 == 0)
        {
            return abs(indices.1 - selectedIndices.1) <= 1
        }
        
        return false
    }
    
    // Returns the key at a given row and column (this method is mainly for convenience)
    func keyAt(_ row: Int, _ column: Int) -> Key? {
        guard row >= 0, row < numRows, column >= 0, column < numColumns else { return nil }
        return rows[row].keys[column]
    }
    
    // Creates a keyboard with the given rows as strings.
    // 'rows' must have at least one String in it and all Strings must be the same length,
    // or this returns nil
    init?(rows: [String]) {
        guard rows.count > 0 else { return nil }
        
        var keyboardRows = [KeyboardRow]()
        let columns = rows.first!.count
        for row in rows {
            // Make sure that all rows are the same length
            if row.count != columns { return nil }
            
            keyboardRows.append(KeyboardRow(fromString: row))
        }
        
        self.rows = keyboardRows
        self.numRows = rows.count
        self.numColumns = columns
    }
    
    static let qwerty = Keyboard(rows: ["q w e r t y u i o p",
                                        " a s d f g h j k l ",
                                        "   z x c v b n m   "])!
}

struct KeyboardRow {
    // The first index (column) with a key in it, used for wrapping from start-to-end
    private var startIndex: Int?
    
    // The last index( column) with a key in it, used for wrapping from start-to-end
    private var endIndex: Int?
    
    var keys: [Key?]
    
    // Returns if the key at 'column' can be pressed given that the last key that was
    // Pressed is at 'selectedColumn'
    func canPressKey(at column: Int, selectedColumn: Int) -> Bool {
        guard let startIndex = startIndex, let endIndex = endIndex else { return false }
        
        let adjacent = abs(column - selectedColumn) <= 2 // keys can have a "space" between them and still be adjacent
        let touchingIfWrapped = (column == startIndex && selectedColumn == endIndex) ||
                                (column == endIndex && selectedColumn == startIndex)
        
        return adjacent || touchingIfWrapped
    }
    
    init(fromString string: String) {
        var startIndex: Int?
        var endIndex: Int?
        var keys = [Key?]()
        for (charIndex, char) in string.enumerated() {
            let key = Key(char)
            keys.append(key)
            
            if key != nil {
                if startIndex == nil { startIndex = charIndex }
                endIndex = charIndex
            }
        }
        
        self.keys = keys
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}

struct Key {
    var char: Character
    var string: String { String(char) }
    
    // Creates a key with the given character. If the character is a space, returns null
    init?(_ char: Character) {
        if char == " " {
            return nil
        } else {
            self.char = char
        }
    }
}
