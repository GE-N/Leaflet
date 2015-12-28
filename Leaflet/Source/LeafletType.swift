//
//  LeafletType.swift
//  Leaflet
//
//  Created by Jerapong Nampetch on 12/25/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

struct InformBanner : GenericBanner {
  let title: String!
  let imageName: String?
  var presentation: LeafletPresentation!
  
  init(title: String, imageName: String?) {
    self.title = title
    self.imageName = imageName
    presentation = .Top
  }
}

struct InformInteract : GenericInteract {
  var canSwipeUpForDismiss: Bool = false
  var tapAction: (() -> Void)?
}




struct PointBanner : PointUpdateBanner {
  let title: String!
  let imageName: String?
  let augend: Int16
  let adder: Int16
  var presentation: LeafletPresentation!
  
  init(augend: Int16, adder: Int16, title: String, iconName: String?) {
    self.title = title
    self.augend = augend
    self.adder = adder
    self.imageName = iconName
    presentation = .Top
  }
}



struct Onboard : OnboardBanner {
  typealias OnboardAction = (Void -> ())
  let title: String!
  let iconName: String?
  var tapAction: OnboardAction?
  var acceptAction: OnboardAction?
  var deniedAction: OnboardAction?
  var presentation: LeafletPresentation!
  
  init(title: String, iconName: String?) {
    self.title = title
    self.iconName = iconName
    presentation = .Bottom
  }
  
  mutating func setTapAction(action: OnboardAction) {
    self.tapAction = action
  }
  
  mutating func setAcceptAction(action: OnboardAction) {
    self.acceptAction = action
  }
  
  mutating func setDeniedAction(action: OnboardAction) {
    self.deniedAction = action
  }
}
