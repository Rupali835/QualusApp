//
//  QueTypeOneBarcodeCell.swift
//  QualusApp
//
//  Created by user on 13/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class QueTypeOneBarcodeCell: UITableViewCell {

    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtRemark: UITextField!
    @IBOutlet weak var btnNA: DLRadioButton!
    @IBOutlet weak var btnNO: DLRadioButton!
    @IBOutlet weak var btnYES: DLRadioButton!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
