//
//  WRowView.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI
import ComposableArchitecture

struct WRowView: View {
    let rowChars: [Entry]
    var body: some View {
        HStack {
            ForEach(rowChars, id: \.self) { entry in
                AlphabetView(entry: entry)
            }
        }
    }
}
