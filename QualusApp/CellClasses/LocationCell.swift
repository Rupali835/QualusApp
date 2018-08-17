//
//  LocationCell.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var lblFirstLetter: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblLocationNm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
        //  code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.lblFirstLetter.clipsToBounds = true
        self.lblFirstLetter.layer.cornerRadius = 17
        self.lblFirstLetter.layer.cornerRadius =  self.lblFirstLetter.frame.size.width/2
        
    }
    
}
