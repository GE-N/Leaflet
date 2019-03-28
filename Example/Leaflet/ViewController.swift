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
    button.setTitle("Multiline with action banner", for: .normal)
    button.setTitleColor(UIColor.darkGray, for: .normal)
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGray
    
    return button
  }()
  
  lazy var genericCenter: UIButton = {
    let button = UIButton()
    button.setTitle("Banner text alignment center", for: .normal)
    button.setTitleColor(UIColor.darkGray, for: .normal)
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGray
    
    return button
  }()
  
  lazy var tokenUpdateButton: UIButton = {
    let button = UIButton()
    button.setTitle("Token update", for: .normal)
    button.setTitleColor(UIColor.darkGray, for: .normal)
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGray
    
    return button
  }()
  
  lazy var onboardButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.setTitle("Onboard with options", for: .normal)
    button.setTitleColor(UIColor.darkGray, for: .normal)
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGray
    
    return button
  }()
  
  lazy var onboardNoOption: UIButton = {
    let button = UIButton()
    button.setTitle("Onboard without option", for: .normal)
    button.setTitleColor(UIColor.darkGray, for: .normal)
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.lightGray
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightBarButtonAction = #selector(rightBarButton)
    navigationItem.rightBarButtonItem =
      UIBarButtonItem(title: "Action", style: .plain, target: self, action: rightBarButtonAction)
    
    title = "Leaflet events"
    view.backgroundColor = UIColor.white
    
    view.addSubview(genericBannerButton)
    genericBannerButton.addTarget(self, action: #selector(genericBannerTapped(sender:)), for: .touchUpInside)
    
    view.addSubview(genericCenter)
    genericCenter.addTarget(self, action: #selector(genericCenterTapped(sender:)), for: .touchUpInside)
    
    view.addSubview(tokenUpdateButton)
    tokenUpdateButton.addTarget(self, action: #selector(tokenUpdateTapped(sender:)), for: .touchUpInside)
    
    view.addSubview(onboardButton)
    onboardButton.addTarget(self, action: #selector(onboardWithOptionDidPress(button:)), for: .touchUpInside)
    
    view.addSubview(onboardNoOption)
    onboardNoOption.addTarget(self, action: #selector(onboardNoActionDidPress(sender:)), for: .touchUpInside)
    
    setLayout()
  }
  
  @objc func rightBarButton() {
    print("Tapped on right button")
  }
  
  let offset: CGFloat = 15
  let buttonHeight: CGFloat = 50
  
  private func yPos(nextTo view: UIView) -> CGFloat {
    return view.frame.maxY + offset
  }
  
  func setLayout() {
    let width: CGFloat = view.frame.width - (offset * 2)
    genericBannerButton.frame = CGRect(x: offset, y: 150, width: width, height: buttonHeight)
    genericCenter.frame = CGRect(x: offset, y: yPos(nextTo: genericBannerButton), width: width, height: buttonHeight)
    tokenUpdateButton.frame = CGRect(x: offset, y: yPos(nextTo: genericCenter), width: width, height: buttonHeight)
    onboardButton.frame = CGRect(x: offset, y: yPos(nextTo: tokenUpdateButton), width: width, height: buttonHeight)
    onboardNoOption.frame = CGRect(x: offset, y: yPos(nextTo: onboardButton), width: width, height: buttonHeight)
  }
  
  public override func viewWillTransition(to size: CGSize,
                                          with coordinator: UIViewControllerTransitionCoordinator) {
    print("rotated to size \(size)")
    
    view.layoutSubviews()
    
    if let banner = view.subviews.filter({ $0 is Leaflet.OnboardView }).first {
//      banner.snp.makeConstraints{
//        $0.left.equalTo(self.view)
//        $0.right.equalTo(self.view)
//        $0.bottom.equalTo(self.view).offset(-44)
//        $0.height.equalTo(70)
//      }
//      
//      view.layoutSubviews()
      //			print(banner)
      //			banner.layoutSubviews()
      //
      ////			if let _ = UserDefaults.standard.value(forKey: "notificationPermissionKey"),
      ////				isNotifyInformViewPresented == false {
      //				presentNotifySettingBannerIfNeed(.newsfeed, view: self)
      ////			}
    }
    
  }
}

// MARK: - Actions

extension ViewController {
  @objc func genericBannerTapped(sender: UIButton) {
    let multilineText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ***** You can swipe up on this banner for dismiss *****"
    let banner = InformBanner(title: multilineText, imageName: nil)
    var style = InformStyle()
    
    style.font = UIFont.boldSystemFont(ofSize: 19)
    var interact = InformInteract()
    interact.canSwipeUpForDismiss = true
    interact.tapAction = { print("Tapped in banner!!") }
    
    Leaflet(.generic(banner, style, interact), on: self)
  }
  
  @objc func genericCenterTapped(sender: UIButton) {
    let banner = InformBanner(title: "Connection lost", imageName: "lightblue-led")
    var style = InformStyle()
    style.alignment = .center
    
    Leaflet(.generic(banner, style, nil), on: self)
    TearOff(from: self, after: 2)
  }
  
  @objc func tokenUpdateTapped(sender: UIButton) {
    var banner = PointBanner(augend: 12000, adder: -1000, title: "Loose a game, Loose a game, Loose a game, Loose a game",
//                             iconName: nil)
                             iconName: "token")
    banner.presentation = .topWindow
    
    var style = DefaultStyle()
    style.backgroundColor = UIColor(red: 0.85, green: 0.31, blue: 0.31, alpha: 0.85)
    style.textColor       = UIColor.white
    style.font            = UIFont.boldSystemFont(ofSize: 16)  // UIFont(name: "American Typewriter", size: 16)
    
    // Present banner in top window by default action.
    //
    // Leaflet(.PointUpdate(banner, style), on: self)
    
    // Present banner by custom direction.
    Leaflet(.pointUpdate(banner, style), on: self, direction: .top(y: nil))
    
    TearOff(from: self, after: 3)
  }
  
  @objc func onboardWithOptionDidPress(button: UIButton) {
    let boardText = "Be notified when the next match is about to start. Settings"
    
    let text = NSMutableAttributedString(string: boardText)
    text.addAttributes(
      [.foregroundColor : UIColor.orange,
       .underlineStyle: NSUnderlineStyle.styleSingle.rawValue],
      range: (boardText as NSString).range(of: "Settings"))
    
//    let boardText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    let iconName = "check"
    
    var board = Onboard(attrTitle: text, iconName: iconName)
//    var board = Onboard(title: boardText, iconName: iconName)
    board.setTapAction { print("tapped on Onboard") }
    board.setAcceptAction { print("Accepted") }
    board.setDeniedAction { [unowned self] in
      print("Denied")
      TearOff(from: self, after: 0)
    }
    
    var style = InformStyle()
    style.font = UIFont(name: "American Typewriter", size: 16)
    style.border = 0
    style.declineIcon = UIImage(named: "white-crs")
    style.acceptIcon = UIImage(named: "white-chk")
    style.acceptBackgroundColor = UIColor(red: 0.28, green: 0.59, blue: 0.11, alpha: 1)
    style.declineBackgroundColor = UIColor(red: 0.85, green: 0.31, blue: 0.31, alpha: 1)
    
    Leaflet(.onboard(board, style), on: self)
  }
  
  @objc func onboardNoActionDidPress(sender: UIButton) {
    let boardText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    let iconName = "check"
    
    var board = Onboard(title: boardText, iconName: iconName)
    board.setTapAction { print("tapped on Onboard") }
    board.setDeniedAction { print("close") }
    
    var style = InformStyle()
    style.declineBackgroundColor = UIColor(red: 0.85, green: 0.31, blue: 0.31, alpha: 1)
    
    Leaflet(.onboard(board, style), on: self)  }
}
