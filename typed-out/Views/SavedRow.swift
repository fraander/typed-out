//
//  SavedRow.swift
//  typed-out
//
//  Created by Frank Anderson on 3/7/24.
//

import SwiftUI

struct SavedRow: View {
    
    let item: SaveItem
    
    var body: some View {
        HStack {
            Text(item.text)
            
            Spacer()
            
            Text(item.date.formatted( date: .omitted, time: .shortened) )
                .foregroundColor(Color.secondary)
                .font(.system(.caption, design: .monospaced, weight: .regular))
                .italic()
        }
    }
}


#Preview {
    SavedRow(item: SaveItem(text: "Play Free Bird! 🦅🇺🇸"))
}
