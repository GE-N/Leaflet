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
  
  init(title: String, imageName: String?) {
    self.title = title
    self.imageName = imageName
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
  
  init(augend: Int16, adder: Int16, title: String, iconName: String?) {
    self.title = title
    self.augend = augend
    self.adder = adder
    self.imageName = iconName
  }
}
