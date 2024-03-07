//
//  ContentView.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    // TODO: feature-plan
    /**
     * 1. Refactor reused components to custom views and view modifiers
     * 2. Save settings / themes
     * 3. Fix rotation warnings
     */
    
    @EnvironmentObject var vm: TextVM
    @EnvironmentObject var settings: SettingsVM
    @EnvironmentObject var saved: SavedVM
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color(uiColor: UIColor.systemBackground)
                    ScrollView { EditingField(saved: saved, vm: vm, settings: settings) }
                }
                .onTapGesture { vm.focus = true }
            }
            .padding()
            .overlay {
                if vm.overlay {
                    PresenterOverlay()
                }
            }
            .toolbar { toolbar }
        }
        .sheet(item: $vm.sheet) { sheetType in
            switch sheetType {
            case SheetType.settings:
                SettingsSheet(settings: settings).presentationDetents([.medium, .large])
            case SheetType.saved:
                SavedSheet(saved: saved, settings: settings).presentationDetents([.medium, .large])
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                TypedOutButton(
                    "Saved",
                    icon: "tray.and.arrow.down",
                    tintColor: (settings.saveMode ? Color.cyan : Color.gray)
                ) {
                    vm.sheet = .saved
                }
                .labelStyle(.iconOnly)
                .opacity(vm.overlay ? 0 : 100)
                .disabled(vm.overlay)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                TypedOutButton(
                    "Settings",
                    icon: "gear",
                    tintColor: .indigo
                ) {
                    vm.sheet = .settings
                }
                .labelStyle(.iconOnly)
                .opacity(vm.overlay ? 0 : 100)
                .disabled(vm.overlay)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                TypedOutButton(
                    "Full Screen",
                    icon: "rectangle.landscape.rotate",
                    tintColor: .orange
                ) {
                    vm.toggleOverlay()
                }
                .labelStyle(.titleAndIcon)
                .disabled(vm.text.isEmpty)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
