//
//  EditingField.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct EditingField: View {
    @ObservedObject var saved: SavedVM
    @ObservedObject var vm: TextVM
    @ObservedObject var settings: SettingsVM
    @FocusState var focus: Bool
    
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            TypedOutButton(
                settings.saveMode ? "Save & Clear" : "Erase",
                icon: settings.saveMode ? "tray.and.arrow.down" : "pencil.and.outline",
                tintColor: .pink,
                action: saveAndClearAction
            )
            .disabled(vm.text.isEmpty)
            
            Spacer()
            
            TypedOutButton("Done", icon: "keyboard.chevron.compact.down", tintColor: .secondary) {
                focus = false
            }
        }
    }
    
    var body: some View {
        TextField("Type here ...", text: $vm.text, axis: .vertical)
            .font(.system(size: settings.textSize, weight: .medium, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .focused($focus)
            .toolbar {
                toolbar
            }
            .task { focus = true }
            .onChange(of: vm.focus) { _, newValue in
                focus = newValue
            }
            .onChange(of: focus) { _, newValue in
                vm.focus = newValue
            }
    }
    
    func saveAndClearAction() {
        if settings.saveMode {
            let newItem = SaveItem(text: vm.text)
            saved.items.append(newItem)
            
            SavedVM.save(items: saved.items) { result in
                switch result {
                    case .failure(let e):
                        print(e.localizedDescription)
                    case .success(_):
                        print("Saved on purpose. \(saved.items.count) items(s)")
                }
            }
        }
        
        vm.text = ""
    }
}

#Preview {
    EditingField(saved: SavedVM(), vm: TextVM(), settings: SettingsVM())
        .padding()
        .previewLayout(.sizeThatFits)
}
