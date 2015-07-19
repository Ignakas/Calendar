//
//  CalendarViewController.swift
//  Pods
//
//  Created by Paul Wadsworth on 09/07/2015.
//
//

import UIKit

let kMonthRange = 12 // baseDate +/- 12 months 

public protocol CalendarViewDelegate: class {
   func didSelectDate(date: NSDate)
}

public class CalendarViewController : UIViewController {
   // MARK: Outlets
   @IBOutlet weak var collectionView: UICollectionView!

   @IBOutlet var monthYearLabel: UILabel!
   @IBOutlet var nextButton: UIButton!
   @IBOutlet var previousButton: UIButton!
   
   // MARK: Public
   public weak var delegate: CalendarViewDelegate?
   private var collectionData = [CalendarLogic]()
   public var baseDate: NSDate? {
      didSet {
         collectionData = [CalendarLogic]()
         if let baseDate = baseDate {
            var dateIter1 = baseDate, dateIter2 = baseDate
            var set = Set<CalendarLogic>()
            set.insert(CalendarLogic(date: baseDate))
            // advance one year in either direction
            for var i = 0; i < kMonthRange; i++ {
               dateIter1 = dateIter1.firstDayOfFollowingMonth
               dateIter2 = dateIter2.firstDayOfPreviousMonth
               
               set.insert(CalendarLogic(date: dateIter1))
               set.insert(CalendarLogic(date: dateIter2))
            }
            collectionData = sorted(Array(set), <)
         }
         
         updateHeader()
         collectionView.reloadData()
      }
   }
   
   public var selectedDate: NSDate? {
      didSet {
         collectionView.reloadData()
         let delegate = self.delegate // Use delegate value before dispatch (so we can set selectedDate to a new value and then set the delegate without the delegate firing)
         dispatch_async(dispatch_get_main_queue()){
            self.moveToSelectedDate(false)
            delegate?.didSelectDate(self.selectedDate!)
         }
      }
   }
   
   // MARK: LifeCycle
   public override func viewDidLoad() {
   }
   
   // MARK: Actions
   @IBAction func retreatToPreviousMonth(button: UIButton) {
      advance(-1, animate: true)
   }
   
   @IBAction func advanceToFollowingMonth(button: UIButton) {
      advance(1, animate: true)
   }
   
   // MARK: Layout
   public override func viewDidLayoutSubviews() {
      collectionView.collectionViewLayout.invalidateLayout()
   }
   
   // MARK: Private
   private func updateHeader() {
      let pageNumber = Int(collectionView.contentOffset.x / collectionView.frame.width)
      updateHeader(pageNumber)
   }
   
   private func updateHeader(pageNumber: Int) {
      if collectionData.count > pageNumber {
         let logic = collectionData[pageNumber]
         monthYearLabel.text = logic.currentMonthAndYear as String
      }
   }
   
   private func moveToSelectedDate(animated: Bool) {
      var index: Int?
      for var i = 0; i < collectionData.count; i++  {
         let logic = collectionData[i]
         if logic.containsDate(selectedDate!) {
            index = i
            break
         }
      }
      
      if let index = index {
         let indexPath = NSIndexPath(forItem: index, inSection: 0)
         updateHeader(indexPath.item)
         collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
         //collectionView.reloadItemsAtIndexPaths([indexPath])
      }
   }
   
   private func advance(byIndex: Int, animate: Bool) {
      var visibleIndexPath = self.collectionView.indexPathsForVisibleItems().first as! NSIndexPath
      
      if (visibleIndexPath.item == 0 && byIndex == -1) ||
         ((visibleIndexPath.item + 1) == collectionView.numberOfItemsInSection(0) && byIndex == 1) {
            return
      }
      
      visibleIndexPath = NSIndexPath(forItem: visibleIndexPath.item + byIndex, inSection: visibleIndexPath.section)
      updateHeader(visibleIndexPath.item)
      collectionView.scrollToItemAtIndexPath(visibleIndexPath, atScrollPosition: .CenteredHorizontally, animated: animate)
   }

}

extension CalendarViewController : UICollectionViewDataSource {
   
   public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return collectionData.count
   }
   
   public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCollectionCell", forIndexPath: indexPath) as! MonthCollectionCell
      
      cell.monthCellDelgate = self
      
      cell.logic = collectionData[indexPath.item]
      if cell.logic!.isVisible(selectedDate!) {
         cell.selectedDate = Date(date: selectedDate!)
      }
      
      return cell
   }
   
   public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return collectionView.frame.size
   }
}

extension CalendarViewController : UIScrollViewDelegate {
   public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if (!decelerate) {
         updateHeader()
      }
   }
   
   public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
      updateHeader()
   }
}

extension CalendarViewController : MonthCollectionCellDelegate {
   func didSelect(date: Date) {
      selectedDate = date.nsdate
   }   
}