//
//  TicketDetaIsTableViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/21/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class TicketDetaIsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var ImagesOflable: UIImageView!
    

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
