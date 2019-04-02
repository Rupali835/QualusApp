//
//  imagesCollectionViewCell.swift
//  RealUs
//
//  Created by iAM on 01/02/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
//protocol imagesCollectionViewCelldelegate: class {
//    func indexcell(cell : imagesCollectionViewCell)
//}

class imagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var images: UIImageView!
    @IBOutlet var delete: UIButton!
//    weak var delegate : imagesCollectionViewCelldelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        Utilities.shared.cornerRadius(objects: [delete], number: delete.frame.width / 2)
      //  delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
//    @objc func deleteAction(){
//        delegate.indexcell(cell: self)
//    }
}
