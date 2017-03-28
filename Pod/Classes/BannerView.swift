//
//  BannerView.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/23/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

protocol BannerViewDelegate {
  func onViewController() -> UIViewController
}

public protocol GenericBanner {
  var title: String { get }
  var imageName: String? { get }
  var presentation: LeafletPresentation! { get }
}

public protocol GenericInteract {
  var canSwipeUpForDismiss: Bool { get }
  var tapAction: (() -> Void)? { get }
}

public class BannerView : UIView, LeafletItem {
  var dimension = Dimension(space: 8, width: screenWidth, image: CGSizeMake(12, 12))
  
  public lazy var textLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  public lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    return imageView
  }()
  
  var bannerFont: UIFont = UIFont.systemFontOfSize(13)
  
  lazy private(set) var transformViews: [UIView] = [self.textLabel, self.imageView]
  var delegate: BannerViewDelegate! {
    didSet { self.setupFrame() }
  }
  
  var details: GenericBanner! {
    didSet {
      self.textLabel.text = details.title
      guard details.imageName != nil else { return }
      self.imageView.image = UIImage(named: details.imageName!)
    }
  }
  
  var style: LeafletStyle? {
    didSet { self.setupStyle() }
  }
  
  var interact: GenericInteract? {
    didSet { self.setupInteract() }
  }
  
  init() {
    super.init(frame: CGRectZero)
    textLabel.font = bannerFont
    transformViews.forEach { addSubview($0) }
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BannerView {
  func setupFrame() {
    var labelFrame = CGRectMake(dimension.offset, dimension.offset,
      CGRectGetWidth(delegate.onViewController().view.frame) - (dimension.offset * 2), 0)
    
    if details.imageName != nil {
      imageView.frame = CGRectMake(dimension.offset, dimension.offset, 0, 0)
      imageView.frame.size = dimension.imageSize
      imageView.image = UIImage(named: details.imageName!)
      
      labelFrame.origin.x = CGRectGetMaxX(imageView.frame) + dimension.offset
      labelFrame.size.width -= CGRectGetWidth(imageView.frame) + dimension.offset
    }
    
    let textHeight = textLabelHeight(labelFrame.size.width)
    labelFrame.size.height = textHeight
    textLabel.frame = labelFrame
    
    frame = delegate.onViewController().view.frame
    frame.size.height = textHeight + (dimension.offset * 2)
    
    if textLabel.textAlignment == .Center {
      textLabel.sizeToFit()
      textLabel.center = center
      
      if details.imageName != nil {
        textLabel.center.x += dimension.imageSize.width + dimension.offset
        imageView.frame.origin.x = CGRectGetMinX(textLabel.frame) - dimension.imageSize.width - dimension.offset
      }
    }
  }
  
  private func textLabelHeight(width: CGFloat) -> CGFloat {
    return details.title.heighWithConstrainedWidth(width, font: bannerFont)
  }
}

extension BannerView {
  func setupStyle() {
    backgroundColor         = style?.backgroundColor
    textLabel.textAlignment = style?.alignment ?? .Left
    textLabel.font          = style?.font
    textLabel.textColor     = style?.textColor
    bannerFont              = style?.font ?? UIFont.systemFontOfSize(13)
  }
}

// Interact
extension BannerView {
  func setupInteract() {
    if interact?.canSwipeUpForDismiss == true {
      let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(BannerView.performSwipeUp(_:)))
      swipeUp.direction = .Up
      addGestureRecognizer(swipeUp)
    }
    
    if interact?.tapAction != nil {
      let tap = UITapGestureRecognizer(target: self, action: #selector(BannerView.performTap(_:)))
      addGestureRecognizer(tap)
    }
  }
  
  func performSwipeUp(gesture: UISwipeGestureRecognizer) {
    TearOff(from: delegate.onViewController())
  }
  
  func performTap(gesture: UITapGestureRecognizer) {
    interact?.tapAction?()
  }
}
