//
//  getTicketCollectionViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class getTicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblObservations: UILabel!
    @IBOutlet weak var lblproject1: UILabel!
    @IBOutlet weak var lblticketnoandStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.applyShadowAndRadiustoView()

    }
    
    
}
