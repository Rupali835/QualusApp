//
//  UIViewController.swift
//  AllInOne
//
//  Created by Sneha on 05/04/18.
//  Copyright © 2018 Ecsion. All rights reserved.
//

//import Foundation
import UIKit

extension UIViewController {
  class func loadNib<T: UIViewController>(_ viewType: T.Type) -> T {
    let className = String.className(viewType)
    return T(nibName: className, bundle: nil)
  }
  
  class func loadNib() -> Self {
    return loadNib(self)
  }
  
   
  
  func showAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

