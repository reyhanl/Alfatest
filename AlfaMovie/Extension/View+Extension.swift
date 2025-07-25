//
//  View+Extension.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import SwiftUI

extension View {
    /// Call this to update supported interface orientations dynamically in SwiftUI
    func modifyOrientation(_ mask: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Set the new orientation preference
            AppDelegate.orientation = mask
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask)) { error in
                    print("Failed to update orientation: \(error)")
                }
            } else {
                if let orientation = preferredOrientationFrom(mask) {
                    UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
                    UIViewController.attemptRotationToDeviceOrientation()
                }
            }

            // Ask the root view controller to refresh its orientation support
            if #available(iOS 16.0, *) {
                windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func preferredOrientationFrom(_ mask: UIInterfaceOrientationMask) -> UIInterfaceOrientation? {
        if mask.contains(.portrait) { return .portrait }
        if mask.contains(.landscapeLeft) { return .landscapeLeft }
        if mask.contains(.landscapeRight) { return .landscapeRight }
        if mask.contains(.portraitUpsideDown) { return .portraitUpsideDown }
        return nil
    }
}
