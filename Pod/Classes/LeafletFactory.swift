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
  case generic(GenericBanner, LeafletStyle?, GenericInteract?)
  case pointUpdate(PointUpdateBanner, LeafletStyle?)
  case onboard(OnboardBanner, LeafletStyle?)
}

public enum LeafletPresentation {
  case top(y: CGFloat?)
  case topWindow
  case bottom
}

struct AnimationTiming {
  static let movement: TimeInterval = 0.3
  static let switcher: TimeInterval = 0.1
  static let popUp: TimeInterval = 1.5
  static let loaderDuration: TimeInterval = 0.7
  static let totalDelay: TimeInterval = popUp + movement * 2
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
  _ type: LeafletType,
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

public func TearOff(from viewController: UIViewController, after delay: TimeInterval? = 0) {
  leafletFactory.tearOff(from: viewController, after: delay!)
}

open class LeafletFactory : NSObject {
  var leaflet: LeafletItem!
  open var presentOnVC: UIViewController!
  var frontBannerView: UIView? = nil
  var presentation: LeafletPresentation = .top(y: nil)
  var timer = Timer()
  lazy var modalWindow: UIWindow = {
    let screenSize = UIScreen.main.bounds.size
    var window = UIWindow(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
    window.windowLevel = (UIWindowLevelStatusBar + 1)
    window.isHidden = false
    return window
  }()
  
  open func stick(
    _ type: LeafletType,
    on vc: UIViewController,
    after view: UIView? = nil,
    direction: LeafletPresentation? = nil,
    iconDimension: Dimension? = nil)
  {
    var delay: TimeInterval = 0
    if leafletOnViewController(vc) != nil {
      delay = AnimationTiming.movement
      dismissView()
    }
    
    presentOnVC = vc
    frontBannerView = view
    
    switch type {
    case .generic(let banner, let style, let interact):
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
    case .pointUpdate(let banner, let style):
      leaflet = BannerPointView()
      if let pointBannerView = leaflet as? BannerPointView {
        pointBannerView.details = banner
        pointBannerView.style = style ?? DefaultStyle()
        
        if iconDimension != nil {
          pointBannerView.dimension = iconDimension!
        }
        
        presentation = direction ?? banner.presentation
      }
    case .onboard(let banner, let style):
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
  
  open func tearOff(from viewController: UIViewController, after delay: TimeInterval = 0) {
    timer.invalidate()
    timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(LeafletFactory.delayFired(_:)), userInfo: nil, repeats: false)
  }
  
  func delayFired(_ timer: Timer) {
    dismissView()
  }
  
  func presentView() {
    if let view = leaflet as? UIView {
      let vc = leaflet.delegate.onViewController()
      var showOnView = vc.view
      
      var origin: CGPoint!
      var destPoint: CGPoint!
      
      switch presentation {
      case .top:
        origin = CGPoint(x: 0, y: -view.frame.height)
        destPoint = CGPoint(x: 0, y: 64)
      case .bottom:
        var yPos = screenHeight
        if let tabbarController = vc.tabBarController {
          yPos -= tabbarController.tabBar.frame.height
        }
        origin = CGPoint(x: 0, y: yPos)
        
        destPoint = origin
        destPoint.y -= view.frame.height
      case .topWindow:
        origin = CGPoint(x: 0, y: -view.frame.height)
        destPoint = CGPoint.zero
        showOnView = modalWindow
      }
      
      beginPresentBanner(view, on: showOnView!, move: (origin, destPoint))
    }
  }
  
  fileprivate func beginPresentBanner(_ banner: UIView,
    on presentView: UIView,
    move: (from: CGPoint, to: CGPoint)) {
    
      if presentView is UIWindow {
        modalWindow.isHidden = false
        modalWindow.addSubview(banner)
        modalWindow.frame.size.height = banner.bounds.height
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
      
      UIView.animate(
        withDuration: AnimationTiming.movement,
        animations: animatePresentBanner,
        completion: animateBannerAfterPresent)
  }
  
  fileprivate func animateBannerAfterPresent(_ animationSuccess: Bool) {
    guard let banner = leaflet as? UIView else { return }
    
    if banner.responds(to: #selector(UIView.beginAnimations(_:context:))) && animationSuccess {
        banner.perform(#selector(UIView.beginAnimations(_:context:)))
    }
//    if banner.respondsToSelector("beginAnimation") && animationSuccess == true {
//      banner.performSelector("beginAnimation")
//    }
  }
  
  func dismissView() {
    if let view = leaflet as? UIView {
      switch presentation {
      case .top:       beginDismissAnimationOnView(CGPoint(x: 0, y: -view.frame.height))
      case .bottom:    beginDismissAnimationOnView(CGPoint(x: 0, y: screenHeight))
      case .topWindow: beginDismissAnimationOnWindow()
      }
    }
  }
  
  fileprivate func beginDismissAnimationOnView(_ destPoint: CGPoint) {
    guard leafletOnViewController(leaflet.delegate.onViewController()) != nil else { return }
    if let view = leaflet as? UIView {
      UIView.animate(withDuration: AnimationTiming.movement, animations: {
        view.frame.origin = destPoint
      }, completion: { success in view.removeFromSuperview() }) 
    }
  }
  
  fileprivate func beginDismissAnimationOnWindow() {
    if let view = leaflet as? UIView {
      let destPoint = CGPoint(x: 0, y: -view.frame.height)
      UIView.animate(withDuration: AnimationTiming.movement, animations: {
        view.frame.origin = destPoint
      }, completion: { success in
        view.removeFromSuperview()
        self.modalWindow.isHidden = true
      }) 
    }
  }
  
  fileprivate func leafletOnViewController(_ vc: UIViewController) -> LeafletItem? {
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
