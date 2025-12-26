//
//  SavedVM.swift
//  typed-out
//
//  Created by Frank Anderson on 7/26/22.
//

import Foundation
import Combine
import Observation

@Observable
class SavedVM: ObservableObject, Equatable, Codable {
    
    var items: [SaveItem] {
        didSet {
            SavedVM.save(saved: self)
        }
    }
    
    static let defaultsKey = "saved"
    
    static func save(saved: SavedVM) {
        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        } else {
            print("Error saving Saved.")
        }
    }
    
    static func load() -> SavedVM {
        if let data = UserDefaults.standard.data(forKey: defaultsKey) {
            do {
                let _ = try JSONDecoder().decode(SavedVM.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            if let decoded = try? JSONDecoder().decode(SavedVM.self, from: data) {
                return decoded
            } else {
                print("Error decoding SavedVM")
            }
        } else {
            print("Not found in defaults")
        }
        
        return SavedVM()
    }
    
    // MARK: - Codable conformance
    private enum CodingKeys : String, CodingKey {
        case items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
    
    init() {
        self.items = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.items = try values.decode(Array<SaveItem>.self, forKey: .items)
        } catch {
            self.items = []
        }
    }
    
    // MARK: - Equatable conformance
    static func == (lhs: SavedVM, rhs: SavedVM) -> Bool {
        return lhs.items == rhs.items
    }
}
