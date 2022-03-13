//
//  AppState.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var word: String
    var keyIndex = 0
    var rowIndex = 0
    var entries: [[Entry]]
    var keyboard: [[Entry]]
    var alert: AlertState<AppAction>?
}

func makeInitialState() -> AppState {
    let word = getWord()
    return AppState(word: word, entries: Array(repeating: Array(repeating: .init(value: Character.init(" "), state: .empty), count: 5), count: 5), keyboard: [
        ["Q","W","E","R","T","Y","I","U","O","P"].map({ Entry(value: $0.first!, state: .waiting) }),
        ["A","S","D","F","G","H","J","K","L"].map({ Entry(value: $0.first!, state: .waiting) }),
        ["🆗","Z","X","C","V","B","N","M","🔙"].map({ Entry(value: $0.first!, state: .waiting) })
    ])
}

enum AppAction: Equatable {
    case keboard(KeyboardAction)
    case dismissAlert
    case reset
}

enum KeyboardAction: Equatable {
    case enterkey(Character)
    case enterRow
    case backspace
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
 
}

struct Entry: Equatable, Hashable {
    var value: Character = .init(" ")
    var state: EntryState = .empty
    
    static func == (lhs: Self, rhs: Self) -> Bool {
//        Keyborad key will never be empty
        lhs.value == rhs.value && (rhs.state == .empty || lhs.state == rhs.state)
    }
}

enum EntryState: Equatable {
    case empty
    case waiting
    case wrong
    case partial
    case correct
    
    func color() -> Color {
        switch self {
        case .correct:
            return Color.ui.correctColor
        case .partial:
            return Color.ui.partialCorrectColor
        case .wrong:
            return Color.ui.wrongColor
        case .empty:
            return Color.ui.keyColor
        case .waiting:
            return Color.ui.tileColor
        }
    }
}
