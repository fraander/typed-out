//
//  SettingsSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SettingsSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settings: SettingsModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Label("Settings", systemImage: "gear")
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
                
                GroupBox("Font Size") {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .strokeBorder(.secondary, lineWidth: 2)
                            
                            Text("This is what your text will look like.")
                                .font(.system(size: settings.textSize))
                                .lineLimit(2)
                                .padding(8)
                        }
                        .frame(height: 120)
                        
                        Slider(value: $settings.textSize, in: 12...96)
                    }
                }
                
                //                GroupBox("Colors") {
                //                    VStack {
                //                        ColorPicker("Text Color", selection: <#T##Binding<Color>#>, supportsOpacity: false)
                //                        ColorPicker("Background Color", selection: <#T##Binding<Color>#>, supportsOpacity: false)
                //                    }
                //                }
                
                GroupBox {
                    Toggle(isOn: $settings.saveMode) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Save Mode")
                                .font(.headline)
                            Text("Save each message that is typed.")
                                .font(.caption)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(settings: SettingsModel())
    }
}
