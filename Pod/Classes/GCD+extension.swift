//
//  GCD+extension.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import Foundation

func gcdDelay(_ time: TimeInterval, closure: @escaping (() -> Void)) {
  let delayTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
  DispatchQueue.main.asyncAfter(deadline: delayTime) {
    closure()
  }
}
