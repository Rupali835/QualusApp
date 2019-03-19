//
//  SubmitedChecklistCell.swift
//  QualusApp
//
//  Created by user on 01/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class SubmitedChecklistCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblFilledBy: UILabel!
    @IBOutlet weak var lblChecklistNm: UILabel!
    
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
