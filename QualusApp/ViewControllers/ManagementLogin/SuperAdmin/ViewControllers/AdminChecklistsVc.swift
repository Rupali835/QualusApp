//
//  AdminChecklistsVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CoreData

class AdminChecklistsVc: UIViewController
{
    @IBOutlet weak var tblChecklists: UITableView!
    
    var URole: String!
    var UId: String!
    var checkListType : Int!
    var UcomId: String!
    var list: [checlist] = []
    var Projectlist = [FeatchProjects]()
    var LocationDaraArr = [FetchLocation]()
    var userDataArray = [FetchUserList]()
    var Name: String!
    var projectName: String!
    var locationName: String!
    var context = AppDelegate().persistentContainer.viewContext
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblChecklists.registerCellNib(SubmitedChecklistCell.self)
        tblChecklists.delegate = self
        tblChecklists.dataSource = self
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        URole = (lcDict["role"] as! String)
        UId = (lcDict["user_id"] as! String)
        UcomId = (lcDict["com_id"] as! String)
        gettingChecklist()
        fetchRecoreds()

    }
 
  
    func fetchRecoreds()
    {
        let Prequest  = NSFetchRequest<FeatchProjects>(entityName: "FeatchProjects")
        let Presponse = try! context.fetch(Prequest)
        Projectlist = Presponse
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
        
        let Uresquest = NSFetchRequest<FetchUserList>(entityName: "FetchUserList")
        let Uresponse = try! context.fetch(Uresquest)
        userDataArray = Uresponse
    }
    
    func gettingChecklist()
    {
        let checklistUrl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Reports/get_monthly_checklist_monitor_data"
        
        let checklistPara = ["type": String(checkListType),
                             "role": URole!,
                             "user_id": UId!,
                             "com_id" : UcomId!]
        print(checklistPara)
        OperationQueue.main.addOperation {
            SVProgressHUD.show()
        }
        
        manager.request(checklistUrl, method: .post, parameters: checklistPara, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            if let resp = data.result.value
            {
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
                do
                {
                    let CDataModel = try JSONDecoder().decode(checkListDataModel.self, from: resp)
                    self.list = CDataModel.getChecklistData
                    self.tblChecklists.reloadData()
                }catch
                {
                    print(error)
                }
            }
        }
    }
    
    func getdetails(u_id:String, p_id:String, l_id:String)
    {
        for item in userDataArray
        {
            if u_id == item.user_id
            {
                Name = item.full_name
            }
        }
        
        for item1 in Projectlist
        {
            if p_id == item1.p_id
            {
                projectName = item1.p_name
            }
        }
        
        for item2 in LocationDaraArr
        {
            if l_id == item2.l_id
            {
                let fNm = item2.l_floor
                let Rnm = item2.l_room
                let Wnm = item2.l_wing
                let Snm = item2.l_space
                
                if Rnm == "NF" || Wnm == "NF"
                {
                    locationName = "Floor: \(fNm!), Space: \(Snm!)"
                }
                else
                {
                      locationName = "Room: \(Rnm!), Wing: \(Wnm!), Floor: \(fNm!), Space: \(Snm!)"
                }
              

                
//                locationName = item2.l_space
            }
        }
        
    }

}
extension AdminChecklistsVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChecklists.dequeueReusableCell(withIdentifier: "SubmitedChecklistCell", for: indexPath) as! SubmitedChecklistCell
        
        let lcdict = list[indexPath.row]
        cell.lblChecklistNm.text = lcdict.c_name
   
        let u_id = lcdict.user_id
        let p_id = lcdict.p_id
        let l_id = lcdict.l_id
        
        getdetails(u_id: u_id, p_id: p_id, l_id: l_id)
        cell.lblFilledBy.text = "Filled by \(Name!)"
        cell.lblLocation.text = locationName
        
        cell.lblFilledBy.isHidden = false

        let date = lcdict.created_time.convertDateFormaterInList()
        cell.lblDate.text = date
        
        let percent = lcdict.percent+"%"
        let TicketScore = lcdict.score
        
        cell.lblAverage.textColor = UIColor.red
        
        if TicketScore == "0"
        {
            cell.lblAverage.text =  percent + "" + "(Fail)"
        }
        else if TicketScore == "2"
        {
            cell.lblAverage.text =  percent + "" + "(Pass)"
            cell.lblAverage.textColor = UIColor.green
        }else{
            cell.lblAverage.text =  percent + "" + "(Average)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
          // if checklist by supervior = 2 , auditor =  3
        let fCID = list[indexPath.row].fc_id
        
        let nextViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SubmitChecklistResponseVc") as! SubmitChecklistResponseVc
        
        if checkListType == 1  //sup
        {
            nextViewController.A_Srole = "2"
            
        }else{
            nextViewController.A_Srole = "3"
        }
        
        nextViewController.setFcid(fcId: fCID)
        nextViewController.show = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}
