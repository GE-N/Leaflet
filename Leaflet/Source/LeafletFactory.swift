//
//  LeafletFactory.swift
//  Leaflet
//
//  Created by Jerapong Nampetch on 12/25/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

protocol LeafletItem {
  var delegate: BannerViewDelegate! { get set }
}

public enum LeafletType {
  case Generic(GenericBanner, GenericStyle?, GenericInteract?)
  case PointUpdate(PointUpdateBanner, LeafletStyle?)
  case Onboard
}

struct AnimationTiming {
  static let movement: NSTimeInterval = 0.3
  static let switcher: NSTimeInterval = 0.1
  static let popUp: NSTimeInterval = 1.5
  static let loaderDuration: NSTimeInterval = 0.7
  static let totalDelay: NSTimeInterval = popUp + movement * 2
}

let leafletFactory: LeafletFactory =  LeafletFactory()

public func Leaflet(type: LeafletType, on viewController: UIViewController) {
  leafletFactory.stick(type, on: viewController)
}

public func TearOff(from viewController: UIViewController, after delay: NSTimeInterval? = 0) {
  leafletFactory.tearOff(from: viewController, after: delay!)
}

class LeafletFactory {
  var leaflet: LeafletItem!
  var presentOnVC: UIViewController!
  var timer = NSTimer()
  
  func stick(type: LeafletType, on vc: UIViewController) {
    var delay: NSTimeInterval = 0
    if leafletOnViewController(vc) != nil {
      delay = AnimationTiming.movement
      dismissView()
    }
    
    presentOnVC = vc
    
    switch type {
    case .Generic(let banner, let style, let interact):
      leaflet = BannerView()      
      if let genericBannerView = leaflet as? BannerView {
        genericBannerView.details = banner
        genericBannerView.style = style ?? InformStyle()
        genericBannerView.interact = interact
      }
    case .PointUpdate(let banner, let style):
      leaflet = BannerPointView()
      if let pointBannerView = leaflet as? BannerPointView {
        pointBannerView.details = banner
        pointBannerView.style = style ?? DefaultStyle()
      }
    case .Onboard: break
    }
    
    leaflet.delegate = self
    
    gcdDelay(delay){ self.presentView() }
  }
  
  func tearOff(from viewController: UIViewController, after delay: NSTimeInterval = 0) {
    // ??? : What's the fuck unrecognize delayFired: method.
//        timer.invalidate()
//        timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "delayFired:", userInfo: nil, repeats: false)
    
    gcdDelay(delay){ self.dismissView() }
  }
  
  func delayFired(timer: NSTimer) {
    dismissView()
  }
  
  func presentView() {
    if let view = leaflet as? UIView {
      let showOnView = leaflet.delegate.onViewController().view
      view.frame.origin.y = -CGRectGetHeight(view.frame)
      showOnView.addSubview(view)
      
      UIView.animateWithDuration(AnimationTiming.movement, animations: { () -> Void in
        view.frame.origin.y = 64 })
        { (success) -> Void in
          if view.respondsToSelector("beginAnimation") && success == true {
            view.performSelector("beginAnimation")
        }
      }
    }
  }
  
  func dismissView() {
    guard leafletOnViewController(leaflet.delegate.onViewController()) != nil else { return }
    
    if let view = leaflet as? UIView {
      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        view.frame.origin.y = -CGRectGetHeight(view.frame)
      }) { success in view.removeFromSuperview() }
    }
  }
  
  private func leafletOnViewController(vc: UIViewController) -> LeafletItem? {
    for view in vc.view.subviews {
      if let leaflet = view as? LeafletItem { return leaflet }
    }
    return nil
  }
}

extension LeafletFactory : BannerViewDelegate {
  func onViewController() -> UIViewController {
    return presentOnVC
  }  
}