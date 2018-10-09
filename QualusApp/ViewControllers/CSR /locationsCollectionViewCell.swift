//
//  locationsCollectionViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class locationsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.darkGray.cgColor
        
    }

}
