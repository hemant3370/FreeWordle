//
//  AlphabetView.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI

struct AlphabetView: View {
    let entry: Entry
    var body: some View {
        Button(action: {
            
        }, label: {
            Text(entry.value.description).bold().foregroundColor(.white).padding()
        }).background(entry.state.color()).cornerRadius(4)
    }
}

struct AlphabetView_Previews: PreviewProvider {
    static var previews: some View {
        AlphabetView(entry: .init(value: "W".first!, state: .empty))
    }
}
