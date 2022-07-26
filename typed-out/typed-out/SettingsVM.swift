//
//  SettingsModel.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import Foundation

class SettingsVM: ObservableObject {
    @Published var textSize = 24.0
    @Published var saveMode = true
}
