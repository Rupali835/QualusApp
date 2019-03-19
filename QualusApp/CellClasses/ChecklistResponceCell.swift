//
//  ChecklistResponceCell.swift
//  QualusApp
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ChecklistResponceCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var viewBtns: UIView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuetion: UILabel!
    @IBOutlet weak var lblQuetionNum: UILabel!
    
    @IBOutlet weak var lblNoRemark: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var imgNA: UIImageView!
    @IBOutlet weak var imgNo: UIImageView!
    @IBOutlet weak var imgYes: UIImageView!
    
    @IBOutlet weak var lblImg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblQuetionNum.layer.cornerRadius = 12.5
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
