//
//  ChecklistRespImageCell.swift
//  QualusApp
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SDWebImage
import Kingfisher

protocol openChecklistimageDelegate
{
    func openChecklistImage(imgNm: String)
}

class ChecklistRespImageCell: UITableViewCell
{

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var viewBtnYesNo: UIView!
    @IBOutlet weak var lblQuetionNum: UILabel!
    @IBOutlet weak var lblQuetion: UILabel!
    @IBOutlet weak var imgYes: UIImageView!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var lblRespRemark: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var imgNA: UIImageView!
    @IBOutlet weak var imgNo: UIImageView!
    @IBOutlet weak var collImages: UICollectionView!
    
    var arrImges = [AnyObject]()
    var objOpenImageVc : OpenImageVC!
    var Fcid = String()
    var delegate: openChecklistimageDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none
        collImages.registerCellNib(ImageCollectionViewCell.self)
        collImages.delegate = self
        collImages.dataSource = self
        collImages.isHidden = false
        collImages.reloadData()

    }
    
    func loadData(data:[AnyObject], fcId: String)
    {
        self.arrImges = data
        collImages.isHidden = false
        collImages.reloadData()
        self.Fcid = "0"
    }

    
}
extension ChecklistRespImageCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.className(ImageCollectionViewCell.self), for: indexPath) as! ImageCollectionViewCell
        
        
        let imgDict = arrImges[indexPath.row]
        
        let imgNm = imgDict["img_name"] as! String
        
        var imgPath = String()
    
        imgPath = constant.ansImagePath + imgNm
        let Imgurl = URL(string: imgPath)
        cell.ticketImage.kf.setImage(with: Imgurl)
       // cell.ticketImage.sd_setImage(with: Imgurl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       

        let imgDict = arrImges[indexPath.row]
        
        let imgName = imgDict["img_name"] as! String
        delegate?.openChecklistImage(imgNm: imgName)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
