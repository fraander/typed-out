//
//  SettingsSheet.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct SettingsSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: SettingsVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Label("Settings", systemImage: "gear")
                        .font(.system(Font.TextStyle.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(.indigo)
                    
                    Spacer()
                    
                    TypedOutButton("Done", icon: "checkmark", tintColor: .mint) { dismiss() }
                        .labelStyle(.titleAndIcon)
                }
                
                GroupBox {
                    Toggle(isOn: $settings.saveMode) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Save Mode")
                                .font(.headline)
                            Text("Save each message that is typed.")
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                    .tint(Color.indigo)
                }
                
                GroupBox("Colors") {
                    
                    let cgTextColor = Binding {
                        settings.textColor.cgColor
                    } set: { newValue in
                        settings.textColor = CodableColor(cgColor: newValue)
                    }
                    
                    let cgBackgroundColor = Binding {
                        settings.backgroundColor.cgColor
                    } set: { newValue in
                        settings.backgroundColor = CodableColor(cgColor: newValue)
                    }

                    
                    VStack {
                        ColorPicker("Text Color", selection: cgTextColor, supportsOpacity: false)
                            .font(.system(.caption, design: .monospaced))

                        ColorPicker("Background Color", selection: cgBackgroundColor, supportsOpacity: false)
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Themes")
                            .font(.headline)
                        Text("Long press a theme to remove it from the list.")
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ThemeIconButton(action: settings.addTheme, textColor: .white, backgroundColor: .indigo, outlineColor: .white, icon: "plus", iconSize: 0.6)
                                .symbolEffect(.bounce, value: settings.themes.count)
                            
                            ForEach(settings.themes) { theme in
                                ThemeIconButton(theme: theme) {
                                    settings.textColor = theme.textColor
                                    settings.backgroundColor = theme.backgroundColor
                                }
                                .contextMenu {
                                    Button("Remove Theme", systemImage: "trash.fill", role: .destructive) {
                                        settings.themes = settings.themes.filter { t in t.id != theme.id }
                                    }
                                }
                            }
                        }
                        .padding(5)
                    }
                }
                
                
                
                GroupBox("Typing Area Font Size") {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .strokeBorder(.secondary, lineWidth: 2)
                            
                            Text("This is what your text will look like.")
                                .font(.system(size: settings.textSize, weight: .medium, design: .rounded))
                                .lineLimit(2)
                                .padding(8)
                        }
                        .frame(height: 120)
                        
                        HStack {
                            Slider(value: $settings.textSize, in: 12...96, step: 1.0)
                                .tint(Color.indigo)
                            
                            TypedOutButton(
                                "\(settings.textSize, specifier: "%.0f")pt",
                                icon: "textformat.size",
                                tintColor: settings.textSize == SettingsVM.defaultTextSize ? .secondary : .indigo
                            ) {
                                settings.textSize = SettingsVM.defaultTextSize
                            }
                            .symbolEffect(.bounce, value: settings.textSize == SettingsVM.defaultTextSize)
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
        SettingsSheet()
            .environmentObject(SettingsVM())
    }
}
