//
//  typed_outApp.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

@main
struct TypedOutApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var vm = TextVM.load()
    @StateObject var settings = SettingsVM.load()
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
