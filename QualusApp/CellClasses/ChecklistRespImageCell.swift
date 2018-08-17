//
//  ChecklistRespImageCell.swift
//  QualusApp
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ChecklistRespImageCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblQuetionNum: UILabel!
    
    @IBOutlet weak var lblQuetion: UILabel!
    
    @IBOutlet weak var imgYes: UIImageView!
    
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var lblRespRemark: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var imgNA: UIImageView!
    @IBOutlet weak var imgNo: UIImageView!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img4: UIImageView!
    
    let iMgUrl = "http://www.kanishkagroups.com/Qualus/uploads/answer_images/150_1527940217495.jpg"
    
    
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
