//
//  SavedSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SavedSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var saved: [String]
    
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
                        .labelStyle(.automatic)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            if saved.isEmpty {
                Spacer()
                Text("Your saved messages will appear here.")
                Spacer()
            } else {
                List($saved, id: \.self, edits: [.delete, .move]) { $item in
                    Text(item)
                }
                
            }
        }
    }
}
