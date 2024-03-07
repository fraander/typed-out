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
     * 3. Fix rotation warnings
     */
    
    @StateObject var vm = TextVM()
    @StateObject var settings = SettingsVM()
    @StateObject var saved = SavedVM()
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var currentZoom = 1.0
    
    var overlay: some View {
        ZStack {
            settings.backgroundColor
                .ignoresSafeArea(.all)
            Text(vm.text)
                .font(.system(size: 1024, weight: .medium, design: .rounded))
                .minimumScaleFactor(0.001)
                .foregroundColor(settings.textColor)
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        .onDisappear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
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
            .overlay {
                if vm.overlay {
                    ZStack {
                        settings.backgroundColor.ignoresSafeArea(.all)
                        overlay
                            .scaleEffect(currentZoom)
                            .gesture(
                                MagnifyGesture()
                                    .onChanged { value in
                                        if value.magnification < 1 {
                                            currentZoom = value.magnification
                                        } else {
                                            print("no", value.magnification)
                                        }
                                    }
                                    .onEnded { value in
                                        print("ENDED", currentZoom)
                                        if (currentZoom < 0.8) {
                                            toggleOverlay()
                                        }
                                        currentZoom = 1.0
                                    }
                            )
                    }
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
        .task {
            SavedVM.load { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let items):
                    saved.items = items
                }
            }
        }
        .onChange(of: scenePhase) { old, new in
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
                    toggleOverlay()
                }
                .labelStyle(.titleAndIcon)
                .disabled(vm.text.isEmpty)
            }
        }
    }
    
    func toggleOverlay() {
        vm.overlay.toggle()
        vm.focus = !vm.overlay
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
