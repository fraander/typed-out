//
//  PresenterOverlay.swift
//  typed-out
//
//  Created by Frank Anderson on 3/7/24.
//

import SwiftUI

struct PresenterOverlay: View {
    
    @EnvironmentObject var settings: SettingsVM
    @EnvironmentObject var vm: TextVM
    
    @State private var currentZoom = 1.0
    
    var body: some View {
        ZStack {
            Color(cgColor: settings.backgroundColor.cgColor)
                .ignoresSafeArea(.all)
            
            ZStack {
                Color(cgColor: settings.backgroundColor.cgColor)
                    .ignoresSafeArea(.all)
                Text(vm.text)
                    .font(.system(size: 1024, weight: .medium, design: .rounded))
                    .minimumScaleFactor(0.001)
                    .foregroundColor(
                        Color(cgColor: settings.textColor.cgColor)
                    )
            }
            #if os(iOS)
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
            #endif
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
                            vm.toggleOverlay()
                        }
                        currentZoom = 1.0
                    }
            )
        }
    }
}

#Preview {
    PresenterOverlay()
        
}
