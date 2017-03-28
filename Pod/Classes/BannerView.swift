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

open class BannerView : UIView, LeafletItem {
  var dimension = Dimension(space: 8, width: screenWidth, image: CGSize(width: 12, height: 12))
  
  open lazy var textLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  open lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  var bannerFont: UIFont = UIFont.systemFont(ofSize: 13)
  
  lazy fileprivate(set) var transformViews: [UIView] = [self.textLabel, self.imageView]
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
    super.init(frame: CGRect.zero)
    textLabel.font = bannerFont
    transformViews.forEach { addSubview($0) }
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BannerView {
  func setupFrame() {
    var labelFrame = CGRect(x: dimension.offset, y: dimension.offset,
      width: delegate.onViewController().view.frame.width - (dimension.offset * 2), height: 0)
    
    if details.imageName != nil {
      imageView.frame = CGRect(x: dimension.offset, y: dimension.offset, width: 0, height: 0)
      imageView.frame.size = dimension.imageSize
      imageView.image = UIImage(named: details.imageName!)
      
      labelFrame.origin.x = imageView.frame.maxX + dimension.offset
      labelFrame.size.width -= imageView.frame.width + dimension.offset
    }
    
    let textHeight = textLabelHeight(labelFrame.size.width)
    labelFrame.size.height = textHeight
    textLabel.frame = labelFrame
    
    frame = delegate.onViewController().view.frame
    frame.size.height = textHeight + (dimension.offset * 2)
    
    if textLabel.textAlignment == .center {
      textLabel.sizeToFit()
      textLabel.center = center
      
      if details.imageName != nil {
        textLabel.center.x += dimension.imageSize.width + dimension.offset
        imageView.frame.origin.x = textLabel.frame.minX - dimension.imageSize.width - dimension.offset
      }
    }
  }
  
  fileprivate func textLabelHeight(_ width: CGFloat) -> CGFloat {
    return details.title.heighWithConstrainedWidth(width, font: bannerFont)
  }
}

extension BannerView {
  func setupStyle() {
    backgroundColor         = style?.backgroundColor
    textLabel.textAlignment = style?.alignment ?? .left
    textLabel.font          = style?.font
    textLabel.textColor     = style?.textColor
    bannerFont              = style?.font ?? UIFont.systemFont(ofSize: 13)
  }
}

// Interact
extension BannerView {
  func setupInteract() {
    if interact?.canSwipeUpForDismiss == true {
      let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(BannerView.performSwipeUp(_:)))
      swipeUp.direction = .up
      addGestureRecognizer(swipeUp)
    }
    
    if interact?.tapAction != nil {
      let tap = UITapGestureRecognizer(target: self, action: #selector(BannerView.performTap(_:)))
      addGestureRecognizer(tap)
    }
  }
  
  func performSwipeUp(_ gesture: UISwipeGestureRecognizer) {
    TearOff(from: delegate.onViewController())
  }
  
  func performTap(_ gesture: UITapGestureRecognizer) {
    interact?.tapAction?()
  }
}
