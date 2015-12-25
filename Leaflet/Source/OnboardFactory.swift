//
//  OnboardFactory.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/21/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

let onboardFactory: OnboardFactory = OnboardFactory()

public func Onboard(board: Board, to: UIViewController) {
  onboardFactory.craft(board, viewController: to)
}

public func Clearboard(viewController: UIViewController, after: NSTimeInterval = 0) {
  onboardFactory.demolish(viewController, after: after)
}

class OnboardFactory: NSObject {
  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }

  var onboardView: OnboardView!
  var onViewController: UIViewController!
  var delayTimer = NSTimer()
  
  func craft(board: Board, viewController: UIViewController) {
    onboardView = OnboardView(board: board)
    onViewController = viewController
    onboardView.delegate = self
    
    var delay: NSTimeInterval = 0
    if onboardIn(viewController) != nil {
      delay = AnimationTiming.movement
      demolish(viewController)
    }
    
    gcdDelay(delay) {
      viewController.view.addSubview(self.onboardView)
      self.presentView()
    }
  }
  
  func presentView() {
    UIView.animateWithDuration(AnimationTiming.movement) { [unowned self] in
      self.onboardView.frame.origin.y = self.bottomYPos(self.onViewController) - onboardViewHeight
    }
  }
  
  func dismissView() {
    guard onboardView != nil else { return }
    
    UIView.animateWithDuration(AnimationTiming.movement, animations: { [unowned self] Void in
      self.onboardView.frame.origin.y = screenHeight
    }) { success in
      self.onboardView.removeFromSuperview()
    }
  }
  
  func demolish(viewController: UIViewController, after: NSTimeInterval = 0) {
    onboardView = onboardIn(viewController)
    delayTimer.invalidate()
    delayTimer = NSTimer.scheduledTimerWithTimeInterval(after, target: self, selector: "delayFired:", userInfo: nil, repeats: false)
  }
  
  func delayFired(timer: NSTimer) {
    dismissView()
  }
  
  // MARK: - Helper methods
  
  private func bottomYPos(vc: UIViewController) -> CGFloat {
    let screenHeight = CGRectGetHeight(vc.view.frame)
    if vc.tabBarController == nil {
      return screenHeight
    }
    
    return screenHeight - CGRectGetHeight((vc.tabBarController?.tabBar.frame)!)
  }
  
  private func onboardIn(viewController: UIViewController) -> OnboardView? {
    for subview in viewController.view.subviews {
      if let onboard = subview as? OnboardView {
        return onboard
      }
    }
    return nil
  }
}

extension OnboardFactory : OnboardViewDelegate {
  func dismissFromViewController() -> UIViewController {
    return onViewController
  }
}