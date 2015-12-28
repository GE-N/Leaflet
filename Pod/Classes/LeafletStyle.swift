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


public struct DefaultStyle : LeafletStyle {
  public var backgroundColor: UIColor?
  
  public init() {
    backgroundColor = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
  }
}

public struct InformStyle : GenericStyle {
  public var backgroundColor: UIColor?
  public var alignment: NSTextAlignment?
  
  public init() {
    backgroundColor = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
    alignment = .Left
  }
}
