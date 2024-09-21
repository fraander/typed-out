//
//  AppDelegate.swift
//  typed-out
//
//  Created by Frank Anderson on 3/7/24.
//

#if os(iOS)
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
#endif
