//
//  DetailMaverickTickVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class DetailMaverickTickVc: UIViewController {

    @IBOutlet weak var collectionPhotos: UICollectionView!
    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var lblActionPlan: UILabel!
    @IBOutlet weak var lblremark: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblLocationNm: UILabel!
    @IBOutlet weak var lblSpacenm: UILabel!
    @IBOutlet weak var lblBranchnm: UILabel!
    @IBOutlet weak var lblTickectnum: UILabel!
    @IBOutlet weak var lblProjectnm: UILabel!
    @IBOutlet weak var lblObservation: UILabel!
    
   
    var lcgetMaverrickTickes: getMaverickTickets!
    var lcGetProactiveTickets : getProactiveTickets!
     var imgArr = [String]()
    var Locationstr = String()
    var m_bMaverickTicket = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionPhotos.delegate = self
        collectionPhotos.dataSource = self
        
        if m_bMaverickTicket == true
        {
            lblTickectnum.text = "Ticket No: \(lcgetMaverrickTickes.mt_id ?? "")"
            lblObservation.text = lcgetMaverrickTickes.mt_subject
            lblProjectnm.text = lcgetMaverrickTickes.p_name
            lblBranchnm.text = lcgetMaverrickTickes.pb_name
            lblSpacenm.text = lcgetMaverrickTickes.l_space
            lblLocationNm.text = Locationstr
            
            if lcgetMaverrickTickes.mt_action_plan_date == "0000-00-00"
            {
                lblExpDate.text = "Not Provided"
            }else
            {
                lblExpDate.text = lcgetMaverrickTickes.mt_action_plan_date
            }
            
            lblremark.text = lcgetMaverrickTickes.mt_remark
            lblActionPlan.text = lcgetMaverrickTickes.mt_action_plan
            
            imgArr = lcgetMaverrickTickes.mt_photo
            let picCount = imgArr.count
            if picCount == 0
            {
                lblPhotoCount.text = "No Photos"
            }else
            {
                lblPhotoCount.text = "\(picCount) Photos"
                collectionPhotos.reloadData()
            }
            
        }else
        {
            lblTickectnum.text = "Ticket No: \(lcGetProactiveTickets.pt_id ?? "")"
            lblObservation.text = lcGetProactiveTickets.pt_subject
            lblProjectnm.text = lcGetProactiveTickets.p_name
            lblBranchnm.text = lcGetProactiveTickets.pb_name
            lblSpacenm.text = lcGetProactiveTickets.l_space
            lblLocationNm.text = Locationstr
            
            if lcGetProactiveTickets.pt_action_plan_date == "0000-00-00"
            {
                lblExpDate.text = "Not Provided"
            }else
            {
                lblExpDate.text = lcGetProactiveTickets.pt_action_plan_date
            }
            
            lblremark.text = lcGetProactiveTickets.pt_remark
            lblActionPlan.text = lcGetProactiveTickets.pt_action_plan
            
            imgArr = lcGetProactiveTickets.pt_photo
            let picCount = imgArr.count
            if picCount == 0
            {
                lblPhotoCount.text = "No Photos"
            }else
            {
                lblPhotoCount.text = "\(picCount) Photos"
                self.collectionPhotos.reloadData()
            }

            
        }
       
        
    }
    
    func setTicketData(lcdict : getMaverickTickets)
    {
        self.lcgetMaverrickTickes = lcdict
        self.m_bMaverickTicket = true
    }
   
    func setProactiveTicket(lcproactive : getProactiveTickets)
    {
        self.lcGetProactiveTickets = lcproactive
        self.m_bMaverickTicket = false
    }
    
}
extension DetailMaverickTickVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
          return self.imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionPhotos.dequeueReusableCell(withReuseIdentifier: "MaverickTicketImageCell", for: indexPath) as! MaverickTicketImageCell
        
        var fcid = String()
        var lcurl = String()
        var imgPath = String()

        if m_bMaverickTicket == true
        {
             fcid = lcgetMaverrickTickes.fc_id
             lcurl = self.imgArr[indexPath.row]
            if fcid != "0"
            {
                imgPath = constant.ansImagePath + lcurl
            }else
            {
                imgPath = constant.imagePath + lcurl
            }
        }
        else
        {
            fcid = lcGetProactiveTickets.pt_id
            lcurl = self.imgArr[indexPath.row]
            imgPath = constant.proactive_imgPath + lcurl
        }
      
        let Url = URL(string: imgPath)
        cell.imgTicket.kf.setImage(with: Url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cFullScreen = storyboard?.instantiateViewController(withIdentifier: "OpenImageVC") as! OpenImageVC
        
        var fcid = String()
        
        if m_bMaverickTicket == true
        {
            fcid = lcgetMaverrickTickes.fc_id
            cFullScreen.Fcid = fcid
            cFullScreen.m_bImg = true

        }
        else
        {
            cFullScreen.m_bImg = false
        }

        let lcSeletedImg = self.imgArr[indexPath.row]
        cFullScreen.imgNm = lcSeletedImg
        
        self.navigationController?.pushViewController(cFullScreen, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - (5+2.5), height: (collectionView.frame.size.height / 2) - (5+2.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}
