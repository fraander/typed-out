//
//  typed_outApp.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

@main
struct typed_outApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var vm = TextVM()
    @StateObject var settings = SettingsVM()
    @StateObject var saved = SavedVM.load()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(settings)
                .environmentObject(saved)
        }
    }
}
