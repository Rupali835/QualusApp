//
//  AdminDetailMaverickTickVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Kingfisher

class AdminDetailMaverickTickVc: UIViewController {

    @IBOutlet weak var collPics: UICollectionView!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblProjectNm: UILabel!
    @IBOutlet weak var lblObserv: UILabel!
    @IBOutlet weak var lblTicketNum: UILabel!
    @IBOutlet weak var lblpicCount: UILabel!
    @IBOutlet weak var lblActionplan: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var lblAssignTo: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!
    @IBOutlet weak var lblExpdate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSpace: UILabel!
    
    var Ticket : getManageTicketDetails!
    var imgArr = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collPics.delegate = self
        collPics.dataSource = self
        
        if self.Ticket != nil
        {
            lblTicketNum.text = Ticket.mt_id
            lblObserv.text = Ticket.mt_subject
            lblProjectNm.text = Ticket.p_name
            lblBranch.text = Ticket.b_name
            lblSpace.text = Ticket.l_space
            lblLocation.text = "Floor:\(Ticket.l_floor!),Building:\(Ticket.b_name!)"
          
            lblAddedBy.text = Ticket.added_by_name
           imgArr = Ticket.mt_photo
            
            if imgArr.count == 0
            {
                lblpicCount.text = "No Photos"
            }
            else{
                lblpicCount.text = "\(imgArr.count) Photos"
                collPics.reloadData()
            }
            
            NFCheck()
        }
        
    }
    
    func setTicketData(lcTicket: getManageTicketDetails)
    {
        self.Ticket = lcTicket
        print(self.Ticket)
    }
    
    func NFCheck()
    {
        if Ticket.assigned_to == "0"
        {
            lblAssignTo.text = "Not Assigned"
        }else
        {
             lblAssignTo.text = Ticket.assigned_to
        }
        if Ticket.mt_action_plan == "NF"
        {
            lblActionplan.text = "Status Pending"
        }else
        {
            lblActionplan.text = Ticket.mt_action_plan
        }
       if Ticket.mt_remark == "NF" && Ticket.mt_remark == ""
       {
        lblRemark.text = "Not given"
        }else
       {
           lblRemark.text = Ticket.mt_remark
        }
        
        if Ticket.mt_action_plan_date == "0000-00-00"
        {
            lblExpdate.text = "Not Provided"
        }else
        {
              lblExpdate.text = Ticket.mt_action_plan_date
        }
    }
   
}
extension AdminDetailMaverickTickVc : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collPics.dequeueReusableCell(withReuseIdentifier: "MaverickTicketImageCell", for: indexPath) as! MaverickTicketImageCell
        
        let fcId = self.Ticket.fc_id
        let lcurl = self.imgArr[indexPath.row]
        var imgPath = String()
        if fcId != "0"
        {
             imgPath = constant.ansImagePath + lcurl
        }else
        {
            imgPath = constant.imagePath + lcurl
        }
        
        let Url = URL(string: imgPath)
         cell.imgTicket.kf.setImage(with: Url)
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cFullScreen = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "OpenImageVC") as! OpenImageVC
        
        let lcSeletedImg = self.imgArr[indexPath.row]
        
        cFullScreen.Fcid = self.Ticket.fc_id
        cFullScreen.imgNm = lcSeletedImg
        cFullScreen.m_bImg = true
        
        self.navigationController?.pushViewController(cFullScreen, animated: true)
        
    }

    
}


