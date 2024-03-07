//
//  SaveItem.swift
//  typed-out
//
//  Created by Frank Anderson on 7/25/22.
//

import Foundation

struct SaveItem: Identifiable, Hashable, Equatable, Codable {
    var id: UUID
    var text: String
    var date: Date
    
    init(text: String) {
        self.id = UUID()
        self.date = Date()
        self.text = text
    }
    
    static func == (lhs: SaveItem, rhs: SaveItem) -> Bool {
        return lhs.id == rhs.id
    }
}
