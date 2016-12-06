//
//  OnboardView.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/21/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

let screenBound = UIScreen.mainScreen().bounds
let screenWidth = CGRectGetWidth(screenBound)
let screenHeight = CGRectGetHeight(screenBound)

let onboardViewHeight = CGFloat(70)
let onboardButtonSize = CGSizeMake(46, 70)
let onboardCloseButtonSize = CGSizeMake(46, 70)
let onboardCloseButtonFrame = CGRectMake(
  screenWidth - onboardCloseButtonSize.width, 0,
  onboardCloseButtonSize.width, onboardCloseButtonSize.height)

public protocol OnboardViewDelegate {
  func dismissFromViewController() -> UIViewController
}

public protocol OnboardBanner {
  var title: NSAttributedString! { get }
  var iconName: String? { get }
  var tapAction: (Void -> ())? { get }
  var acceptAction: (Void -> ())? { get }
  var deniedAction: (Void -> ())? { get }
  var presentation: LeafletPresentation! { get }
}

public class OnboardView: UIView, LeafletItem {
  var dimension = Dimension(space: CGFloat(8), width: screenWidth, image: CGSizeMake(20, 20))
  
  public lazy var textLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Left
    label.textColor = UIColor.blackColor()
    label.numberOfLines = 3
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 30
    label.frame.size.height = onboardViewHeight

    return label
  }()
  
  public lazy var boardImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    
    return imageView
  }()
  
  public lazy var acceptButton: UIButton = {
    let button = UIButton()
    button.setTitle("✔︎", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor(red:0.74, green:0.76, blue:0.76, alpha:1).CGColor
    button.layer.borderWidth = 1

    return button
  }()
  
  public lazy var rejectButton: UIButton = {
    let button = UIButton()
    button.setTitle("✘", forState: .Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    button.layer.borderColor = UIColor(red:0.74, green:0.76, blue:0.76, alpha:1).CGColor
    button.layer.borderWidth = 1
    
    return button
  }()
  
  public lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("✕", forState: .Normal)
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.backgroundColor = UIColor.blackColor()
    
    return button
  }()
  
  lazy private(set) var transformViews: [UIView] =
  [self.textLabel, self.boardImageView, self.acceptButton, self.rejectButton, self.closeButton]
  
  var delegate: BannerViewDelegate! {
    didSet { setupFrames() }
  }
  
  var details: OnboardBanner! {
    didSet {
      textLabel.attributedText = details.title
      textLabel.sizeToFit()
      
      if details.iconName != nil {
        boardImageView.image = UIImage(named: details.iconName!)
      }
      
      acceptButton.addTarget(self, action: #selector(OnboardView.performBoardAction(_:)), forControlEvents: .TouchUpInside)
      rejectButton.addTarget(self, action: #selector(OnboardView.performBoardAction(_:)), forControlEvents: .TouchUpInside)
      closeButton.addTarget(self, action: #selector(OnboardView.performBoardAction(_:)), forControlEvents: .TouchUpInside)
      
      if details.tapAction != nil {
        tapAction = UITapGestureRecognizer(target: self, action: #selector(OnboardView.onboardTapped(_:)))
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
          acceptButton.setTitle(nil, forState: .Normal)
          acceptButton.setImage(acceptIcon, forState: .Normal)
        }
        
        if let acceptBGColor = genericStyle.acceptBackgroundColor {
          acceptButton.setBackgroundImage(bgColorImage(acceptBGColor), forState: .Normal)
        }
        
        if let declineIcon = genericStyle.declineIcon {
          rejectButton.setTitle(nil, forState: .Normal)
          rejectButton.setImage(declineIcon, forState: .Normal)
        }
        
        if let declineBGColor = genericStyle.declineBackgroundColor {
          rejectButton.setBackgroundImage(bgColorImage(declineBGColor), forState: .Normal)
          closeButton.setBackgroundImage(bgColorImage(declineBGColor), forState: .Normal)
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
  func bgColorImage(color: UIColor) -> UIImage {
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
    super.init(frame: CGRectZero)
    transformViews.forEach { addSubview($0) }
  }

  func performBoardAction(sender: UIButton) {
    switch sender {
    case acceptButton:  details.acceptAction?()
    case rejectButton:  details.deniedAction?()
    case closeButton:
      details.deniedAction?()
      TearOff(from: delegate.onViewController(), after: 0)
    default: return
    }
  }
  
  func onboardTapped(sender: UITapGestureRecognizer) {
    details.tapAction?()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout

extension OnboardView {
  func setupFrames() {
    // TODO: Replace by autolayout.
    frame = CGRectMake(0, screenHeight, screenWidth, onboardViewHeight)
    var labelOrigin = CGPointMake(dimension.offset, dimension.offset)
    var labelSize = CGSizeMake(screenWidth - (dimension.offset * 2), onboardViewHeight - (dimension.offset * 2))
    
    if details.iconName != nil {
      boardImageView.frame.origin = CGPointMake(dimension.offset, dimension.offset)
      boardImageView.frame.size = dimension.imageSize
      
      let imageWidth = dimension.imageSize.width + dimension.offset
      labelOrigin.x += imageWidth
      labelSize.width -= imageWidth
    }
    
    if isHaveOption() {
      if details.deniedAction != nil {
        let xPos = screenWidth - onboardButtonSize.width
        let yPos = CGFloat(0)
        rejectButton.frame.origin = CGPointMake(xPos, yPos)
        rejectButton.frame.size = onboardButtonSize
        
        labelSize.width -= onboardButtonSize.width
      }
      
      if details.acceptAction != nil {
        let xPos = CGRectGetMinX(rejectButton.frame) - onboardButtonSize.width + 1
        let yPos = CGFloat(0)
        acceptButton.frame.origin = CGPointMake(xPos, yPos)
        acceptButton.frame.size = onboardButtonSize
        
        labelSize.width -= onboardButtonSize.width
      }
    } else {
      closeButton.frame = onboardCloseButtonFrame
      
      labelSize.width -= onboardCloseButtonSize.width + dimension.offset
    }
    
    if let labelHeight = textLabel.text?.heighWithConstrainedWidth(labelSize.width, font: textLabel.font) where labelHeight < onboardViewHeight {
      labelSize.height = labelHeight
    }
    textLabel.frame.origin = labelOrigin
    textLabel.frame.size = labelSize
  }
  
  private func isHaveOption() -> Bool {
    return details.acceptAction != nil && details.deniedAction != nil
  }
}
