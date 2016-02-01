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
  var font: UIFont? { get }
  var textColor: UIColor? { get }
}

public protocol GenericStyle : LeafletStyle {
  var alignment: NSTextAlignment? { get }
}


public struct DefaultStyle : LeafletStyle {
  public var backgroundColor: UIColor?
  public var font: UIFont?
  public var textColor: UIColor?
  
  public init() {
    backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    font            = UIFont.systemFontOfSize(14)
    textColor       = UIColor.blackColor()
  }
}

public struct InformStyle : GenericStyle {
  public var backgroundColor: UIColor?
  public var alignment: NSTextAlignment?
  public var font: UIFont?
  public var textColor: UIColor?
  
  public init() {
    backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    font            = UIFont.systemFontOfSize(14)
    textColor       = UIColor.blackColor()
    alignment       = .Left
  }
}
