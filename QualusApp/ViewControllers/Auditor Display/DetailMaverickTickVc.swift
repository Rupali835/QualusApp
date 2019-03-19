//
//  DetailMaverickTickVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire

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
    
     var m_cDetailTickets : [getMaverickTickets] = []
    var lcgetMaverrickTickes: getMaverickTickets!
     var imgArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionPhotos.delegate = self
        collectionPhotos.dataSource = self
        
        if let mt_id = lcgetMaverrickTickes.mt_id
        {
            lblTickectnum.text = "Ticket No: \(mt_id)"
        }
        
        lblObservation.text = lcgetMaverrickTickes.mt_subject
        lblProjectnm.text = lcgetMaverrickTickes.p_name
        lblBranchnm.text = lcgetMaverrickTickes.pb_name
        lblSpacenm.text = lcgetMaverrickTickes.l_space
        lblLocationNm.text = lcgetMaverrickTickes.l_id
        
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
        
    }
    
    func setTicketData(lcdict : getMaverickTickets)
    {
        print(lcdict)
        self.lcgetMaverrickTickes = lcdict
    }
    
    func img(lcURl: String, cell: MaverickTicketImageCell)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{
                
                DispatchQueue.main.async
                    {
                        cell.imgTicket.image = img
                }
            }
        }
    }

}
extension DetailMaverickTickVc : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
          return self.imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionPhotos.dequeueReusableCell(withReuseIdentifier: "MaverickTicketImageCell", for: indexPath) as! MaverickTicketImageCell
        let lcurl = self.imgArr[indexPath.row]
        
        let imgpath = constant.imagePath + lcurl
        
        img(lcURl: imgpath, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cFullScreen = storyboard?.instantiateViewController(withIdentifier: "OpenImageVC") as! OpenImageVC
        
        let lcSeletedImg = self.imgArr[indexPath.row]
        
        cFullScreen.imgNm = lcSeletedImg
        
        self.navigationController?.pushViewController(cFullScreen, animated: true)
        
    }
    
}
