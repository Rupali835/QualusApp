//
//  SupervisorTableViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/19/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class SupervisorTableViewCell: UITableViewCell {
    @IBOutlet weak var lblauctalTicketCount: UILabel!
    @IBOutlet weak var lblexceptedTicket: UILabel!
    @IBOutlet weak var lblNameSup: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5


        // Configure the view for the selected state
    }
    
}
