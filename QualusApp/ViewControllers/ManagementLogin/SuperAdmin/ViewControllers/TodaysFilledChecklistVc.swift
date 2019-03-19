//
//  TodaysFilledChecklistVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/16/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class TodaysFilledChecklistVc: UIViewController {

    @IBOutlet weak var tblFilledChecklist: UITableView!
    
    var type: Int!
    var userid : Int!
    var userRoll : String!
    var Aud_Sup_Roll : String!
    var ChecklistDetailsArray : [checklistData] = []
    var Projectlist = [FeatchProjects]()
    var LocationList = [FetchLocation]()
    var userArray = [FetchUserList]()
    var context = AppDelegate().persistentContainer.viewContext
    
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFilledChecklist.registerCellNib(SubmitedChecklistCell.self)
        tblFilledChecklist.delegate = self
        tblFilledChecklist.dataSource = self
        tblFilledChecklist.separatorStyle = .none
        fetchRecoreds()
        getFilledChecklistData()
    }
 
    func getFilledChecklistData()
    {
        let Checklistpara = ["type": type!  , "user_id": userid! ]
        print(Checklistpara)
        manager.request(constant.BaseUrl+constant.todaysChecklist, method: .post, parameters: Checklistpara, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            print(response)
            if let data = response.result.value
            {
                do{
                    
                    let checklistModel = try JSONDecoder().decode(filledChceklistData.self, from: data)
                    self.ChecklistDetailsArray = checklistModel.filled_checklist
                    
                    if self.ChecklistDetailsArray.count == 0
                    {
                        Utilities.shared.centermsg(msg: "No checklist found", view: self.view)
                    }else
                    {
                          self.tblFilledChecklist.reloadData()
                    }
                    
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        return dateFormatter.string(from: date!)
        
    }
   
}
extension TodaysFilledChecklistVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return ChecklistDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblFilledChecklist.dequeueReusableCell(withIdentifier: "SubmitedChecklistCell", for: indexPath) as! SubmitedChecklistCell
        
        let lcdict = ChecklistDetailsArray[indexPath.row]
        
        cell.lblChecklistNm.text = lcdict.c_name
        cell.lblFilledBy.isHidden = true
        let P_id = lcdict.p_id
        let TicketScore = lcdict.score
        
        let percent = lcdict.percent+"%"
        
        let stime: String = lcdict.start_time
        
        cell.lblDate.text = convertDateFormater(stime)
        
        let l_id = lcdict.l_id
        

        for item2 in LocationList
        {
            if l_id == item2.l_id
            {
                cell.lblLocation.text = item2.l_space
            }
        }
        
        if TicketScore == "0"
        {
            cell.lblAverage.text = percent + "" + "(Fail)"
            cell.lblAverage.textColor = UIColor.red
        }
        else if TicketScore == "2"
        {
            cell.lblAverage.text = percent + "" + "(Pass)"
            cell.lblAverage.textColor = UIColor.green
        }else{
            cell.lblAverage.text = percent + "" + "(Average)"
           cell.lblAverage.textColor = UIColor.yellowdark
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let fCID = ChecklistDetailsArray[indexPath.row].fc_id
        let nextVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SubmitChecklistResponseVc") as! SubmitChecklistResponseVc
        nextVC.setFcid(fcId: fCID)
        nextVC.show = true
        nextVC.A_Srole = Aud_Sup_Roll
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
