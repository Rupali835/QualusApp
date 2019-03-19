//
//  PendingMaverickTicketCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class PendingMaverickTicketCell: UITableViewCell {

    @IBOutlet weak var lblObservation: UILabel!
    
    @IBOutlet weak var closedViewHgt: NSLayoutConstraint!
    @IBOutlet weak var assignViewHgt: NSLayoutConstraint!
    @IBOutlet weak var lblSpace: UILabel!
    @IBOutlet weak var lblTicketNo: UILabel!
    
    @IBOutlet weak var lblClosedBy: UILabel!
    @IBOutlet weak var lblAssignedTo: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
