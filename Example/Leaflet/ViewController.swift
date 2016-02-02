//
//  FantribeBanner.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit
import Leaflet

class ViewController : UIViewController {
  lazy var genericBannerButton: UIButton = {
    let button = UIButton()
    button.setTitle("Multiline with action banner", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  lazy var genericCenter: UIButton = {
    let button = UIButton()
    button.setTitle("Banner text alignment center", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  lazy var tokenUpdateButton: UIButton = {
    let button = UIButton()
    button.setTitle("Token update", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  lazy var onboardButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "onboardButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Onboard with options", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  lazy var onboardNoOption: UIButton = {
    let button = UIButton()
    button.setTitle("Onboard without option", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Action", style: .Plain, target: self, action: "rightBarButton")
    
    title = "Leaflet events"
    view.backgroundColor = UIColor.whiteColor()
    
    view.addSubview(genericBannerButton)
    genericBannerButton.addTarget(self, action: "genericBannerTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(genericCenter)
    genericCenter.addTarget(self, action: "genericCenterTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(tokenUpdateButton)
    tokenUpdateButton.addTarget(self, action: "tokenUpdateTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(onboardButton)
    onboardButton.addTarget(self, action: "onboardButtonDidPress:", forControlEvents: .TouchUpInside)
    
    view.addSubview(onboardNoOption)
    onboardNoOption.addTarget(self, action: "onboardNoActionDidPress:", forControlEvents: .TouchUpInside)
    
    
    setLayout()
  }
  
  func rightBarButton() {
    print("Tapped on right button")
  }
  
  let offset: CGFloat = 15
  let buttonHeight: CGFloat = 50
  
  private func yPosNextTo(button: UIButton) -> CGFloat {
    return CGRectGetMaxY(button.frame) + offset
  }
  
  func setLayout() {
    let buttonWidth: CGFloat = CGRectGetWidth(view.frame) - (offset * 2)
    genericBannerButton.frame = CGRectMake(offset, 150, buttonWidth, buttonHeight)
    genericCenter.frame = CGRectMake(offset, yPosNextTo(genericBannerButton), buttonWidth, buttonHeight)
    tokenUpdateButton.frame = CGRectMake(offset, yPosNextTo(genericCenter), buttonWidth, buttonHeight)
    onboardButton.frame = CGRectMake(offset, yPosNextTo(tokenUpdateButton), buttonWidth, buttonHeight)
    onboardNoOption.frame = CGRectMake(offset, yPosNextTo(onboardButton), buttonWidth, buttonHeight)
  }
}

// MARK: - Actions

extension ViewController {
  func genericBannerTapped(sender: UIButton) {
    let multilineText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ***** You can swipe up on this banner for dismiss *****"
    let banner = InformBanner(title: multilineText, imageName: nil)
    var style = InformStyle()
    style.font = UIFont.boldSystemFontOfSize(14)
    var interact = InformInteract()
    interact.canSwipeUpForDismiss = true
    interact.tapAction = { print("Tapped in banner!!") }
    
    Leaflet(.Generic(banner, style, interact), on: self)
  }
  
  func genericCenterTapped(sender: UIButton) {
    let banner = InformBanner(title: "Connection lost", imageName: "lightblue-led")
    var style = InformStyle()
    style.alignment = .Center
    
    Leaflet(.Generic(banner, style, nil), on: self)
    TearOff(from: self, after: 2)
  }
  
  func tokenUpdateTapped(sender: UIButton) {
    var banner = PointBanner(augend: 12000, adder: -1000, title: "Loose a game", iconName: "token")
    banner.presentation = .TopWindow
    
    Leaflet(.PointUpdate(banner, nil), on: self)
    TearOff(from: self, after: 3)
  }
  
  func onboardButtonDidPress(button: UIButton) {
    let boardText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    let iconName = "check"
    
    var board = Onboard(title: boardText, iconName: iconName)
    board.setTapAction { print("tapped on Onboard") }
    board.setAcceptAction { print("Accepted") }
    board.setDeniedAction { [unowned self] in
      print("Denied")
      TearOff(from: self, after: 0)
    }
    
    var style = InformStyle()
    style.font = UIFont(name: "American Typewriter", size: 16)
    style.textColor = UIColor.brownColor()
    style.border = 0
    style.declineIcon = UIImage(named: "white-crs")
    style.acceptIcon = UIImage(named: "white-chk")
    style.acceptBackgroundColor = UIColor(red: 0.28, green: 0.59, blue: 0.11, alpha: 1)
    style.declineBackgroundColor = UIColor(red: 0.85, green: 0.31, blue: 0.31, alpha: 1)
    
    Leaflet(.Onboard(board, style), on: self)
  }
  
  func onboardNoActionDidPress(sender: UIButton) {
    let boardText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    let iconName = "check"
    
    var board = Onboard(title: boardText, iconName: iconName)
    board.setTapAction { print("tapped on Onboard") }
    
    Leaflet(.Onboard(board, nil), on: self)  }
}