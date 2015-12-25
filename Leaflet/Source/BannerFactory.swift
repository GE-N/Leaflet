//
//  BannerFactory.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

let bannerFactory: BannerFactory = BannerFactory()

public func Banner(banner: BannerBody, to: UIViewController) {
  bannerFactory.craft(banner, on: to)
}

public func ClearBanner(viewController: UIViewController, after: NSTimeInterval = 0) {
  bannerFactory.demolish(viewController, after: after)
}

protocol BannerDelegate {
  var delegate: BannerViewDelegate! { get set }
  var style: BannerViewStyle? { get set }
}

class BannerFactory: NSObject {
  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }
  
  var bannerView: BannerDelegate!
  var bannerDetails: BannerBody!
  var presentVC: UIViewController!
  var tapAction: (() -> Void)? = nil
  
  var delayTimer = NSTimer()
  
  func craft(details: BannerBody, on vc: UIViewController) {
    var delay: NSTimeInterval = 0
    if let showingBanner = bannerIn(vc) {
      bannerView = showingBanner
      delay = AnimationTiming.movement
      dismissView()
    }
    
    switch details.type {
    case .Generic: bannerView = BannerView()
    case .Update(let point, let add, let text): bannerView = BannerPointView(point: point, adder: add, details: text)
    }
    
    bannerDetails = details
    presentVC = vc
    bannerView.style = self
    bannerView.delegate = self
    
    if let view = bannerView as? UIView {
      if details.supportSwipeUpForDismiss {
        let dismissSwipe = UISwipeGestureRecognizer(target: self, action: "dismissView")
        dismissSwipe.direction = .Up
        view.addGestureRecognizer(dismissSwipe)
      }
      
      if details.tapAction != nil {
        tapAction = details.tapAction
        let tapGesture = UITapGestureRecognizer(target: self, action: "performTap")
        view.addGestureRecognizer(tapGesture)
      }
      
      view.frame.origin.y = -CGRectGetHeight(view.frame)
      presentVC.view.addSubview(view)
      gcdDelay(delay) { [unowned self] in self.presentView() }
    }
  }
  
  func demolish(viewController: UIViewController, after: NSTimeInterval = 0) {
    delayTimer.invalidate()
    delayTimer = NSTimer.scheduledTimerWithTimeInterval(after, target: self, selector: "delayFired:", userInfo: nil, repeats: false)
  }
  
  func delayFired(timer: NSTimer) {
    dismissView()
  }
  
  func presentView() {
    guard presentVC.navigationController != nil else {
      print("Banner: Can not found UINavigationController instance on \(presentVC)")
      return
    }
    
    if let view = bannerView as? UIView {
      UIView.animateWithDuration(AnimationTiming.movement, animations: { () -> Void in
        view.frame.origin.y = 64
      }) { (success) -> Void in
        if view.respondsToSelector("beginAnimation") && success == true { view.performSelector("beginAnimation") }
      }
    }
  }
  
  func dismissView() {
    guard bannerView != nil else { return }
    
    if let view = bannerView as? UIView {
      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        view.frame.origin.y = -CGRectGetHeight(view.frame)
        }) { success in
          view.removeFromSuperview()
      }
    }
  }
  
  func performTap() {
    tapAction?()
  }
  
  private func bannerIn(vc: UIViewController) -> BannerDelegate? {
    for view in vc.view.subviews {
      if let banner = view as? BannerDelegate {
        return banner
      }
    }
    return nil
  }
}

extension BannerFactory : BannerViewDelegate {
  func onViewController() -> UIViewController {
    return presentVC
  }
  
  func bannerText() -> String {
    return bannerDetails.text
  }
  
  func bannerImageName() -> String? {
    return bannerDetails.imageName
  }
}

extension BannerFactory : BannerViewStyle {
  func labelTextAlignment() -> NSTextAlignment? {
    return bannerDetails.textAlignment
  }
  
  func backgroundColor() -> UIColor {
    return bannerDetails.color
  }
}