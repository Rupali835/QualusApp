//
//  AuditordetailsCollectionViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class AuditordetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblActualQuantity: UILabel!
    
    @IBOutlet weak var lblExceptedQuantity: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.applyShadowAndRadiustoView()


    }

}
