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
                List($saved, edits: [.delete]) { $item in
                    HStack {
                        Text(item.text)
                        
                        Spacer()
                        
                        Text(item.date
                            .formatted(
                                date: Date.FormatStyle.DateStyle.omitted,
                                time: Date.FormatStyle.TimeStyle.shortened)
                             )
                        .foregroundColor(Color.secondary)
                        .font(.system(.caption, design: .monospaced, weight: .regular))
                        .italic()
                    }
                }
                
            }
        }
    }
}

struct SavedSheet_Previews: PreviewProvider {
    static var previews: some View {
        SavedSheet(saved: .constant([SaveItem(text: "first"), SaveItem(text: "second"), SaveItem(text: "this is a really long message that is supposed to show what happens when you just keep typing and don't stop. It looks liek this actually scales just fine for now.")]))
    }
}
