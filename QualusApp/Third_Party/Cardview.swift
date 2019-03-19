//
//  Cardview.swift
//  medocpatient
//
//  Created by iAM on 17/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class Cardview: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowPath = shadowPath.cgPath
        layer.masksToBounds = false
    }

//    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//    self.layer.shadowOffset = CGSize(width: 0, height: 3)
//    self.layer.shadowOpacity = 1.0
//    self.layer.shadowRadius = 10.0
//    self.layer.masksToBounds = false
    
    
}
