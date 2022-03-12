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
                            Button(action: {
                                viewStore.send(.enterkey(alphabet.value))
                            }, label: {
                                Text(alphabet.value.description).bold().foregroundColor(.white)
                            }).frame(width: 30, height: 40, alignment: .center).background(alphabet.state.color()).cornerRadius(4)
                        }
                    }
                }
            }
        }
    }
}
