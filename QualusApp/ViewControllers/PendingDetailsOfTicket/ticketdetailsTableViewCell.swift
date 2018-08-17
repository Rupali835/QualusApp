//
//  ticketdetailsTableViewCell.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/20/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SDWebImage

protocol imgaeSelectionProtocal
{
    func SelectedImg(ImageArr:[String] , selectedindex: Int)
}


class ticketdetailsTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoImage: UILabel!

    
    var arrImges = [String]()
    var delegate: imgaeSelectionProtocal?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellNib(ImageCollectionViewCell.self)
        self.selectionStyle = .none

    }

    func loadData(data:[String:Any])
    {
        lblTitle.text = data["title"] as? String
        arrImges = data["details"] as! [String]
        if arrImges.count == 0 {
            collectionView.isHidden = true
            lblNoImage.text = "No Photos"
        }else{
            collectionView.isHidden = false
      lblNoImage.text = "\(arrImges.count) Photos"
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.className(ImageCollectionViewCell.self), for: indexPath) as! ImageCollectionViewCell
        
        let img = arrImges[indexPath.row]
        let url = "http://kanishkagroups.com/Qualus/uploads/ticket_images/\(img)"
        let finalurl = URL(string: url)
        cell.ticketImage.sd_setImage(with: finalurl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.SelectedImg(ImageArr: arrImges , selectedindex: indexPath.item)

    }
    
}





