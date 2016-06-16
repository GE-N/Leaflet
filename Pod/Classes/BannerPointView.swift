//
//  BannerPointView.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/24/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit

public protocol PointUpdateBanner : GenericBanner {
  var augend: Int { get }
  var adder: Int { get }
}

public class BannerPointView : UIView, LeafletItem {
  var dimension = Dimension(space: 8, width: screenWidth, image: CGSizeMake(32, 32))
  
  let numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    
    return formatter
  }()
  
  public lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    return imageView
  }()
  
  public lazy var textLabel: UICountingLabel = {
    let label = UICountingLabel()
    label.numberOfLines = 1
    label.method = .EaseOut
    label.formatBlock = { value in
      let formatter = NSNumberFormatter()
      formatter.numberStyle = .DecimalStyle
      return formatter.stringFromNumber(Int(value))
    }
    return label
  }()
  
  public lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    return label
  }()
  
  let bannerFont = UIFont.systemFontOfSize(13)
  

  lazy private(set) var transformViews: [UIView] = [self.textLabel, self.detailsLabel]
  
  var points: Int!
  var adder: Int!
  
  var delegate: BannerViewDelegate! {
    didSet { setupFrame() }
  }
  
  var details: PointUpdateBanner! {
    didSet {
      points = details.augend
      adder = details.adder
      textLabel.countFrom(CGFloat(points), to: CGFloat(points), withDuration: 0)
      detailsLabel.text = "\(adderWithSigned(adder)) : \(details.title)"
      if details.imageName != nil {
        imageView.image = UIImage(named: details.imageName!)
      }
    }
  }
  
  var style: LeafletStyle? {
    didSet { setupStyle() }
  }
  
  init() {
    super.init(frame: CGRectZero)
    transformViews.forEach { addSubview($0) }
  }

  private func adderWithSigned(adder: Int) -> String {
    return adder >= 0 ? "+\(adder)" : "\(adder)"
  }
  
  private func initiateLabel(label: UILabel) {
    label.font = style?.font ?? bannerFont
    label.sizeToFit()
  }
  
  func beginAnimation() {
    gcdDelay(0.5){ [weak self] in
      if let point = self?.points,
        let adder = self?.adder {
        self?.textLabel.countFrom(CGFloat(point), to: CGFloat(point + adder), withDuration: 1)
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout

extension BannerPointView {
  private func setupFrame() {
    transformViews.forEach { initiateLabel($0 as! UILabel) }
    textLabel.frame.origin = CGPointMake(dimension.offset, dimension.offset)
    detailsLabel.frame.origin.x = screenWidth - dimension.offset - CGRectGetWidth(detailsLabel.frame)
    detailsLabel.frame.origin.y = dimension.offset
    
    textLabel.frame.size.width = screenWidth - CGRectGetMinX(detailsLabel.frame) - (dimension.offset * 2)
    
    if details.imageName != nil {
      addSubview(imageView)
      imageView.frame.origin = CGPointMake(dimension.offset, 0)
      imageView.frame.size = dimension.imageSize
      
      let widthForImageView = dimension.imageSize.width + dimension.offset
      textLabel.frame.origin.x += widthForImageView
      textLabel.frame.size.width -= widthForImageView
    }
    
    frame = delegate.onViewController().view.frame
    frame.size.height = CGRectGetHeight(textLabel.frame) + (dimension.offset * 2)
  }
  
  private func setupStyle() {
    backgroundColor     = style?.backgroundColor
    textLabel.font      = style?.font
    textLabel.textColor = style?.textColor
    detailsLabel.font   = style?.font
    detailsLabel.textColor = style?.textColor
  }
}