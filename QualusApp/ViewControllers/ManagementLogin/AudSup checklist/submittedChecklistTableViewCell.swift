//
//  submittedChecklistTableViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/2/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class submittedChecklistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblscore: UILabel!
    @IBOutlet weak var lblchecklistName: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblpercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.applyShadowAndRadiustoView()
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
