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
  case Onboard(OnboardBanner)
}

public enum LeafletPresentation {
  case Top
  case Bottom
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
  var presentation: LeafletPresentation = .Top
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
        presentation = banner.presentation
      }
    case .PointUpdate(let banner, let style):
      leaflet = BannerPointView()
      if let pointBannerView = leaflet as? BannerPointView {
        pointBannerView.details = banner
        pointBannerView.style = style ?? DefaultStyle()
        presentation = banner.presentation
      }
    case .Onboard(let banner):
      leaflet = OnboardView()
      if let onboardView = leaflet as? OnboardView {
        onboardView.details = banner
        presentation = banner.presentation
      }
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
      let vc = leaflet.delegate.onViewController()
      let showOnView = vc.view
      
      var origin: CGPoint!
      var destPoint: CGPoint!
      
      switch presentation {
      case .Top:
        origin = CGPointMake(0, -CGRectGetHeight(view.frame))
        destPoint = CGPointMake(0, 64)
      case .Bottom:
        var yPos = screenHeight
        if let tabbarController = vc.tabBarController {
          yPos -= CGRectGetHeight(tabbarController.tabBar.frame)
        }
        origin = CGPointMake(0, yPos)
        
        destPoint = origin
        destPoint.y -= CGRectGetHeight(view.frame)
      }
      
      view.frame.origin = origin
      showOnView.addSubview(view)
      
      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        view.frame.origin = destPoint })
        { success in
          if view.respondsToSelector("beginAnimation") && success == true {
            view.performSelector("beginAnimation")
        }
      }
    }
  }
  
  func dismissView() {
    guard leafletOnViewController(leaflet.delegate.onViewController()) != nil else { return }
    
    var destPoint: CGPoint!
    
    if let view = leaflet as? UIView {
      switch presentation {
      case .Top: destPoint = CGPointMake(0, -CGRectGetHeight(view.frame))
      case .Bottom: destPoint = CGPointMake(0, screenHeight)
      }
      
      if let view = leaflet as? UIView {
        UIView.animateWithDuration(AnimationTiming.movement, animations: {
          view.frame.origin = destPoint
        }) { success in view.removeFromSuperview() }
      }
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