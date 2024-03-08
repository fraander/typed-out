//
//  SettingsModel.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import Foundation
import SwiftUI

extension CGColor {
    static let white = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let black = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
}

class SettingsVM: ObservableObject, Codable {
    
    static let defaultTextSize = 18.0
    
    @Published var textSize = SettingsVM.defaultTextSize {
        didSet {
            SettingsVM.save(self)
        }
    }
    @Published var saveMode = true {
        didSet {
            SettingsVM.save(self)
        }
    }
    @Published var textColor: CodableColor = .white {
        didSet {
            SettingsVM.save(self)
        }
    }
    @Published var backgroundColor: CodableColor = .black {
        didSet {
            SettingsVM.save(self)
        }
    }
    @Published var themes: [Theme] = [] {
        didSet {
            SettingsVM.save(self)
        }
    }
    
    func addTheme() {
        
        if (!themes.contains {
            $0.textColor == textColor
            && $0.backgroundColor == backgroundColor
        }) {
            themes.insert(
                Theme(textColor: textColor,
                      backgroundColor: backgroundColor),
                at: 0)
        }
    }
    
    static let defaultsKey = "settings"
    
    static func save(_ settings: SettingsVM) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        } else {
            print("Error saving Settings.")
        }
    }
    
    static func load() -> SettingsVM {
        if let data = UserDefaults.standard.data(forKey: defaultsKey) {
            do {
                let _ = try JSONDecoder().decode(SettingsVM.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            if let decoded = try? JSONDecoder().decode(SettingsVM.self, from: data) {
                return decoded
            } else {
                print("Error decoding")
            }
        } else {
            print("Not found in defaults")
        }
        
        return SettingsVM()
    }
    
    init() {
        self.textSize = SettingsVM.defaultTextSize
        self.saveMode = true
        self.textColor = .white
        self.backgroundColor = .black
        self.themes = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.textSize = try container.decode(Double.self, forKey: .textSize)
        self.saveMode = try container.decode(Bool.self, forKey: .saveMode)
        self.textColor = try container.decode(CodableColor.self, forKey: .textColor)
        self.backgroundColor = try container.decode(CodableColor.self, forKey: .backgroundColor)
        self.themes = try container.decode([Theme].self, forKey: .themes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(textSize, forKey: .textSize)
        try container.encode(saveMode, forKey: .saveMode)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(themes, forKey: .themes)
    }
    
    enum CodingKeys: CodingKey{
        case textSize
        case saveMode
        case textColor
        case backgroundColor
        case themes
    }
}
