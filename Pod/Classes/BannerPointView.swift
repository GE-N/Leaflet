//
//  BannerPointView.swift
//  WhisperDemo
//
//  Created by Jerapong Nampetch on 12/24/2558 BE.
//  Copyright © 2558 Gomeeki. All rights reserved.
//

import UIKit
import TZStackView

public protocol PointUpdateBanner : GenericBanner {
  var augend: Int { get }
  var adder: Int { get }
}

public class BannerPointView : UIView, LeafletItem {
  var stackView: TZStackView!
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
    
    frame = delegate.onViewController().view.frame
    frame.size.height = CGRectGetHeight(textLabel.frame) + (dimension.offset * 2)
    
    var horizontalVisualFormat: String!
    if details.imageName != nil {
      imageView.frame.size = dimension.imageSize
      addSubview(imageView)
      horizontalVisualFormat = "H:|-offset-[icon]-offset-[details]-offset-|"
    } else {
      horizontalVisualFormat = "H:|-offset-[details]-offset-|"
    }
    
    stackView = TZStackView(arrangedSubviews: [textLabel, detailsLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .Horizontal
    stackView.distribution = .Fill
    stackView.alignment = .Fill
    stackView.spacing = dimension.offset
    addSubview(stackView)
   
    let views: [String : AnyObject] = [
      "icon" : imageView,
      "details" : stackView
    ]
    
    let metric: [String: AnyObject] = [
      "offset" : dimension.offset
    ]
    
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      horizontalVisualFormat,
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: metric, views: views))
    
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[details]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: metric, views: views))
  }
  
  private func setupStyle() {
    backgroundColor     = style?.backgroundColor
    textLabel.font      = style?.font
    textLabel.textColor = style?.textColor
    detailsLabel.font   = style?.font
    detailsLabel.textColor = style?.textColor
  }
}