//
//  UICollectionView.swift
//  AllInOne
//
//  Created by Sneha on 09/04/18.
//  Copyright © 2018 Ecsion. All rights reserved.
//

//import Foundation
import UIKit

extension UICollectionView {
  
  func registerCellNib(_ cellClass: AnyClass) {
    let identifier = String.className(cellClass)
    let nib = UINib(nibName: identifier, bundle: nil)
    self.register(nib, forCellWithReuseIdentifier: identifier)
  }
  
  func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
    let identifier = String.className(viewClass)
    self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
  }
  
  func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
    let identifier = String.className(viewClass)
    let nib = UINib(nibName: identifier, bundle: nil)
    self.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
  }
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x: contentOffset, y: self.contentOffset.y , width: self.frame.width, height: self.frame.height)
        self.scrollRectToVisible(frame, animated: true)
    }
    
}
