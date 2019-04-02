//
//  SubmitChecklistResponseVc.swift
//  QualusApp
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SubmitChecklistResponseVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   
    @IBOutlet weak var tblChecklisrResp: UITableView!
    var fcid : String = ""
    var UserRole : String = ""
    var RespArr = [AnyObject]()
    var ImgArr = [AnyObject]()
    private var toast : JYToast!
    var show = Bool(false)                 // bool to check which ticket should
    var A_Srole : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        tblChecklisrResp.registerCellNib(ChecklistResponceCell.self)
        tblChecklisrResp.registerCellNib(ChecklistRespImageCell.self)
        tblChecklisrResp.delegate = self
        tblChecklisrResp.dataSource = self
        self.tblChecklisrResp.separatorStyle = .none
        self.tblChecklisrResp.estimatedRowHeight = 80
        self.tblChecklisrResp.rowHeight = UITableViewAutomaticDimension
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
       UserRole = lcDict["role"] as! String
        self.getData()

    }

    private func initUi()
    {
        toast = JYToast()
    }
    
    func setFcid(fcId: String)
    {
        fcid = fcId
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cView.layer.shadowRadius = 1
    }
    
   
    
    func getData()
    {
        var param : [String:String]
        if show == true
        {
            param = ["fc_id" : self.fcid,
                         "user_role" : self.A_Srole]
        }else{
         param = ["fc_id" : self.fcid,
                         "user_role" : self.UserRole]
        }
        
        let respUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/get_filled_checklist_data"
        Alamofire.request(respUrl, method: .post, parameters: param).responseJSON { (fetchData) in
            print(fetchData)
            
            DispatchQueue.main.async {
                let JSON = fetchData.result.value as? [String: AnyObject]
                self.RespArr = JSON!["filled_answer"] as! [AnyObject]
                self.tblChecklisrResp.reloadData()
            }
         
        }
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.RespArr.count > 0
        {
            return self.RespArr.count
        }else{
            
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let lcDict = RespArr[indexPath.row]
        
        let m_img = lcDict["is_photo"] as! String
        let questionType = lcDict["q_type"] as! String
        
        
        if m_img == "0"
        {
            let Rcell = tblChecklisrResp.dequeueReusableCell(withIdentifier: "ChecklistResponceCell", for: indexPath) as! ChecklistResponceCell
            
            if questionType == "1"
            {
               Rcell.lblAnswer.isHidden = true
                Rcell.viewBtns.isHidden = false
                
                let ansQ = lcDict["answer"] as! String
                
                if ansQ == "1"
                {
                    Rcell.imgYes.image = UIImage(named: "selectRadioBtn")
                    Rcell.imgNA.image = UIImage(named: "UnselectRadioBtn")
                    Rcell.imgNo.image = UIImage(named: "UnselectRadioBtn")
                }
                
                if ansQ == "0"
                {
                    Rcell.imgNA.image = UIImage(named: "selectRadioBtn")
                    Rcell.imgYes.image = UIImage(named: "UnselectRadioBtn")
                    Rcell.imgNo.image = UIImage(named: "UnselectRadioBtn")
                }
                
                if ansQ == "2"
                {
                    Rcell.imgNo.image = UIImage(named: "selectRadioBtn")
                    Rcell.imgNA.image = UIImage(named: "UnselectRadioBtn")
                    Rcell.imgYes.image = UIImage(named: "UnselectRadioBtn")
                    
                }
                
            }
            else
            {
                Rcell.lblAnswer.isHidden = false
                Rcell.viewBtns.isHidden = true
                
                let cInput = lcDict["c_input"] as! String
                Rcell.lblAnswer.text = "Answer :   \(cInput)"
            }
            self.designCell(cView: Rcell.backView)
            
            Rcell.lblQuetion.text = (lcDict["question"] as! String)
            
             let indexNumber = indexPath.row + 1
            Rcell.lblQuetionNum.text = "Q" + String(indexNumber)
            
            let remark = lcDict["remark"] as! String
            if remark == "NF"
            {
                Rcell.lblNoRemark.text = "No Remark"
                Rcell.lblRemark.text = ""
            }else{
                Rcell.lblRemark.text = remark
            }
            
            return Rcell
            
        }else{
            
            
            let cell = tblChecklisrResp.dequeueReusableCell(withIdentifier: "ChecklistRespImageCell", for: indexPath) as! ChecklistRespImageCell
            
            self.designCell(cView: cell.backView)
            
         //   let fcid = lcDict["fc_id"] as! String
            
            let ImgArr = lcDict["ans_image"] as! [AnyObject]
            self.BindImages(cImagesArr: ImgArr, cell: cell)
            
            cell.loadData(data: ImgArr, fcId: fcid)
            cell.delegate = self
            
         let indexNumber = indexPath.row + 1
            cell.lblQuetionNum.text = "Q" + String(indexNumber)
            cell.lblQuetion.text = (lcDict["question"] as! String)
            cell.lblRespRemark.text = (lcDict["remark"] as! String)
            
            if questionType == "1"
            {
                cell.lblAnswer.isHidden = true
                cell.viewBtnYesNo.isHidden = false
                
                let ansQ = lcDict["answer"] as! String
                
                if ansQ == "1"
                {
                    cell.imgYes.image = UIImage(named: "selectRadioBtn")
                    cell.imgNo.image = UIImage(named: "UnselectRadioBtn")
                    cell.imgNA.image = UIImage(named: "UnselectRadioBtn")
                }
                
                if ansQ == "0"
                {
                    cell.imgNA.image = UIImage(named: "selectRadioBtn")
                    cell.imgNo.image = UIImage(named: "UnselectRadioBtn")
                    cell.imgYes.image = UIImage(named: "UnselectRadioBtn")
                }
                
                if ansQ == "2"
                {
                    cell.imgNo.image = UIImage(named: "selectRadioBtn")
                    cell.imgNA.image = UIImage(named: "UnselectRadioBtn")
                    cell.imgYes.image = UIImage(named: "UnselectRadioBtn")
                }
                
            }else
            {
                cell.lblAnswer.isHidden = false
                cell.viewBtnYesNo.isHidden = true
                let cInput = lcDict["c_input"] as! String
                cell.lblAnswer.text = "Answer :   \(cInput)"
            }
            return cell
            
        }
      
    }

    
    func BindImages(cImagesArr: [AnyObject], cell: ChecklistRespImageCell)
    {
       
        for (index,lcDict) in cImagesArr.enumerated()
        {
            let img_name = lcDict["img_name"] as! String
            // append path of images here by using image name
             let lcURl = "http://www.kanishkagroups.com/Qualus/uploads/answer_images/" + img_name
            
            Alamofire.request(lcURl, method: .get).responseImage { (resp) in
                print(resp)
                if let img = resp.result.value{
                    
                    DispatchQueue.main.async
                        {
                 
                           
                }
             }
         }
     }
  
  }
}
extension SubmitChecklistResponseVc : openChecklistimageDelegate
{
    func openChecklistImage(imgNm: String)
    {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "OpenImageVC") as! OpenImageVC
        vc.imgNm = imgNm
        vc.m_bImg = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
