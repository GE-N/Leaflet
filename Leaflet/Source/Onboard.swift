//
//  Onboard.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/21/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

public struct Board {
  var text: String?
  var attributedText: NSAttributedString?
  var image: UIImage?
  var color: UIColor = UIColor(red:0.96, green:0.97, blue:0.97, alpha:1)
  var tapAction: (() -> Void)?
  
  var acceptAction: (() -> Void)?
  var rejectAction: (() -> Void)?
  
  init(text: String, image: UIImage?, tapAction: (() -> Void)?) {
    self.text = text
    self.image = image
    self.tapAction = tapAction
  }
  
  init(attributedText: NSAttributedString, image: UIImage?, tapAction: (() -> Void)?) {
    self.attributedText = attributedText
    self.image = image
    self.tapAction = tapAction
  }
  
  mutating func setSelectionActions(accept acceptAction: (() -> Void)?, reject rejectAction: (() -> Void)?) {
    self.acceptAction = acceptAction
    self.rejectAction = rejectAction
  }
  
  func isHaveOption() -> Bool {
    return acceptAction != nil && rejectAction != nil
  }
}
