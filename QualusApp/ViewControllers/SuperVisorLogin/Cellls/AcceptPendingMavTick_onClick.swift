//
//  AcceptPendingMavTick_onClick.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/28/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AcceptPendingMavTick_onClick: UITableViewCell {

    @IBOutlet weak var lblobser: UILabel!
    
    @IBOutlet weak var lblTicketnum: UILabel!
    @IBOutlet weak var btnAcceptCloseTicket: UIButton!
    @IBOutlet weak var btnViewMoreDetail: UIButton!
   
    @IBOutlet weak var viewClosedBy: NSLayoutConstraint!
    @IBOutlet weak var viewAcceptedBy: NSLayoutConstraint!
    @IBOutlet weak var lblClosedBy: UILabel!
    @IBOutlet weak var lblAcceptedBy: UILabel!
    @IBOutlet weak var lblGeneratedBy: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSpace: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
