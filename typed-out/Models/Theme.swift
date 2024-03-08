//
//  Theme.swift
//  typed-out
//
//  Created by Frank Anderson on 3/8/24.
//

import SwiftUI

struct Theme: Identifiable, Codable {
    var id = UUID()
    let textColor: CodableColor
    let backgroundColor: CodableColor
    
    init(textColor: CodableColor, backgroundColor: CodableColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
