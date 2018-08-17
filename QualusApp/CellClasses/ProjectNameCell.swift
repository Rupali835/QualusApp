//
//  ProjectNameCell.swift
//  QualusApp
//
//  Created by user on 23/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ProjectNameCell: UITableViewCell {

    @IBOutlet weak var lblScannerFlag: UILabel!
    @IBOutlet weak var lblProjectNm: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
         self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
