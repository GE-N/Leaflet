//
//  String+Extension.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/22/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

// String's height calculation ideas from http://stackoverflow.com/a/30450559/150768

extension String {
  func heighWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.max)
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return boundingBox.height
  }
}