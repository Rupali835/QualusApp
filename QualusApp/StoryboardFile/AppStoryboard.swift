//
//  AppStoryboard.swift
//  RealUs
//
//  Created by Nishikant Ashok UMBARKAR on 14/3/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Main, SuperAdmin
    
    var instance : UIStoryboard {
        print(self.rawValue)
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

extension UIViewController
{
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    
}



