//
//  EditingField.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct EditingField: View {
    @Binding var saved: [SaveItem]
    @ObservedObject var vm: TextVM
    @ObservedObject var settings: SettingsVM
    @FocusState var focus: Bool
    
    var body: some View {
        TextField("Type here ...", text: $vm.text, axis: .vertical)
            .font(.system(size: settings.textSize, weight: .medium, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .focused($focus)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    Button {
                        if settings.saveMode {
                            let newItem = SaveItem(text: vm.text)
                            saved.append(newItem)
                        }
                        
                        vm.text = ""
                    } label: {
                        Label(settings.saveMode ? "Save & Clear" : "Erase",
                              systemImage: settings.saveMode ? "tray.and.arrow.down" : "pencil.and.outline")
                        .labelStyle(.titleAndIcon)
                        .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.accentColor)
                    .disabled(vm.text.isEmpty)
                    
                    Spacer()
                    
                    Button {
                        focus = false
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                            .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.accentColor)
                }
            }
            .task { focus = true }
            .onChange(of: vm.focus) { newValue in
                focus = newValue
            }
            .onChange(of: focus) { newValue in
                vm.focus = newValue
            }
    }
}

struct EditingField_Previews: PreviewProvider {
    static var previews: some View {
        EditingField(saved: .constant([]), vm: TextVM(), settings: SettingsVM())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
