//
//  UIView+Shadow.swift
//
//  Copyright © 2018 GeNextStudents. All rights reserved.
//

import UIKit


extension UIView{
    
    func applyShadowAndRadiustoView() -> Void {
        self.layer.cornerRadius = 4
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.5
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeShadowtoView() {
        
        self.layer.shadowColor = nil
        self.layer.shadowOpacity = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.borderColor = nil
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = true
    }
    
    func applyLeftRadiustoView()  {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
    }
    
    func designCell(cView : UIView)
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        
    }
    
}



