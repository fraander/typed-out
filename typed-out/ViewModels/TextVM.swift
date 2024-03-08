//
//  TextVM.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

enum SheetType: Identifiable, Codable, Equatable {
    var id: Self { self }
    
    case settings, saved
}

class TextVM: ObservableObject, Codable {
    @Published var text: String {
        didSet {
            TextVM.save(self)
        }
    }
    @Published var sheet: SheetType? {
        didSet {
            TextVM.save(self)
        }
    }
    @Published var focus: Bool {
        didSet {
            TextVM.save(self)
        }
    }
    @Published var overlay: Bool {
        didSet {
            TextVM.save(self)
        }
    }
    
    func toggleOverlay() {
        overlay.toggle()
        focus = !overlay
    }
    
    static let defaultsKey = "text"
    
    static func save(_ textVM: TextVM) {
        if let encoded = try? JSONEncoder().encode(textVM) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        } else {
            print("Error saving TextVM.")
        }
    }
    
    static func load() -> TextVM {
        if let data = UserDefaults.standard.data(forKey: defaultsKey) {
            do {
                let _ = try JSONDecoder().decode(TextVM.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            if let decoded = try? JSONDecoder().decode(TextVM.self, from: data) {
                return decoded
            } else {
                print("Error decoding")
            }
        } else {
            print("Not found in defaults")
        }
        
        return TextVM()
    }
    
    init() {
        self.text = ""
        self.sheet = nil
        self.focus = true
        self.overlay = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.sheet = try container.decode(SheetType.self, forKey: .sheet)
        self.focus = try container.decode(Bool.self, forKey: .focus)
        self.overlay = try container.decode(Bool.self, forKey: .overlay)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(text, forKey: .text)
        try container.encode(sheet, forKey: .sheet)
        try container.encode(focus, forKey: .focus)
        try container.encode(overlay, forKey: .overlay)
    }
    
    enum CodingKeys: CodingKey{
        case text
        case sheet
        case focus
        case overlay
    }
}
