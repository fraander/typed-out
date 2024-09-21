//
//  ContentView.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: TextVM
    @EnvironmentObject var settings: SettingsVM
    @EnvironmentObject var saved: SavedVM
    
    var navViewBody: some View {
        Group {
            VStack {
                ZStack {
                    #if os(iOS)
                    Color(uiColor: UIColor.systemBackground)
                    #endif
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
    }
    
    var body: some View {
#if os(iOS)
        NavigationView {
            navViewBody
        }
        .sheet(item: $vm.sheet) { sheetType in
            switch sheetType {
            case SheetType.settings:
                SettingsSheet().presentationDetents([.medium, .large])
            case SheetType.saved:
                SavedSheet().presentationDetents([.medium, .large])
            }
        }
#else
        NavigationStack {
            navViewBody
        }
        .sheet(item: $vm.sheet) { sheetType in
            switch sheetType {
            case SheetType.settings:
                SettingsSheet().presentationDetents([.medium, .large])
            case SheetType.saved:
                SavedSheet().presentationDetents([.medium, .large])
            }
        }
#endif
        
    }
    
    var savedButton: some View {
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
//                .symbolEffect(.bounce, value: vm.sheet == .saved)
    }
    
    var settingsButton: some View {
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
//                .symbolEffect(.bounce, value: vm.sheet == .settings)
    }
    
    var fullScreenButton: some View {
        TypedOutButton(
            "Full Screen",
            icon: "rectangle.landscape.rotate",
            tintColor: .orange
        ) {
            vm.toggleOverlay()
        }
        .disabled(vm.text.isEmpty)
        .symbolEffect(.bounce, value: vm.text.isEmpty)
        .symbolEffect(.bounce, value: vm.overlay)
    }
    
    var toolbar: some ToolbarContent {
        Group {
            #if os(iOS)
            ToolbarItem(placement:
                    .navigationBarLeading
            ) {
                savedButton
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                settingsButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                fullScreenButton
            }
            #else
            ToolbarItem(placement:
                    .principal
            ) {
                savedButton
            }
            
            ToolbarItem(placement: .principal) {
                settingsButton
            }
            
            ToolbarItem(placement: .principal) {
                fullScreenButton
            }
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
