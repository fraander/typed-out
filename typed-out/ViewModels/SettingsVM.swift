//
//  SettingsModel.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import Foundation
import SwiftUI

class SettingsVM: ObservableObject {
    @Published var textSize = 24.0
    @Published var saveMode = true
    @Published var textColor: Color = Color.white
    @Published var backgroundColor: Color = Color.black
}
