//
//  typed_outApp.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

@main
struct TypedOutApp: App {
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    @State var vm = TextVM.load()
    @State var settings = SettingsVM.load()
    @State var saved = SavedVM.load()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(settings)
                .environmentObject(saved)
        }
    }
}
