//
//  ContentView.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction> = Store(
        initialState: makeInitialState(),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: .main
      )
    )
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("WORDLE").bold().padding()
                VStack {
                    ForEach(viewStore.entries, id: \.self) { row in
                        WRowView(rowChars: row)
                    }
                }.padding()
                MyKeyboardView(store: self.store.scope(state: \.keyboard, action: AppAction.keboard))
            }.alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
