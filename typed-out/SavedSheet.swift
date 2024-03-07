//
//  SavedSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SavedSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var saved: SavedVM
    @ObservedObject var settings: SettingsVM
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Saved", systemImage: "tray.and.arrow.down")
                    .font(.system(Font.TextStyle.largeTitle, design: .rounded, weight: .bold))
                    .foregroundColor(/*settings.saveMode ? */Color.cyan/* : Color.gray*/)
                
                Spacer()
                
                TypedOutButton(
                    "Done",
                    icon: "checkmark",
                    tintColor: .mint
                ) { dismiss() }
            }
            .padding()
            
            if saved.items.isEmpty {
                Spacer()
                Text("Your saved messages will appear here.")
                    .font(.system(Font.TextStyle.body, design: .monospaced, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                List($saved.items, editActions: [.delete]) { $item in
                    SavedRow(item: item)
                }
                
                Divider()
                
                HStack {
                    TypedOutButton("Clear", icon: "trash", tintColor: .pink, action: clearButtonAction)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    func clearButtonAction() {
        saved.items = []
    }
}

struct SavedRow: View {
    
    let item: SaveItem
    
    var body: some View {
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
