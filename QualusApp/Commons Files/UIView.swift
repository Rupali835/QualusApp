//
//  UIView.swift
//  AllInOne
//
//  Created by Sneha on 05/04/18.
//  Copyright © 2018 Ecsion. All rights reserved.
//

//import Foundation
import UIKit

extension UIView {
  
  class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
    let className = String.className(viewType)
    return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
  }
  
  class func loadNib() -> Self {
    return loadNib(self)
  }
}
