//
//  FantribeBanner.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
  lazy var genericBannerButton: UIButton = {
    let button = UIButton()
    button.setTitle("Generic Banner", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
  }()
  
  lazy var genericCenter: UIButton = {
    let button = UIButton()
    button.setTitle("Generic with Center Alignment", forState: .Normal)
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
    button.setTitle("Onboard", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGrayColor()
    
    return button
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Fantribe events"
    view.backgroundColor = UIColor.whiteColor()
    
    view.addSubview(genericBannerButton)
    genericBannerButton.addTarget(self, action: "genericBannerTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(genericCenter)
    genericCenter.addTarget(self, action: "genericCenterTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(tokenUpdateButton)
    tokenUpdateButton.addTarget(self, action: "tokenUpdateTapped:", forControlEvents: .TouchUpInside)
    
    view.addSubview(onboardButton)
    onboardButton.addTarget(self, action: "onboardButtonDidPress:", forControlEvents: .TouchUpInside)
    
    setLayout()
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
  }
}

// MARK: - Actions

extension ViewController {
  func genericBannerTapped(sender: UIButton) {
    let multilineText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ***** You can swipe up on this banner for dismiss *****"
    var body = BannerBody(type: .Generic(text: multilineText, imageName: "lightblue-led", alignment: .Left))
    body.supportSwipeUpForDismiss = true
    body.tapAction = { print("tapped on banner") }
    
    Banner(body, to: self)
  }
  
  func genericCenterTapped(sender: UIButton) {
    let text = "Connection lost"
    let body = BannerBody(type: .Generic(text: text, imageName: nil, alignment: .Center))
    Banner(body, to: self)
    
    ClearBanner(self, after: 2)
  }
  
  func tokenUpdateTapped(sender: UIButton) {
    let type = BannerType.Update(point: 13000, add: -1000, text: "Profile updated.")
    let body = BannerBody(type: type)
    
    Banner(body, to: self)
    ClearBanner(self, after: 3)
  }
  
  func onboardButtonDidPress(button: UIButton) {
    var board = Board(text: "Hello, I'm here. I'm board. You know me? Yes, you are.Hello, I'm here. I'm board. You know me? Yes, you are.Hello, I'm here. I'm board. You know me? Yes, you are.Hello, I'm here. I'm board. You know me? Yes, you are.",
      image: UIImage(named: "star")) { Void in
        print("tapped on Onboard")
    }
    board.setSelectionActions(accept: { () -> Void in
      print("Accepted")
      }) { [unowned self] Void in
        print("Rejected")
        Clearboard(self)
    }
    
    Onboard(board, to: self)
    //    Clearboard(self, after: 3)
  }
}