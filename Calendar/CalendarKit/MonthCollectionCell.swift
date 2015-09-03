//
//  MonthCollectionCell.swift
//  Calendar
//
//  Created by Lancy on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

protocol MonthCollectionCellDelegate: class {
   func didSelect(date: Date)
}

class MonthCollectionCell: UICollectionViewCell {
   
   @IBOutlet var collectionView: UICollectionView!
   weak var monthCellDelgate: MonthCollectionCellDelegate?
   
   var markedViewColor: UIColor = UIColor.purpleColor()

   var dates = [Date]()
   var previousMonthVisibleDatesCount = 0
   var currentMonthVisibleDatesCount = 0
   var nextMonthVisibleDatesCount = 0
   
   var logic: CalendarLogic? {
      didSet {
         populateDates()
         collectionView.reloadData()
      }
   }
   
   var selectedDate: Date? {
      didSet {
         collectionView.reloadData()
      }
   }
   
   func populateDates() {
      if let
         logic = logic,
         prevMonthVisibleDays = logic.previousMonthVisibleDays,
         currentMonthDays = logic.currentMonthDays,
         nextMonthVisibleDays = logic.nextMonthVisibleDays
      {
         dates = [Date]()
         
         dates += prevMonthVisibleDays
         dates += currentMonthDays
         dates += nextMonthVisibleDays
         
         previousMonthVisibleDatesCount = prevMonthVisibleDays.count
         currentMonthVisibleDatesCount = currentMonthDays.count
         nextMonthVisibleDatesCount = nextMonthVisibleDays.count
      } else {
         dates.removeAll(keepCapacity: false)
      }
   }
}

extension MonthCollectionCell : UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let daysInAWeek = 7
      let maxWeeksInAMonth = 6
      
      let columns = daysInAWeek
      let rows = maxWeeksInAMonth

      return columns * rows
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCollectionCell", forIndexPath: indexPath) as! DayCollectionCell
      
      let date = dates[indexPath.item]
      
      cell.date = (indexPath.item < dates.count) ? date : nil
      cell.mark = (selectedDate == date)
      cell.markedViewColor = markedViewColor
      
      cell.disabled = (indexPath.item < previousMonthVisibleDatesCount) ||
         (indexPath.item >= previousMonthVisibleDatesCount
            + currentMonthVisibleDatesCount)
      
      return cell
   }
}

extension MonthCollectionCell : UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      if let monthCellDelgate = monthCellDelgate {
         monthCellDelgate.didSelect(dates[indexPath.item])
      }
   }
   
   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      return collectionView.dequeueReusableSupplementaryViewOfKind(
         UICollectionElementKindSectionHeader,
         withReuseIdentifier: "WeekHeaderView",
         forIndexPath: indexPath) 
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      //return CGSizeMake(collectionView.frame.width/7.0, collectionView.frame.height/7.0)
      return CGSizeMake(floor(collectionView.frame.width/7.0), floor(collectionView.frame.height/7.0))
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSizeMake(collectionView.frame.width, floor(collectionView.frame.height/7.0))
   }
}
