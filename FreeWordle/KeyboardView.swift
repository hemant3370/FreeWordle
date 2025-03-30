//
//  KeyboardView.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI
import ComposableArchitecture

struct MyKeyboardView: View {
    var store: Store<[[Entry]], KeyboardAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                ForEach(viewStore.state, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { alphabet in
                            KeyButton(alphabet: alphabet, action: {
                                viewStore.send(.enterkey(alphabet.value))
                            })
                        }
                    }
                }
            }
        }
    }
}

struct KeyButton: View {
    let alphabet: Entry
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            action()
        }) {
            Text(alphabet.value.description)
                .bold()
                .foregroundColor(.white)
                .frame(width: 30, height: 40, alignment: .center)
                .background(alphabet.state.color())
                .cornerRadius(4)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.2), value: isPressed)
        }
    }
}
