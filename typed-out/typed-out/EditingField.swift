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
                    } label: {
                        Label(settings.saveMode ? "Save & Clear" : "Erase",
                              systemImage: settings.saveMode ? "tray.and.arrow.down" : "pencil.and.outline")
                        .labelStyle(.titleAndIcon)
                        .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.pink)
                    .disabled(vm.text.isEmpty)
                    
                    Spacer()
                    
                    Button {
                        focus = false
                    } label: {
                        Label("Done", systemImage: "keyboard.chevron.compact.down")
                            .labelStyle(.iconOnly)
                            .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.secondary)
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
        EditingField(saved: SavedVM(), vm: TextVM(), settings: SettingsVM())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
