//
//  QueTypeTwoBarcodeCell.swift
//  QualusApp
//
//  Created by user on 13/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class QueTypeTwoBarcodeCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtRemark: UITextField!
    @IBOutlet weak var txtAnswer: UITextField!
    @IBOutlet weak var lblQuetion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
