//
//  Colors.swift
//  FreeWordle
//
//  Created by Hemant Singh on 12/03/22.
//

import SwiftUI

extension Color {
    static let ui = Color.UI()
    
    struct UI {
         let tileColor = Color("tileColor")
         let keyColor = Color("keyColor")
        let correctColor = Color("correctColor")
        let wrongColor = Color("wrongColor")
        let partialCorrectColor = Color("partialCorrectColor")
    }
}
