//
//  AdminMaverickTicketCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AdminMaverickTicketCell: UITableViewCell {

    @IBOutlet weak var lblTicketNumStatus: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblBranchNm: UILabel!
    @IBOutlet weak var lblProjectNm: UILabel!
    @IBOutlet weak var lblObserv: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
