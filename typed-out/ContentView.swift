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
     * 1. Color customization/themes
     * 2. Refactor reused components to custom views and view modifiers
     */
    
    @StateObject var vm = TextVM()
    @StateObject var settings = SettingsVM()
    @StateObject var saved = SavedVM()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color(uiColor: UIColor.systemBackground)
                    
                    ScrollView {
                        EditingField(saved: saved, vm: vm, settings: settings)
                    }
                }
                .onTapGesture {
                    vm.focus = true
                }
            }
            .padding()
            .toolbar {
                ToolbarHandler().displayToolbar(vm: vm, settings: settings)
            }
        }
        .sheet(item: $vm.sheet) { sheetType in
            switch sheetType {
                case SheetType.settings:
                    SettingsSheet(settings: settings).presentationDetents([.medium, .large])
                case SheetType.saved:
                    SavedSheet(saved: saved, settings: settings).presentationDetents([.medium, .large])
            }
        }
        .task {
            SavedVM.load { result in
                switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let items):
                        saved.items = items
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if (phase == .inactive) {
                SavedVM.save(items: saved.items) { result in
                    switch result {
                        case .failure(let e):
                            print(e.localizedDescription)
                        case .success(_):
                            print("Saved \(saved.items.count) item(s)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
