//
//  ChecklistQTypeCell.swift
//  QualusApp
//
//  Created by user on 06/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ChecklistQTypeCell: UITableViewCell {

    
    @IBOutlet weak var btnViewPics: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblQuetnType: UILabel!
    
    @IBOutlet weak var txtAnswer: UITextField!
    
    @IBOutlet weak var txtRemark: UITextField!
    
    @IBOutlet weak var btnSubmitQ: UIButton!
    @IBOutlet weak var btntakeImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
