//
//  OnboardView.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/21/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit
import SnapKit

let screenBound = UIScreen.main.bounds
let screenWidth = screenBound.width
let screenHeight = screenBound.height

let onboardViewHeight = CGFloat(70)
let onboardButtonSize = CGSize(width: 46, height: 70)
let onboardCloseButtonSize = CGSize(width: 46, height: 70)
let onboardCloseButtonFrame = CGRect(
  x: screenWidth - onboardCloseButtonSize.width, y: 0,
  width: onboardCloseButtonSize.width, height: onboardCloseButtonSize.height)

public protocol OnboardViewDelegate {
  func dismissFromViewController() -> UIViewController
}

public protocol OnboardBanner {
  var title: NSAttributedString! { get }
  var iconName: String? { get }
  var tapAction: (() -> Void)? { get }
  var acceptAction: (() -> Void)? { get }
  var deniedAction: (() -> Void)? { get }
  var presentation: LeafletPresentation! { get }
}

open class OnboardView: UIView, LeafletItem {
  var dimension = Dimension(space: CGFloat(8), width: screenWidth, image: CGSize(width: 20, height: 20))
  
  open lazy var textLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.textColor = UIColor.black
    label.numberOfLines = 3
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    label.font = UIFont(name: "HelveticaNeue", size: 13)

    return label
  }()
  
  open lazy var boardImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  open lazy var acceptButton: UIButton = {
    let button = UIButton()
    button.setTitle("✔︎", for: UIControlState())
    button.setTitleColor(UIColor.darkGray, for: UIControlState())
    button.layer.borderColor = UIColor(red:0.74, green:0.76, blue:0.76, alpha:1).cgColor
    button.layer.borderWidth = 1

    return button
  }()
  
  open lazy var rejectButton: UIButton = {
    let button = UIButton()
    button.setTitle("✘", for: UIControlState())
    button.setTitleColor(UIColor.darkGray, for: UIControlState())
    button.layer.borderColor = UIColor(red:0.74, green:0.76, blue:0.76, alpha:1).cgColor
    button.layer.borderWidth = 1
    
    return button
  }()
  
  open lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("✕", for: UIControlState())
    button.setTitleColor(UIColor.white, for: UIControlState())
    button.backgroundColor = UIColor.black
    
    return button
  }()
  
  lazy fileprivate(set) var transformViews: [UIView] =
  [self.textLabel, self.boardImageView, self.acceptButton, self.rejectButton, self.closeButton]
  
  var delegate: BannerViewDelegate! {
    didSet { setupFrames() }
  }
  
  var details: OnboardBanner! {
    didSet {
      textLabel.attributedText = details.title
      textLabel.sizeToFit()
      
      if let detailsIcon = details.iconName {
        boardImageView.image = UIImage(named: detailsIcon)
      }
      
      acceptButton.addTarget(self, action: #selector(performBoardAction(_:)), for: .touchUpInside)
      rejectButton.addTarget(self, action: #selector(performBoardAction(_:)), for: .touchUpInside)
      closeButton.addTarget(self, action: #selector(performBoardAction(_:)), for: .touchUpInside)
      
      if details.tapAction != nil {
        tapAction = UITapGestureRecognizer(target: self, action: #selector(onboardTapped(_:)))
        addGestureRecognizer(tapAction!)
      }
      
      setupFrames()
    }
  }
  
  var style: LeafletStyle? {
    didSet {
      backgroundColor = style?.backgroundColor
      textLabel.font = style?.font
      // Disabled style on text for reason its overriden attributed string color.
      // textLabel.textColor = style?.textColor
            
      // Style is conformed to Generic Banner
      if let genericStyle = style as? GenericStyle {
        if let acceptIcon = genericStyle.acceptIcon {
          acceptButton.setTitle(nil, for: UIControlState())
          acceptButton.setImage(acceptIcon, for: UIControlState())
        }
        
        if let acceptBGColor = genericStyle.acceptBackgroundColor {
          acceptButton.setBackgroundImage(bgColorImage(acceptBGColor), for: UIControlState())
        }
        
        if let declineIcon = genericStyle.declineIcon {
          rejectButton.setTitle(nil, for: UIControlState())
          rejectButton.setImage(declineIcon, for: UIControlState())
        }
        
        if let declineBGColor = genericStyle.declineBackgroundColor {
          rejectButton.setBackgroundImage(bgColorImage(declineBGColor), for: UIControlState())
          closeButton.setBackgroundImage(bgColorImage(declineBGColor), for: UIControlState())
        }
        
        if let borderWidth = genericStyle.border {
          acceptButton.layer.borderWidth = borderWidth
          rejectButton.layer.borderWidth = borderWidth
        }
      }
    }
  }
  
  // Create 1px image from quartz, inspired from
  // http://stackoverflow.com/questions/9151379/is-it-possible-to-use-quartz-2d-to-make-a-uiimage-on-another-thread
  func bgColorImage(_ color: UIColor) -> UIImage {
    let size = CGSize(width: 1, height: 1)
    let opaque = false
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    color.setFill()
    UIRectFill(CGRect(origin: CGPoint.zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
  }
  
  var tapAction: UITapGestureRecognizer?
  
  init() {
    super.init(frame: CGRect.zero)
    transformViews.forEach { addSubview($0) }
  }

  @objc func performBoardAction(_ sender: UIButton) {
    switch sender {
    case acceptButton:  details.acceptAction?()
    case rejectButton:  details.deniedAction?()
    case closeButton:
      details.deniedAction?()
      TearOff(from: delegate.onViewController(), after: 0)
    default: return
    }
  }
  
  @objc func onboardTapped(_ sender: UITapGestureRecognizer) {
    details.tapAction?()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout

extension OnboardView {
  func setupFrames() {
    frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: onboardViewHeight)
    var leftMostView: UIView? = nil
    var rightMostView: UIView? = nil
    
    if details.iconName != nil {
      boardImageView.snp.makeConstraints {
        $0.centerY.equalTo(self.snp.centerY)
        $0.left.equalTo(dimension.offset)
        $0.size.equalTo(dimension.imageSize)
      }
      
      leftMostView = boardImageView
    }
    
    if isHaveOption() {
      if details.deniedAction != nil {
        rejectButton.snp.makeConstraints {
          $0.size.equalTo(onboardButtonSize)
          $0.right.equalTo(0)
          $0.top.equalTo(0)
        }
        
        rightMostView = rejectButton
      }
      
      if details.acceptAction != nil {
        acceptButton.snp.makeConstraints {
          $0.size.equalTo(onboardButtonSize)
          $0.right.equalTo(rejectButton.snp.left)
          $0.top.equalTo(rejectButton.snp.top)
        }
        
        rightMostView = acceptButton
      }
    } else {
      closeButton.snp.makeConstraints {
        $0.size.equalTo(onboardButtonSize)
        $0.right.equalTo(0)
        $0.top.equalTo(0)
      }
      
      rightMostView = closeButton
    }
    
    textLabel.snp.makeConstraints {
      $0.top.equalTo(dimension.offset)
      $0.left.equalTo(leftMostView?.snp.right ?? self).offset(8)
      $0.right.equalTo(rightMostView?.snp.left ?? self).offset(-8)
      $0.bottom.equalTo(-dimension.offset)
    }
  }
  
  fileprivate func isHaveOption() -> Bool {
    return details.acceptAction != nil && details.deniedAction != nil
  }
}
