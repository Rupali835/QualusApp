//
//  MaverickTicketCell.swift
//  QualusApp
//
//  Created by user on 22/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class MaverickTicketCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblTicketNumber: UILabel!
    
    @IBOutlet weak var lblTiktStatus: UILabel!
    
    @IBOutlet weak var lblTiktObservation: UILabel!
    
    @IBOutlet weak var lblSpace: UILabel!
    
    @IBOutlet weak var lblTiktLocation: UILabel!
    
    @IBOutlet weak var lblTiktProject: UILabel!
    
    @IBOutlet weak var lblTiktBranch: UILabel!
    
    @IBOutlet weak var lblAssignTo: UILabel!
    
    
    @IBOutlet weak var lblTiktRemark: UILabel!
    
    @IBOutlet weak var lblActionPlan: UILabel!
    
    @IBOutlet weak var lblCompltnDate: UILabel!
    
    @IBOutlet weak var lblActionPlanSupervisor: UILabel!
    
    @IBOutlet weak var btnViewPhotos: UIButton!
    @IBOutlet weak var lblRemarkBySupervisor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

         self.selectionStyle = .none
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
