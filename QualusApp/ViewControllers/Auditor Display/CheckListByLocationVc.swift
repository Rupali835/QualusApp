//
//  CheckListByLocationVc.swift
//  QualusApp
//
//  Created by user on 26/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class CheckListByLocationVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   
    var userRole : String!
    var QrString : String!
    var LocationDaraArr = [AnyObject]()
   // var Lid : String = ""
    var checklistArr = [AnyObject]()
    var QuetionArr = [AnyObject]()
    var ClassId : String!
    var projectId : String!
    var showVC = Bool()
    
    @IBOutlet weak var tblChecklist: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.userRole = lcDict["role"] as! String
        print("Role", self.userRole)
        tblChecklist.dataSource = self
        tblChecklist.delegate = self
        
        tblChecklist.registerCellNib(LocationCell.self)
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
       
        for (index, _) in LocationDaraArr.enumerated()
        {
            let locationEnt = LocationDaraArr[index] as! FetchLocation
           
            if locationEnt.l_barcode == self.QrString
            {
                let l_id = locationEnt.l_id!
                self.getChecklist(lcl_Id: l_id,rollId: self.userRole )
                
            }
           
        }
    }

    func setQrString(cQr: String, ProjId: String, Showvc: Bool)
    {
        self.QrString = cQr
        self.projectId = ProjId
        self.showVC = Showvc    // false
    }
   
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func getChecklist(lcl_Id: String,rollId: String )
    {
        let checklistUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/get_checklist_by_location"
        let checklistParam = ["l_id" : lcl_Id,
                              "user_role" : rollId]
        
          Alamofire.request(checklistUrl, method: .post, parameters: checklistParam).responseJSON { (fetchData) in
        
            print(fetchData)
            let JSON = fetchData.result.value as! [String: AnyObject]
            
            self.checklistArr = JSON["Checklist"] as! [AnyObject]
            self.QuetionArr = JSON["Questions"] as! [AnyObject]
            
            self.tblChecklist.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return checklistArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblChecklist.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let lcDict = self.checklistArr[indexPath.row]
        
        self.designCell(cView: cell.backView)
        
         let lcUserName = lcDict["c_name"] as! String
        cell.lblLocationNm.text = (lcDict["c_name"] as! String)
        self.ClassId = lcDict["class_id"] as! String
        let firstLetter = lcUserName.first!
        cell.lblFirstLetter.text = String(describing: firstLetter)
        cell.lblFirstLetter.backgroundColor = getRandomColor()
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if self.showVC == false
        {
            let QuestionVc = storyboard?.instantiateViewController(withIdentifier: "ChecklistQuestionsVc") as! ChecklistQuestionsVc
            
            let lcDict = self.checklistArr[indexPath.row]
            let cid = lcDict["c_id"] as! String
            
            var questionArr = [AnyObject]()
            
            for lcDict in self.QuetionArr
            {
                let cidQues = lcDict["c_id"] as! String
                if cid == cidQues
                {
                    questionArr.append(lcDict)
                }
            }
            
            QuestionVc.ProjId = self.projectId
            QuestionVc.ClassificationId = self.ClassId
            QuestionVc.QuestionArray = questionArr
            QuestionVc.QrStr = self.QrString
            QuestionVc.CheckListArr = self.checklistArr
        self.navigationController?.pushViewController(QuestionVc, animated: true)
        }
        else{
            
            let QueBarcodeVc = storyboard?.instantiateViewController(withIdentifier: "ChecklistQueForBarcodeVC") as! ChecklistQueForBarcodeVC
            
            let lcDict = self.checklistArr[indexPath.row]
            let cid = lcDict["c_id"] as! String
            var questionArr = [AnyObject]()
            
            for lcDict in self.QuetionArr
            {
                let cidQues = lcDict["c_id"] as! String
                
                if cid == cidQues
                {
                    questionArr.append(lcDict)
                }
            }
            QueBarcodeVc.ProjId = self.projectId
            QueBarcodeVc.ClassificationId = self.ClassId
            QueBarcodeVc.QuestionArray = questionArr
            QueBarcodeVc.QrStr = self.QrString
            self.navigationController?.pushViewController(QueBarcodeVc, animated: true)
        }
    }
}
