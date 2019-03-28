//
//  LeafletType.swift
//  Leaflet
//
//  Created by Jerapong Nampetch on 12/25/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

public struct InformBanner : GenericBanner {
  public let title: String
  public let imageName: String?
  public var presentation: LeafletPresentation!
  
  public init(title: String, imageName: String?) {
    self.title = title
    self.imageName = imageName
    presentation = .top(y: nil)
  }
}

public struct InformInteract : GenericInteract {
  public var canSwipeUpForDismiss: Bool
  public var tapAction: (() -> Void)?
  
  public init() {
    canSwipeUpForDismiss = false
  }
}




public struct PointBanner : PointUpdateBanner {
  public let title: String
  public let imageName: String?
  public let augend: Int
  public let adder: Int
  public var presentation: LeafletPresentation!
  
  public init(augend: Int, adder: Int, title: String, iconName: String?) {
    self.title = title
    self.augend = augend
    self.adder = adder
    self.imageName = iconName
    presentation = .top(y: nil)
  }
}



public struct Onboard : OnboardBanner {
  public typealias OnboardAction = (() -> Void)
  public let title: NSAttributedString!
  public let iconName: String?
  public var tapAction: OnboardAction?
  public var acceptAction: OnboardAction?
  public var deniedAction: OnboardAction?
  public var presentation: LeafletPresentation!
  
  public init(title: String, iconName: String?) {
    self.title = NSAttributedString(string: title)
    self.iconName = iconName
    presentation = .bottom
  }
  
  public init(attrTitle: NSAttributedString, iconName: String?) {
    self.title = attrTitle
    self.iconName = iconName
    presentation = .bottom
  }
  
  public mutating func setTapAction(_ action: @escaping OnboardAction) {
    self.tapAction = action
  }
  
  public mutating func setAcceptAction(_ action: @escaping OnboardAction) {
    self.acceptAction = action
  }
  
  public mutating func setDeniedAction(_ action: @escaping OnboardAction) {
    self.deniedAction = action
  }
}
