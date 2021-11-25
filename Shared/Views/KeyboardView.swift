//
//  ContentView.swift
//  Shared
//
//  Created by Tyler Gee on 11/20/21.
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var model: KeyboardViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: model.keyboardRadius)
                .fill(model.keyboardBackgroundColor)
            keyboardView
        }
        .frame(height: model.totalHeight)
    }
    
    var keyboardView: some View {
        GeometryReader { geometry in
            ForEach(0..<model.numRows) { row in
                ForEach(0..<model.numColumns) { column in
                    keyAt(row, column, geometry: geometry)
                }
            }
        }
    }
    
    func keyAt(_ row: Int, _ column: Int, geometry: GeometryProxy) -> some View {
        KeyView(model.keyAt(row, column),
                status: model.keyStatus(at: (row, column)))
            .frame(width: model.keyWidth(width: geometry.size.width),
                   height: model.keyHeight)
            .offset(x: model.xOffset(column, width: geometry.size.width),
                    y: model.yOffset(row, height: geometry.size.height))
            .onTapGesture {
                model.tappedKey(row, column)
            }
    }
    
    init(_ keyboard: Keyboard, tappedKey: @escaping (Int, Int) -> Void) {
        self.model = KeyboardViewModel(keyboard: keyboard, tappedKey: tappedKey)
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
