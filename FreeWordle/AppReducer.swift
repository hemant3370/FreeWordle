//
//  AppReducer.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import ComposableArchitecture
import UIKit

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .dismissAlert:
        state.alert = nil
    case .reset:
        state = makeInitialState()
    case .keboard(let keyboardAction):
        switch keyboardAction {
        case .enterkey(let entry):
            switch entry.description {
            case "🔙":
                if state.keyIndex > 0, state.entries[state.rowIndex][state.keyIndex - 1].state != .empty {
                    state.entries[state.rowIndex][state.keyIndex - 1] = Entry(value: .init(" "), state: .empty)
                    state.keyIndex -= 1
                }
            case "🆗":
                guard state.keyIndex == 5 else { return .none }
                let word = state.entries[state.rowIndex].compactMap({ $0.value.description }).joined()
                if isReal(word: word) {
                    for (index, intIndex) in zip(word.indices, 0..<word.count) {
                        if word[index] == state.word[index] {
                            state.entries[state.rowIndex][intIndex].state = .correct
                            if let keyboardKeyIndex = state.keyboard.indicesOf(x: Entry(value: word[index], state: .empty)) {
                                state.keyboard[keyboardKeyIndex.0][keyboardKeyIndex.1].state = .correct
                            }
                        } else if state.word.contains(word[index]) {
                            state.entries[state.rowIndex][intIndex].state = .partial
                            if let keyboardKeyIndex = state.keyboard.indicesOf(x: Entry(value: word[index], state: .empty)) {
                                state.keyboard[keyboardKeyIndex.0][keyboardKeyIndex.1].state = .partial
                            }
                        } else {
                            state.entries[state.rowIndex][intIndex].state = .wrong
                            if let keyboardKeyIndex = state.keyboard.indicesOf(x: Entry(value: word[index], state: .empty)) {
                                state.keyboard[keyboardKeyIndex.0][keyboardKeyIndex.1].state = .wrong
                            }
                        }
                    }
                    if word == state.word {
                        state.alert = .init(title: .init("Wow"), message: .init("\(word) is correct"), dismissButton: .cancel(.init("Yay!"), action: .send(.reset)))
                    } else if state.rowIndex == 4 {
                        state.alert = .init(title: .init("Alas"), message: .init("\(state.word) is the correct word"), dismissButton: .cancel(.init("Hmm"), action: .send(.reset)))
                    } else {
                        state.rowIndex += 1
                        state.keyIndex = 0
                    }
                } else {
                    state.alert = .init(title: .init("Uh Oh!"), message: .init("\(word) is not a valid word for us"), dismissButton: .cancel(.init("Okay"), action: nil))
                    state.entries[state.rowIndex] = state.entries[state.rowIndex].map({ _ in .init(value: .init(" "), state: .empty) })
                    state.keyIndex = 0
                }
            default:
                guard state.keyIndex < 5, state.rowIndex < 5 else { return .none }
                state.entries[state.rowIndex][state.keyIndex] = Entry(value: entry, state: .waiting)
                state.keyIndex += 1
            }
            return .none
        case .enterRow:
            guard state.entries[state.rowIndex].count == 5 else { return .none }
            
            return .none
        case .backspace:
            return .none
        }
    }
    return .none
}.debug()

func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word.lowercased().capitalized, range: range, startingAt: 0, wrap: false, language: "en_US")

    return misspelledRange.location == NSNotFound
}

extension Array where Element : Collection,
    Element.Iterator.Element : Equatable, Element.Index == Int {
    func indicesOf(x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }

        return nil
    }
}
