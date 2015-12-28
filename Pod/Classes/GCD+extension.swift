//
//  GCD+extension.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

func gcdDelay(time: NSTimeInterval, closure: (Void -> ())) {
  let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
  dispatch_after(delayTime, dispatch_get_main_queue()) {
    closure()
  }
}