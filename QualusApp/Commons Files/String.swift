//
//  String.swift
//  AllInOne
//
//  Created by Sneha on 05/04/18.
//  Copyright © 2018 Ecsion. All rights reserved.
//

import Foundation

extension String {
  
  static func className(_ aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).components(separatedBy: ".").last!
  }
  
  var length: Int {
    return self.count
  }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
    
    
}



