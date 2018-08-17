//
//  gradient.swift
//  gradients
//
//  Created by Prajakta Bagade on 6/12/18.
//  Copyright © 2018 Prajakta Bagade. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class gradient: UIView
{
    @IBInspectable var firstcolour : UIColor = UIColor.clear
    {
        didSet
            {
                updateView()
            }
            
    }
   
    @IBInspectable var secondColour : UIColor = UIColor.clear
    {
            didSet
            {
                updateView()
            }
    }
    
    @IBInspectable var ThirdColour : UIColor = UIColor.clear
    {
            didSet
        {
            updateView()
        }
        
    }
    
    override class var layerClass: AnyClass
    {
        get{
            return CAGradientLayer.self
            }
        
        
    }
    func updateView ()
    {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstcolour.cgColor,secondColour.cgColor,ThirdColour.cgColor]
    }
    
    
    
    
    
    
    
    
}
