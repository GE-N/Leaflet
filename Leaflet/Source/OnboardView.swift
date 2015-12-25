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

let onboardViewOffset = CGFloat(8)
let onboardViewHeight = CGFloat(70)
let onboardImageViewSize = CGSizeMake(20, 20)
let onboardButtonSize = CGSizeMake(44, 44)
let onboardCloseButtonSize = CGSizeMake(27, 27)
let onboardCloseButtonFrame = CGRectMake(
  screenWidth - onboardCloseButtonSize.width - onboardViewOffset,
  onboardViewOffset,
  onboardCloseButtonSize.width,
  onboardCloseButtonSize.height)

protocol OnboardViewDelegate {
  func dismissFromViewController() -> UIViewController
}

public class OnboardView: UIView {
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
    button.layer.cornerRadius = onboardCloseButtonSize.width / 2
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.whiteColor().CGColor
    
    return button
  }()
  
  lazy private(set) var transformViews: [UIView] =
  [self.textLabel, self.boardImageView, self.acceptButton, self.rejectButton, self.closeButton]
  
  var board: Board!
  var delegate: OnboardViewDelegate?
  var tapAction: UITapGestureRecognizer?
  
  init(board: Board) {
    super.init(frame: CGRectZero)
    self.board = board
    
    frame = CGRectMake(0, screenHeight, screenWidth, onboardViewHeight)
    backgroundColor = board.color
    
    transformViews.forEach { addSubview($0) }
    
    textLabel.text = board.text
    textLabel.sizeToFit()
    
    boardImageView.image = board.image
    
    acceptButton.addTarget(self, action: "performBoardAction:", forControlEvents: .TouchUpInside)
    rejectButton.addTarget(self, action: "performBoardAction:", forControlEvents: .TouchUpInside)
    closeButton.addTarget(self, action: "performBoardAction:", forControlEvents: .TouchUpInside)
    
    if board.tapAction != nil {
      tapAction = UITapGestureRecognizer(target: self, action: "onboardTapped:")
      self.addGestureRecognizer(tapAction!)
    }
    
    self.setupFrames()
  }

  func performBoardAction(sender: UIButton) {
    switch sender {
    case acceptButton:  board.acceptAction?()
    case rejectButton:  board.rejectAction?()
    case closeButton:   Clearboard((delegate?.dismissFromViewController())!)
    default: return
    }
  }
  
  func onboardTapped(sender: UITapGestureRecognizer) {
    board.tapAction?()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout

extension OnboardView {
  func setupFrames() {
    // TODO: Replace by autolayout.
    var labelOrigin = CGPointMake(onboardViewOffset, onboardViewOffset)
    var labelSize = CGSizeMake(screenWidth - (onboardViewOffset * 2), onboardViewHeight - (onboardViewOffset * 2))
    
    if board.image != nil {
      boardImageView.frame.origin = CGPointMake(onboardViewOffset, onboardViewOffset)
      boardImageView.frame.size = onboardImageViewSize
      
      let imageWidth = onboardImageViewSize.width + onboardViewOffset
      labelOrigin.x += imageWidth
      labelSize.width -= imageWidth
    }
    
    if board.isHaveOption() {
      if board.rejectAction != nil {
        let xPos = screenWidth - onboardViewOffset - onboardButtonSize.width
        let yPos = onboardViewOffset
        rejectButton.frame.origin = CGPointMake(xPos, yPos)
        rejectButton.frame.size = onboardButtonSize
        
        labelSize.width -= onboardButtonSize.width + onboardViewOffset
      }
      
      if board.acceptAction != nil {
        let xPos = CGRectGetMinX(rejectButton.frame) - onboardButtonSize.width + 1
        let yPos = onboardViewOffset
        acceptButton.frame.origin = CGPointMake(xPos, yPos)
        acceptButton.frame.size = onboardButtonSize
        
        labelSize.width -= onboardButtonSize.width + onboardViewOffset
      }
    } else {
      closeButton.frame = onboardCloseButtonFrame
      
      labelSize.width -= onboardCloseButtonSize.width + onboardViewOffset
    }
    
    if let labelHeight = textLabel.text?.heighWithConstrainedWidth(labelSize.width, font: textLabel.font) where labelHeight < onboardViewHeight {
      labelSize.height = labelHeight
    }
    textLabel.frame.origin = labelOrigin
    textLabel.frame.size = labelSize
  }
}