//
//  ChecklistQuetionCell.swift
//  QualusApp
//
//  Created by user on 28/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ChecklistQuetionCell: UITableViewCell {

    @IBOutlet weak var btnViewPhotos: UIButton!
    @IBOutlet weak var txtRemarks: UITextField!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var btnTakeImg: UIButton!

    @IBOutlet weak var btnYes: DLRadioButton!
    @IBOutlet weak var btnNO: DLRadioButton!
    
    @IBOutlet weak var btnNA: DLRadioButton!
    var formValid = Bool(true)

     var toast = JYToast()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnYes.isMultipleSelectionEnabled = false
        self.selectionStyle = .none
    }

}
