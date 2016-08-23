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
  case Generic(GenericBanner, LeafletStyle?, GenericInteract?)
  case PointUpdate(PointUpdateBanner, LeafletStyle?)
  case Onboard(OnboardBanner, LeafletStyle?)
}

public enum LeafletPresentation {
  case Top(y: CGFloat?)
  case TopWindow
  case Bottom
}

struct AnimationTiming {
  static let movement: NSTimeInterval = 0.3
  static let switcher: NSTimeInterval = 0.1
  static let popUp: NSTimeInterval = 1.5
  static let loaderDuration: NSTimeInterval = 0.7
  static let totalDelay: NSTimeInterval = popUp + movement * 2
}

/**
 Dimension struct for manipulate banner's icon.
 */

public struct Dimension {
  var offset: CGFloat
  var width: CGFloat
  var imageSize: CGSize
  
  public init(space offset: CGFloat, width: CGFloat, image size: CGSize) {
    self.offset = offset
    self.width = width
    imageSize = size
  }
}

let leafletFactory: LeafletFactory =  LeafletFactory()

/**
 Present a banner each type.
 
 - parameter type: Banner type want to present. Can be 3 types 'Generic/Point/Onboard'.
 - parameter on: ViewController which need to present a banner.
 - parameter after: View need to set banner set after. (ex if not default Navigation bar)
 - parameter direction: Customed direction need to present banner. Can be 3 types 'TopWindow, Top, Bottom'.
 - parameter iconDimension: Banner image appearance.
*/
public func Leaflet(
  type: LeafletType,
  on viewController: UIViewController,
  after view: UIView? = nil,
  direction: LeafletPresentation? = nil,
  iconDimension: Dimension? = nil)
{
  leafletFactory.stick(
    type,
    on: viewController,
    after: view,
    direction: direction,
    iconDimension: iconDimension)
}

public func TearOff(from viewController: UIViewController, after delay: NSTimeInterval? = 0) {
  leafletFactory.tearOff(from: viewController, after: delay!)
}

public class LeafletFactory : NSObject {
  var leaflet: LeafletItem!
  public var presentOnVC: UIViewController!
  var frontBannerView: UIView? = nil
  var presentation: LeafletPresentation = .Top(y: nil)
  var timer = NSTimer()
  lazy var modalWindow: UIWindow = {
    let screenSize = UIScreen.mainScreen().bounds.size
    var window = UIWindow(frame: CGRectMake(0, 0, screenSize.width, 64))
    window.windowLevel = (UIWindowLevelStatusBar + 1)
    window.hidden = false
    return window
  }()
  
  public func stick(
    type: LeafletType,
    on vc: UIViewController,
    after view: UIView? = nil,
    direction: LeafletPresentation? = nil,
    iconDimension: Dimension? = nil)
  {
    var delay: NSTimeInterval = 0
    if leafletOnViewController(vc) != nil {
      delay = AnimationTiming.movement
      dismissView()
    }
    
    presentOnVC = vc
    frontBannerView = view
    
    switch type {
    case .Generic(let banner, let style, let interact):
      leaflet = BannerView()      
      if let genericBannerView = leaflet as? BannerView {
        genericBannerView.details = banner
        genericBannerView.style = style ?? DefaultStyle()
        genericBannerView.interact = interact
        
        if iconDimension != nil {
          genericBannerView.dimension = iconDimension!
        }
        
        presentation = direction ?? banner.presentation
      }
    case .PointUpdate(let banner, let style):
      leaflet = BannerPointView()
      if let pointBannerView = leaflet as? BannerPointView {
        pointBannerView.details = banner
        pointBannerView.style = style ?? DefaultStyle()
        
        if iconDimension != nil {
          pointBannerView.dimension = iconDimension!
        }
        
        presentation = direction ?? banner.presentation
      }
    case .Onboard(let banner, let style):
      leaflet = OnboardView()
      if let onboardView = leaflet as? OnboardView {
        onboardView.details = banner
        onboardView.style = style ?? DefaultStyle()
        
        if iconDimension != nil {
          onboardView.dimension = iconDimension!
        }
        
        presentation = direction ?? banner.presentation
      }
    }
    
    leaflet.delegate = self
    
    gcdDelay(delay){ self.presentView() }
  }
  
  public func tearOff(from viewController: UIViewController, after delay: NSTimeInterval = 0) {
    timer.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(LeafletFactory.delayFired(_:)), userInfo: nil, repeats: false)
  }
  
  func delayFired(timer: NSTimer) {
    dismissView()
  }
  
  func presentView() {
    if let view = leaflet as? UIView {
      let vc = leaflet.delegate.onViewController()
      var showOnView = vc.view
      
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
      case .TopWindow:
        origin = CGPointMake(0, -CGRectGetHeight(view.frame))
        destPoint = CGPointZero
        showOnView = modalWindow
      }
      
      beginPresentBanner(view, on: showOnView, move: (origin, destPoint))
    }
  }
  
  private func beginPresentBanner(banner: UIView,
    on presentView: UIView,
    move: (from: CGPoint, to: CGPoint)) {
    
      if presentView is UIWindow {
        modalWindow.hidden = false
        modalWindow.addSubview(banner)
        modalWindow.frame.size.height = CGRectGetHeight(banner.bounds)
      } else {
        if frontBannerView != nil {
          presentView.insertSubview(banner, belowSubview: frontBannerView!)
        } else {
          presentView.addSubview(banner)
        }
      }
      
      banner.frame.origin = move.from
      func animatePresentBanner() {
        banner.frame.origin = move.to
      }
      
      UIView.animateWithDuration(
        AnimationTiming.movement,
        animations: animatePresentBanner,
        completion: animateBannerAfterPresent)
  }
  
  private func animateBannerAfterPresent(animationSuccess: Bool) {
    guard let banner = leaflet as? UIView else { return }
    
    if banner.respondsToSelector(#selector(UIView.beginAnimations(_:context:))) && animationSuccess {
        banner.performSelector(#selector(UIView.beginAnimations(_:context:)))
    }
//    if banner.respondsToSelector("beginAnimation") && animationSuccess == true {
//      banner.performSelector("beginAnimation")
//    }
  }
  
  func dismissView() {
    if let view = leaflet as? UIView {
      switch presentation {
      case .Top:       beginDismissAnimationOnView(CGPointMake(0, -CGRectGetHeight(view.frame)))
      case .Bottom:    beginDismissAnimationOnView(CGPointMake(0, screenHeight))
      case .TopWindow: beginDismissAnimationOnWindow()
      }
    }
  }
  
  private func beginDismissAnimationOnView(destPoint: CGPoint) {
    guard leafletOnViewController(leaflet.delegate.onViewController()) != nil else { return }
    if let view = leaflet as? UIView {
      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        view.frame.origin = destPoint
      }) { success in view.removeFromSuperview() }
    }
  }
  
  private func beginDismissAnimationOnWindow() {
    if let view = leaflet as? UIView {
      let destPoint = CGPointMake(0, -CGRectGetHeight(view.frame))
      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        view.frame.origin = destPoint
      }) { success in
        view.removeFromSuperview()
        self.modalWindow.hidden = true
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