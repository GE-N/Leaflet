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
  var alignment: NSTextAlignment? { get }
}

public protocol GenericStyle : LeafletStyle {
  var border: CGFloat? { get }
  var acceptIcon: UIImage? { get }
  var acceptBackgroundColor: UIColor? { get }
  var declineIcon: UIImage? { get }
  var declineBackgroundColor: UIColor? { get }
}


public struct DefaultStyle : LeafletStyle {
  public var backgroundColor: UIColor?
  public var font: UIFont?
  public var textColor: UIColor?
  public var alignment: NSTextAlignment?
  
  public init() {
    backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    font            = UIFont.systemFontOfSize(14)
    textColor       = UIColor.blackColor()
    alignment       = .Left
  }
}

public struct InformStyle : GenericStyle {
  public var backgroundColor: UIColor?
  public var font: UIFont?
  public var textColor: UIColor?
  
  public var border: CGFloat?
  public var alignment: NSTextAlignment?
  public var acceptIcon: UIImage?
  public var acceptBackgroundColor: UIColor?
  public var declineIcon: UIImage?
  public var declineBackgroundColor: UIColor?
  
  public init() {
    backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    font            = UIFont.systemFontOfSize(14)
    textColor       = UIColor.blackColor()
    
    border          = 1
    alignment       = .Left
    acceptIcon      = nil
    declineIcon     = nil
    acceptBackgroundColor   = nil
    declineBackgroundColor  = nil
  }
}
