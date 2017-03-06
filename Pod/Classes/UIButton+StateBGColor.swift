//  UIButton+StateBGColor.swift
//  ButtonExtension
//
//  Created by Jerapong Nampetch on 7/19/2558 BE.
//  Copyright (c) 2558 Jerapong Nampetch. All rights reserved.
//

import UIKit

private var highlightBGColorKey = 0
private var selectedBGColorKey = 0
private var disableBGColorKey = 0

extension UIButton {
  @IBInspectable var highlightBGColor: UIColor? {
    get {
      return objc_getAssociatedObject(self, &highlightBGColorKey) as? UIColor
    }
    set {
      guard let normalColor = backgroundColor,
        let highlightColor = newValue else { return }
      objc_setAssociatedObject(self, &highlightBGColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      setBackgroundImage(bgColorImage(color: normalColor), for: .normal)
      setBackgroundImage(bgColorImage(color: highlightColor), for: .highlighted)
    }
  }
  
  @IBInspectable var selectedBGColor: UIColor? {
    get {
      return objc_getAssociatedObject(self, &selectedBGColorKey) as? UIColor
    }
    set {
      guard let normalColor = backgroundColor,
        let selectedColor = newValue else { return }
      objc_setAssociatedObject(self, &selectedBGColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      setBackgroundImage(bgColorImage(color: normalColor), for: .normal)
      setBackgroundImage(bgColorImage(color: selectedColor), for: .selected)
    }
  }
  
  @IBInspectable var disabledBGColor: UIColor? {
    get {
      return objc_getAssociatedObject(self, &disableBGColorKey) as? UIColor
    }
    set {
      guard let normalColor = backgroundColor,
        let disabledColor = newValue else { return }
      objc_setAssociatedObject(self, &disableBGColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      setBackgroundImage(bgColorImage(color: normalColor), for: .normal)
      setBackgroundImage(bgColorImage(color: disabledColor), for: .disabled)
    }
  }
  
  // Create 1px image from quartz, inspired from
  // http://stackoverflow.com/questions/9151379/is-it-possible-to-use-quartz-2d-to-make-a-uiimage-on-another-thread
  func bgColorImage(color: UIColor) -> UIImage {
    let size = CGSize(width: 1, height: 1)
    let opaque = false
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    color.setFill()
    UIRectFill(CGRect(origin: CGPoint.zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
  }
}
