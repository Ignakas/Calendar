//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
   
   @IBOutlet var label: UILabel!
   
   @IBOutlet var markedView: UIView!
   @IBOutlet var markedViewWidth: NSLayoutConstraint!
   @IBOutlet var markedViewHeight: NSLayoutConstraint!

   var markedViewColor: UIColor = UIColor.purpleColor()
   
   var date: Date? {
      didSet {
         if date != nil {
            label.text = "\(date!.day)"
         } else {
            label.text = ""
         }
      }
   }
   
   var disabled: Bool = false {
      didSet {
         if disabled {
            alpha = 0.4
         } else {
            alpha = 1.0
         }
      }
   }
   
   var mark: Bool = false {
      didSet {
         if mark {
            markedView!.hidden = false
         } else {
            markedView!.hidden = true
         }
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()

      configMark()
   }

   private func configMark() {
      markedView.backgroundColor = markedViewColor

      let diameter = min(frame.width, frame.height)
      let radius = diameter / 2
      
      markedViewWidth!.constant = diameter
      markedViewHeight!.constant = diameter
      
      markedView!.layer.cornerRadius = radius
      markedView.center = CGPoint(x: frame.width/2, y: frame.height/2)
   }
}
