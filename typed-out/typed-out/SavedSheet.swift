//
//  SavedSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SavedSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var saved: [SaveItem]
    
    var body: some View {
        VStack {
            HStack {
                Label("Saved", systemImage: "tray.and.arrow.down")
                    .font(.system(Font.TextStyle.largeTitle, design: .rounded, weight: .bold))
                
                Spacer()
                
                Button  {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .labelStyle(.titleAndIcon)
                        .font(.system(.body, design: .monospaced, weight: .bold))
                }
                .buttonStyle(.bordered)
                .tint(Color.accentColor)
            }
            .padding()
            
            if saved.isEmpty {
                Spacer()
                Text("Your saved messages will appear here.")
                Spacer()
            } else {
                List($saved, edits: [.delete, .move]) { $item in
                    Text(item.text)
                }
                
            }
        }
    }
}

struct SavedSheet_Previews: PreviewProvider {
    static var previews: some View {
        SavedSheet(saved: .constant([SaveItem(text: "first"), SaveItem(text: "second")]))
    }
}