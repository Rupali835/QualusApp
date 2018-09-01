//
//  TodayFilledChecklistVC.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/2/18.
//  Copyright © 2018 user. All rights reserved.
// type :  1 = supervisor checklist , 2 = auditor checklist
//  userid : selected collection user id


import UIKit
import Alamofire
import CoreData

class TodayFilledChecklistVC: UIViewController {
    
    var type: Int!
    var userid : Int!
    var userRoll : String!
    var Aud_Sup_Roll : String!
    var ChecklistDetailsArray : [checklistData] = []
    @IBOutlet weak var tableview: UITableView!
    var Projectlist = [FeatchProjects]()
    var LocationList = [FetchLocation]()
    var userArray = [FetchUserList]()
    var context = AppDelegate().persistentContainer.viewContext

    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("type",type)
        print("userid",userid)
        tableview.delegate = self
        tableview.dataSource = self
        fetchRecoreds()
        getFilledChecklistData()
        tableview.registerCellNib(submittedChecklistTableViewCell.self)
    }

   
    func getFilledChecklistData()
    {
        let Checklistpara = ["type": type!  , "user_id": userid! ]
        print(Checklistpara)
        manager.request(constant.BaseUrl+constant.todaysChecklist, method: .post, parameters: Checklistpara, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            
           if let data = response.result.value
           {
            do{
            
                let checklistModel = try JSONDecoder().decode(filledChceklistData.self, from: data)
                self.ChecklistDetailsArray = checklistModel.filled_checklist
                self.tableview.reloadData()
                
            }catch{
               print(error)
            }
            }
        }
    }
  
    func fetchRecoreds()
    {
        let Prequest  = NSFetchRequest<FeatchProjects>(entityName: "FeatchProjects")
        let Presponse = try! context.fetch(Prequest)
        Projectlist = Presponse
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationList = Lresponse
        
        let Uresquest = NSFetchRequest<FetchUserList>(entityName: "FetchUserList")
        let Uresponse = try! context.fetch(Uresquest)
        userArray = Uresponse
        
        for item2 in userArray
        {
            if userid == Int(item2.user_id!)
            {
                Aud_Sup_Roll = item2.role
            }
        }
        
    }
    
    
    func convertDateFormater(_ date: String) -> String
    {
        //            "start_time": "2018-07-17 13:12:21",
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "d MMM yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    func convertTimeFormatter(_ Time: String)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"         //HH:mm:ss"
        let Time = dateFormatter.date(from: Time)
        dateFormatter.dateFormat = "h:mm a"
        return  dateFormatter.string(from: Time!)
    }
    
}

extension TodayFilledChecklistVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 299
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChecklistDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = submittedChecklistTableViewCell.loadNib()
        cell.lblchecklistName.text = ChecklistDetailsArray[indexPath.row].c_name
        let P_id = ChecklistDetailsArray[indexPath.row].p_id
        let TicketScore = ChecklistDetailsArray[indexPath.row].score
        cell.lblpercentage.text = ChecklistDetailsArray[indexPath.row].percent+"%"
        let startTime = ChecklistDetailsArray[indexPath.row].start_time.split(separator: " ")
        let endTime = ChecklistDetailsArray[indexPath.row].end_time.split(separator: " ")
        let eTime: String = String(endTime[1])
        cell.lblEndTime.text = convertTimeFormatter(eTime)
        let stime: String = String(startTime[1])
        cell.lblStartTime.text = convertTimeFormatter(stime)
        let l_id = ChecklistDetailsArray[indexPath.row].l_id
        
        for item in Projectlist
        {
            for item in Projectlist
            {
                if P_id == item.p_id
                {
                    cell.lblProjectName.text = item.p_name
                }
            }
        }
        
        for item2 in LocationList
        {
            if l_id == item2.l_id
            {
                cell.lblLocation.text = item2.l_space
            }
        }
        
        
        if TicketScore == "0"
        {
            cell.lblscore.text = "Fail"
            cell.lblscore.textColor = UIColor.red
        }
        else if TicketScore == "2"
        {
            cell.lblscore.text = "Pass"
            cell.lblscore.textColor = UIColor.green
        }else{
            cell.lblscore.text = "Average"
            cell.lblscore.textColor = UIColor.yellowdark
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fCID = ChecklistDetailsArray[indexPath.row].fc_id
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SubmitChecklistResponseVc") as! SubmitChecklistResponseVc
        nextVC.setFcid(fcId: fCID)
        nextVC.show = true
        nextVC.A_Srole = Aud_Sup_Roll
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}




