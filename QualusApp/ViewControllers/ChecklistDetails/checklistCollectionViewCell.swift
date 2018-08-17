//
//  checklistCollectionViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/26/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData

class checklistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var projName: UILabel!
    @IBOutlet weak var checklistName: UILabel!
    @IBOutlet weak var locName: UILabel!
    @IBOutlet weak var generatedby: UILabel!
    @IBOutlet weak var lblpercentage: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.applyShadowAndRadiustoView()
    }
    
}
    


