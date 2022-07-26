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
     */
    
    @StateObject var vm = TextVM()
    @StateObject var settings = SettingsVM()
    @State var saved = [SaveItem]()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color(uiColor: UIColor.systemBackground)
                    
                    ScrollView {
                        
                        EditingField(saved: $saved, vm: vm, settings: settings)
                    }
                }
                .onTapGesture {
                    vm.focus = true
                }
                
                // TODO: make the quick responses do stuff
                /*
                 HStack(spacing: 4) {
                 
                 Button { } label: {
                 Label("Yes", systemImage: "hand.thumbsup.fill")
                 .labelStyle(.iconOnly)
                 }
                 .buttonStyle(.bordered)
                 .tint(Color.mint)
                 
                 Button { } label: {
                 Text("Haha")
                 .font(.system(.body, design: .monospaced, weight: .bold))
                 .italic()
                 }
                 .buttonStyle(.bordered)
                 .tint(Color.cyan)
                 
                 Button { } label: {
                 Label("Huh?", systemImage: "questionmark")
                 .labelStyle(.iconOnly)
                 .font(.system(.headline, design: .monospaced, weight: .bold))
                 }
                 .buttonStyle(.bordered)
                 .tint(Color.indigo)
                 
                 Button { } label: {
                 Label("No", systemImage: "hand.thumbsdown.fill")
                 .labelStyle(.iconOnly)
                 }
                 .buttonStyle(.bordered)
                 .tint(Color.pink)
                 }
                 */
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.sheet = .saved
                    } label: {
                        Label("Saved", systemImage: "tray.and.arrow.down")
                            .labelStyle(.titleAndIcon)
                            .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.sheet = .settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.titleAndIcon)
                            .font(.system(.body, design: .monospaced, weight: .bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.indigo)
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
