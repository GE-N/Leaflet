//
//  LeafletType.swift
//  Leaflet
//
//  Created by Jerapong Nampetch on 12/25/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

struct InformStyle : GenericStyle {
  var alignment: NSTextAlignment? = .Left
  var backgroundColor: UIColor? = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
}

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
