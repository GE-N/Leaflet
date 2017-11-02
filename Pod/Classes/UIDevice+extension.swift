//
//  UIDevice+extension.swift
//  Pods
//
//  Created by Jerapong Nampetch on 11/2/2560 BE.
//

import Foundation

extension UIDevice {
  var isIphoneX: Bool {
    guard userInterfaceIdiom == .phone else { return false }
    switch UIScreen.main.nativeBounds.height {
    case 2436: return true
    default: return false
    }
  }
}
