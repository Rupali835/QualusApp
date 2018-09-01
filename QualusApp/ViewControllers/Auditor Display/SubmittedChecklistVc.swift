//
//  SubmittedChecklistVc.swift
//  QualusApp
//
//  Created by user on 01/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class SubmittedChecklistVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblSubmitedList: UITableView!
    var UserId : String = ""
    var UserRole : String = ""
    var CheckListArr = [AnyObject]()
    private var toast : JYToast!
    var FcId : String = ""
    //var LocationDataArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUi()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole = lcDict["role"] as! String
        self.UserId = lcDict["user_id"] as! String
        tblSubmitedList.registerCellNib(SubmitedChecklistCell.self)
        tblSubmitedList.delegate = self
        tblSubmitedList.dataSource = self
        self.tblSubmitedList.separatorStyle = .none
        self.tblSubmitedList.estimatedRowHeight = 80
        self.tblSubmitedList.rowHeight = UITableViewAutomaticDimension
        self.getdata()
        
    }

    private func initUi()
    {
        toast = JYToast()
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cView.layer.shadowRadius = 1
        
    }

    func getdata()
    {
        let listUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/get_7_day_submitted_checklist"
        let listParam = ["user_id" : self.UserId,
                         "user_role" : self.UserRole]
        
        Alamofire.request(listUrl, method: .post, parameters: listParam).responseJSON { (fetchData) in
        //print(fetchData)
            
            let JSON = fetchData.result.value as? [String: AnyObject]
            
            self.CheckListArr = JSON!["filled_checklist"] as! [AnyObject]
            print("Ticket List", self.CheckListArr)
            self.tblSubmitedList.reloadData()
            
        }
        
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.CheckListArr.count > 0
        {
            return self.CheckListArr.count
        }else{
          //  self.toast.isShow("No any submitted checklist")
            return 0
        }
    }
    
    func GetLocationData(cLocationId: String, cell: SubmitedChecklistCell)
    {
        let LocationDataArr = LocationData.cLocationData.fetchOfflineLocation()!
        
        for (index, _) in LocationDataArr.enumerated()
        {
            let locationEnt = LocationDataArr[index] as! FetchLocation
            
            if locationEnt.l_id ==  cLocationId
            {
                let l_floor = locationEnt.l_floor
                let branch_id = locationEnt.branch_id
                let L_room = locationEnt.l_room
                let L_wing = locationEnt.l_wing
                
             
                let BuildingArr = LocationData.cLocationData.fetchOfflineBuilding()!
                
                for (index, _) in BuildingArr.enumerated()
               {
                  let BuildingEnt = BuildingArr[index] as! FetchBuilding
                    let BranchId = BuildingEnt.branch_id
              //  print("BranchId =", BranchId)
                    if branch_id == BranchId
                    {
                       let b_name = BuildingEnt.b_name
                        
                        if L_room != "NF"
                        {
                            cell.lblLocation.text = "Room:"  + L_room! + "," + "Floor:" + l_floor! + "," + b_name!
                        }
                        if L_wing != "NF"
                        {
                            cell.lblLocation.text = "Room:"  + L_room! + "," + "Floor:" + l_floor! + "," + "Wing:" + L_wing! + "," + b_name!
                        }
                   }
              }
                
          }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSubmitedList.dequeueReusableCell(withIdentifier: "SubmitedChecklistCell", for: indexPath) as! SubmitedChecklistCell
        
        let lcDict = CheckListArr[indexPath.row]
        self.designCell(cView: cell.backView)
    
        cell.lblChecklistNm.text = lcDict["c_name"] as! String
       
        let l_id = lcDict["l_id"] as! String
        
        self.GetLocationData(cLocationId: l_id, cell: cell)
        
        cell.lblDate.text = lcDict["start_time"] as! String
        let Percent = lcDict["percent"] as! String
        
        cell.lblPercent.text = Percent  + "%"
        let Score = lcDict["score"] as! String
        if Score == "0"
        {
             cell.lblAverage.text = "Fail"
        }
        if Score == "1"
        {
            cell.lblAverage.text = "Average"
        }
        if Score == "2"
        {
            cell.lblAverage.text = "Pass"
        }
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let lcDict = CheckListArr[indexPath.row]
        
        self.FcId = lcDict["fc_id"] as! String
        print("FcId", self.FcId)
        let respVc = storyboard?.instantiateViewController(withIdentifier: "SubmitChecklistResponseVc") as! SubmitChecklistResponseVc
        
        respVc.setFcid(fcId: self.FcId)
        self.navigationController?.pushViewController(respVc, animated: true)
        
        
    }

}
