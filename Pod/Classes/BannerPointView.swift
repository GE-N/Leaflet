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

open class BannerPointView : UIView, LeafletItem {
  var stackView: UIStackView!
  var dimension = Dimension(space: 8, width: screenWidth, image: CGSize(width: 32, height: 32))
  
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    return formatter
  }()
  
  open lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  open lazy var textLabel: UICountingLabel = {
    let label = UICountingLabel()
    label.numberOfLines = 1
    label.method = .easeOut
    label.formatBlock = { value in
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      let number = NSNumber(value: Int(value))
      return formatter.string(from: number)
    }
    return label
  }()
  
  open lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    return label
  }()
  
  let bannerFont = UIFont.systemFont(ofSize: 13)
  

  lazy fileprivate(set) var transformViews: [UIView] = [self.textLabel, self.detailsLabel]
  
  var points: Int!
  var adder: Int!
  
  var delegate: BannerViewDelegate! {
    didSet { setupFrame() }
  }
  
  var details: PointUpdateBanner! {
    didSet {
      points = details.augend
      adder = details.adder
      textLabel.count(from: CGFloat(points), to: CGFloat(points), withDuration: 0)
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
    super.init(frame: CGRect.zero)
  }

  fileprivate func adderWithSigned(_ adder: Int) -> String {
    return adder >= 0 ? "+\(adder)" : "\(adder)"
  }
  
  fileprivate func initiateLabel(_ label: UILabel) {
    label.font = style?.font ?? bannerFont
    label.sizeToFit()
  }
  
  func beginAnimation() {
    gcdDelay(0.5){ [weak self] in
      if let point = self?.points,
        let adder = self?.adder {
        self?.textLabel.count(from: CGFloat(point), to: CGFloat(point + adder), withDuration: 1)
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout

extension BannerPointView {
  fileprivate func setupFrame() {
    transformViews.forEach { initiateLabel($0 as! UILabel) }
    
    frame = delegate.onViewController().view.frame
    frame.size.height = textLabel.frame.height + (dimension.offset * 2)
    
    var horizontalVisualFormat: String!
    if details.imageName != nil {
      imageView.frame.size = dimension.imageSize
      addSubview(imageView)
      horizontalVisualFormat = "H:|-offset-[icon]-offset-[details]-offset-|"
    } else {
      horizontalVisualFormat = "H:|-offset-[details]-offset-|"
    }
    
    stackView = UIStackView(arrangedSubviews: [textLabel, detailsLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = dimension.offset
    addSubview(stackView)
   
    let views: [String : AnyObject] = [
      "icon" : imageView,
      "details" : stackView
    ]
    
    let metric: [String: AnyObject] = [
      "offset" : dimension.offset as AnyObject
    ]
    
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: horizontalVisualFormat,
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: metric, views: views))
    
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[details]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: metric, views: views))
  }
  
  fileprivate func setupStyle() {
    backgroundColor     = style?.backgroundColor
    textLabel.font      = style?.font
    textLabel.textColor = style?.textColor
    detailsLabel.font   = style?.font
    detailsLabel.textColor = style?.textColor
  }
}
