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
  func heighWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect,
                                        options: .usesLineFragmentOrigin,
                                        attributes: [.font: font], context: nil)
    return boundingBox.height
  }
}
