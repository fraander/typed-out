//
//  EditingField.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct EditingField: View {
    @FocusState var focus: Bool
    @Binding var saved: [SaveItem]
    @ObservedObject var vm: TextVM
    @ObservedObject var settings: SettingsModel
    
    var body: some View {
        TextField("Type here ...", text: $vm.text, axis: .vertical)
            .font(.system(size: settings.textSize))
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
                    }
                    .disabled(vm.text.isEmpty)
                    
                    Spacer()
                    
                    Button {
                        focus = false
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .task { focus = true }
    }
}
