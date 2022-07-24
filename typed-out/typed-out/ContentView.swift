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
     * 4. Quick responses
     * 5. Preset phrases to quick-access
     * 6. Color customization/themes
     * 7. Persistence for save mode + more information in saved mode (detail view on tap that shows time saved and location?)
     * 8. Onboarding
     * 9. Refactor reused components to custom views and view modifiers
     * 10. Create monospaced and rounded modifiers for more friendly look (a la Jordan Morgan and Daniel Gauthier) [https://twitter.com/jordanmorgan10/status/1551001602168872960?s=21&t=YWZ6rlsog8oDesb0Sau35Q]
     */
    
    @StateObject var vm = TextVM()
    @StateObject var settings = SettingsModel()
    @State var saved = [String]()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    EditingField(saved: $saved, vm: vm, settings: settings)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.sheet = .saved
                    } label: {
                        Label("Saved", systemImage: "tray.and.arrow.down")
                            .labelStyle(.titleAndIcon)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.sheet = .settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        }
        .sheet(item: $vm.sheet) { sheetType in
            switch sheetType {
                case SheetType.settings:
                    SettingsSheet(settings: settings).presentationDetents([.medium, .large])
                case SheetType.saved:
                    SavedSheet(saved: $saved).presentationDetents([.medium, .large])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
