//
//  LeafletStyle.swift
//  Leaflet
//
//  Created by Jerapong Nampetch on 12/28/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

public protocol LeafletStyle {
  var backgroundColor: UIColor? { get }
}

public protocol GenericStyle : LeafletStyle {
  var alignment: NSTextAlignment? { get }
}


struct DefaultStyle : LeafletStyle {
  var backgroundColor: UIColor? = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
}

struct InformStyle : GenericStyle {
  var backgroundColor: UIColor? = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
  var alignment: NSTextAlignment? = .Left
}
