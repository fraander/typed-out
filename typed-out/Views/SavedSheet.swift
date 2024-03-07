//
//  SavedSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SavedSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var saved: SavedVM
    @EnvironmentObject var settings: SettingsVM
    @EnvironmentObject var text: TextVM
    
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
                List($saved.items) { $item in
                    SavedRow(item: item)
                        .swipeActions(edge: .leading) {
                            Button("Overload",
                                systemImage: "tray.and.arrow.up.fill"
                            ) { text.text = item.text }
                                .tint(.cyan)
                            
                            Button("Load",
                                systemImage: "tray.and.arrow.up"
                            ) {
                                if !text.text.isEmpty && text.text != item.text {
                                    saved.items.append(SaveItem(text: text.text))
                                }
                                text.text = item.text
                            }
                                .tint(.secondary)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Remove",
                                systemImage: "trash.fill"
                            ) { saved.items.removeAll { si in
                                si.id == item.id
                            } }
                                .tint(.pink)
                        }
                }
                
                Divider()
                
                HStack {
                    TypedOutButton("Clear", icon: "trash", tintColor: .pink, action: { saved.items = [] })
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

