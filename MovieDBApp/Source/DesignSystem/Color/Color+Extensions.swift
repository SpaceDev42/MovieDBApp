//
//  Color+Extensions.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import SwiftUI

extension Color {
    init(mainColor: ColorPalette.Primary) {
        self.init(mainColor.rawValue)
    }
    
    init(backgroundColor: ColorPalette.Background) {
        self.init(backgroundColor.rawValue)
    }
    
    init(neutralColor: ColorPalette.Neutral) {
        self.init(neutralColor.rawValue)
    }
}
