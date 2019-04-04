

import UIKit
import Alamofire
import CoreData

class SubmittedChecklistVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblSubmitedList: UITableView!
    var UserId : String = ""
    var UserRole : String = ""
    var CheckListArr = [AnyObject]()
    private var toast : JYToast!
    var FcId : String = ""
    //var LocationDataArr = [AnyObject]()
    let cell = SubmitedChecklistCell()
    var LocationDaraArr = [FetchLocation]()
    var locationName = String()
    var context = AppDelegate().persistentContainer.viewContext
    
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
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
        
        
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
        print(fetchData)
            
            let JSON = fetchData.result.value as? [String: AnyObject]
            
            self.CheckListArr = JSON!["filled_checklist"] as! [AnyObject]
            print(self.CheckListArr.count)
            self.tblSubmitedList.reloadData()
            if self.CheckListArr.isEmpty == true
            {
             
                Utilities.shared.centermsg(msg: "No any checklist available", view: self.view)
            }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.CheckListArr.count > 0
        {
            return self.CheckListArr.count
        }else{
           return 0
        }
    }
    
    func getLid(l_id : String)
    {
        for item2 in LocationDaraArr
        {
            if l_id == item2.l_id
            {
                let fNm = item2.l_floor
                let Rnm = item2.l_room
                let Wnm = item2.l_wing
                let Snm = item2.l_space
                
                let bid = item2.branch_id
               
                let BuildingArr = LocationData.cLocationData.fetchOfflineBuilding()!
                
                for (index, _) in BuildingArr.enumerated()
                {
                    
                    let BuildingEnt = BuildingArr[index] as! FetchBuilding
                    
                    if bid == BuildingEnt.branch_id
                    {
                        let b_name = BuildingEnt.b_name
                        
                        if Rnm == "NF" || Wnm == "NF"
                        {
                            locationName = "Floor: \(fNm!), Space: \(Snm!), \(b_name!)"
                        }
                        else
                        {
                            locationName = "Room: \(Rnm!), Wing: \(Wnm!), Floor: \(fNm!), Space: \(Snm!), \(b_name!)"
                        }
                    }
                        
                    
                }
                
                //let Bnm = item2.
                
               
            }
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
                
           //     let cb = BuildingArr.filter { $0.contains(BuildingEnt.branch_id)}
                
                
                    let BranchId = BuildingEnt.branch_id
                    if branch_id == BranchId
                    {
                       let b_name = BuildingEnt.b_name
                        
                        if L_room == "NF" && L_wing == "NF"
                        {
                           cell.lblLocation.text = "Floor:" + l_floor! + "," + b_name!
                        }
                        
//                        if L_wing == "NF"
//                        {
//                           cell.lblLocation.text = "Room:"  + L_room! + "," + "Floor:" + l_floor! + "," + "Wing:" + L_wing! + "," + b_name!
//                        }
                        
                        

                   }
              }
                
          }
            
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSubmitedList.dequeueReusableCell(withIdentifier: "SubmitedChecklistCell", for: indexPath) as! SubmitedChecklistCell
       
         let lcDict = CheckListArr[indexPath.row]
        let sDate = lcDict["start_time"] as! String
        cell.lblDate.text = sDate.convertDateFormaterInList()
        
        self.designCell(cView: cell.backView)
    
        cell.lblChecklistNm.text = lcDict["c_name"] as! String
       
        let l_id = lcDict["l_id"] as! String
        
        cell.lblFilledBy.isHidden = true
        self.getLid(l_id: l_id)
        //self.GetLocationData(cLocationId: l_id, cell: cell)
        cell.lblLocation.text = locationName
        
       let Percent = lcDict["percent"] as! String
        let percent  = Percent + "%"
        let Score = lcDict["score"] as! String
        if Score == "0"
        {
            cell.lblAverage.text = percent + "  " + "Fail"
            cell.lblAverage.textColor = UIColor.red
        }
        if Score == "1"
        {
            cell.lblAverage.text = percent + "  " + "Average"
            cell.lblAverage.textColor = UIColor.blue
        }
        if Score == "2"
        {
            cell.lblAverage.text = percent + "  " + "Pass"
            cell.lblAverage.textColor = UIColor.green
        }
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let lcDict = CheckListArr[indexPath.row]
        
        self.FcId = lcDict["fc_id"] as! String
       
        let respVc = storyboard?.instantiateViewController(withIdentifier: "SubmitChecklistResponseVc") as! SubmitChecklistResponseVc
        
        respVc.setFcid(fcId: self.FcId)
        self.navigationController?.pushViewController(respVc, animated: true)
        }

}
