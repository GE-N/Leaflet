//
//  Banner.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

enum BannerType {
  case Generic(text: String, imageName: String?, alignment: NSTextAlignment?)
  case Update(point: Int16, add: Int16, text: String)
}

public struct BannerBody {
  let type: BannerType
  let text: String!
  var textAlignment: NSTextAlignment? = .Left
  var imageName: String? = nil
  
  var color = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
  var supportSwipeUpForDismiss = false
  var tapAction: (() -> Void)?
  
  init(type: BannerType) {
    self.type = type
    
    switch type {
    case .Generic(let bannerText, let imgName, let alignment):
      text = bannerText
      imageName = imgName
      textAlignment = alignment
    case .Update(let point, _, _):
      text = "\(point)"
      imageName = "token"
    }
  }
}