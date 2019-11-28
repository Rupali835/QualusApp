//
//  MaverickTicketViewVc.swift
//  QualusApp
//
//  Created by user on 22/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MaverickTicketViewVc: UIViewController
{
    var TicketArr = [AnyObject]()
    var userId : String = ""
    var Userrole : String = ""
    var tiktImage : String = ""
    var cTiktImgVc : TicketImageVc!
    var TiktArr = [String]()
    var cAllLocationvc : AllLocationVc!
    var ProjArr = [AnyObject]()
    var LocationDataArr: [AnyObject]!
    var cShowVc = Bool(false)
    var toast = JYToast()
    var popUp : KLCPopup!
    var cSubmitCheck : SubmittedChecklistVc!
    var cUserProfile : UserProfileVc!
    var userLogin : String = ""
    
    
    @IBOutlet weak var btnLogout: UIBarButtonItem!
    @IBOutlet weak var tblTicket: UITableView!
    @IBOutlet weak var tblProject: UITableView!
    @IBOutlet var selectProjectView: UIView!
    
    //MARK:VIEW CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        popUp = KLCPopup()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        Userrole = lcDict["role"] as! String
        userId = lcDict["user_id"] as! String
        userLogin = lcDict["user_logged_in"] as! String
     
        ProjArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        
        if Userrole == "4"
        {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        }else{
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MaverickTicketViewVc.back(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProjectInfoVc") as! ProjectInfoVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//MARK:FUNCTIONS
    
    override func viewWillAppear(_ animated: Bool)
    {
        getMaverickTicket()
        tblProject.reloadData()
    }
    
    override func awakeFromNib()
    {
        self.cUserProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVc") as! UserProfileVc
        
        self.cTiktImgVc = self.storyboard?.instantiateViewController(withIdentifier: "TicketImageVc") as! TicketImageVc
    }
    
    
    func loadTable()
    {
        tblTicket.delegate = self
        tblTicket.dataSource = self
        tblProject.delegate = self
        tblProject.dataSource = self
        tblProject.separatorStyle = .none
        tblTicket.separatorStyle = .none
        tblTicket.registerCellNib(MaverickTicketCell.self)
        tblProject.registerCellNib(LocationCell.self)
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
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    func getMaverickTicket()
    {
        let TicketUrl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Tickets/get_maverick_tickets"
        let tiktParam : [String: Any] = ["user_id" : self.userId,
                                         "user_role" : self.Userrole]
       
        Alamofire.request(TicketUrl, method: .post, parameters: tiktParam).responseJSON { (fetchData) in
            let JSON = fetchData.result.value as? [String: AnyObject]
            self.TicketArr = JSON!["getMaverickTickets"] as! [AnyObject]
            
            
            if self.TicketArr.count == 0
            {
                self.toast.isShow(ErrorMsgs.NOMavrikTicket)
                
            }else{
                print("Ticket List", self.TicketArr)
                print("Mavrick ticket arr count", self.TicketArr.count)
                self.tblTicket.reloadData()
            }
            
        }
    }
    

    //MARK:ACTIONS
   
    @IBAction func AddMavrikTicketClicked(_ sender: Any)
    {
        popUp.contentView = selectProjectView
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblProject.reloadData()
    }
    
    @IBAction func btnUserProfile_click(_ sender: Any)
    {
        self.cUserProfile.view.frame =  self.view.bounds
        self.view.addSubview(self.cUserProfile.view)
        self.cUserProfile.view.clipsToBounds = true
    }
    
    @IBAction func btnSynk_click(_ sender: Any)
    {
        OperationQueue.main.addOperation {
            
            SVProgressHUD.show()
        }
        
        getMaverickTicket()
        
        LocationData.cLocationData.fetchData(lcUID: self.userId, lcRole: self.Userrole, arg: true) { (success) in
            userDataList.cUserData.getUserList(user_id: self.userId)
            ClassificationData.cDataClassification.fetchClassifictnData()
            MapLocation.cMapLocationData.fetchMapLocation(UserId: self.userId)

            
        }
        
        ProjectVc.cProjectData.fetchProjectList(usernm: self.userId, user_role: self.Userrole, arg: true) { (success) in
            self.toast.isShow("Data is refresh")
            OperationQueue.main.addOperation {
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    @IBAction func btbLogout_click(_ sender: Any)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Ok pressed")
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logout()
    {
        let logouturl = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let logParam = ["user_id" : self.userId]
        Alamofire.request(logouturl, method: .post, parameters: logParam).responseString { (logDATA) in
            
            
            if self.userLogin == "0"
            {
                UserDefaults.standard.removeObject(forKey: "UserData")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = appDelegate.window?.rootViewController as! UINavigationController
                navigationController.setViewControllers([loginVC], animated: true)
                self.navigationController?.popViewController(animated: true)
                
                
            }else{
                
            }
        }
        
    }
    
}
//MARK: EXTENSIONS
extension MaverickTicketViewVc: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch tableView {
        case tblTicket:
            return self.TicketArr.count
        case tblProject:
            return ProjArr.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblTicket:
            let cell = tblTicket.dequeueReusableCell(withIdentifier: "MaverickTicketCell", for: indexPath) as! MaverickTicketCell
            let lcDict = TicketArr[indexPath.row]
            
            let PID = lcDict["p_id"] as! String
            let LID = lcDict["l_id"] as! String
            
            
            designCell(cView: cell.backView)
            let tiktNum = (lcDict["mt_id"] as! String)
            cell.lblTicketNumber.text = "Ticket Number : \(tiktNum) "
            
            let tiktStatus = (lcDict["status"] as! String)
            if tiktStatus == "0"
            {
                cell.lblTiktStatus.text = "Pending"
            }else if tiktStatus == "1"
            {
                cell.lblTiktStatus.text = "Open"
            }else
            {
                cell.lblTiktStatus.text = "Close"
            }
            cell.lblTiktObservation.text = (lcDict["mt_subject"] as! String)
            cell.lblSpace.text = (lcDict["l_space"] as! String)
            self.GetLocationData(cLocationId: LID, cell: cell)

            cell.lblTiktProject.text = (lcDict["p_name"] as! String)
            cell.lblTiktBranch.text = (lcDict["pb_name"] as! String)
            let AssignTo = (lcDict["assigned_to"] as! String)
            if AssignTo == "0"
            {
                cell.lblAssignTo.text = "Not Assigned"
            }
            cell.lblTiktRemark.text = (lcDict["mt_remark"] as! String)
            cell.lblActionPlan.text = (lcDict["mt_action_plan"] as! String)
            
            let CompltnDate = (lcDict["mt_action_plan_date"] as! String)
            if CompltnDate == "0000-00-00"
            {
                cell.lblCompltnDate.text = "Not Provided"
            }
            
            let check = (lcDict["t_close_action"] as! String)
            if check == "NF"
                {
                      cell.lblActionPlanSupervisor.text = "Status Pending"
                }
          
            let statusCheck = (lcDict["t_close_remark"] as! String)
            if statusCheck == "NF"
            {
                 cell.lblRemarkBySupervisor.text = "Status Pending"
            }
            
            let lcImagNameArr = lcDict["mt_photo"] as! [String]
            
            if lcImagNameArr.isEmpty == true
            {
                cell.btnViewPhotos.setTitle("No Images", for: .normal)
            }else
            {
                cell.btnViewPhotos.setTitle("View Images", for: .normal)
            }
            
            cell.btnViewPhotos.tag = indexPath.row
            cell.btnViewPhotos.addTarget(self, action:  #selector(ViewPhoto_Click(sender:)), for: .touchUpInside)
            return cell
            
            
        case tblProject:
            
            let cell = tblProject.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            ProjArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
            let projEnt = ProjArr[indexPath.row] as! FeatchProjects
            let Pname = projEnt.p_name
            cell.lblLocationNm.text = Pname
            let firstName = Pname?.first
            cell.lblFirstLetter.text = String(firstName!)
            cell.lblFirstLetter.backgroundColor = getRandomColor()
            return cell
        default:
            
            return UITableViewCell()
            
        }
        
    }
    
    @objc func ViewPhoto_Click(sender: UIButton)
    {
        
        let lcDict = TicketArr[sender.tag]
        let lcImagNameArr = lcDict["mt_photo"] as! [String]
        let Fc_id = lcDict["fc_id"] as! String
        var imgPathArr = [String]()
        
        imgPathArr.removeAll(keepingCapacity: false)
        
        for lcImageName in lcImagNameArr
        {
            let ImgURL : String!
            if Fc_id == "0"
            {
                ImgURL = "https://qualus.ksoftpl.com/uploads/ticket_images/\(lcImageName)"   // fc_id = 0
            }else
            {
                ImgURL = "https://qualus.ksoftpl.com/uploads/answer_images/\(lcImageName)"
            }
            imgPathArr.append(ImgURL)
        }
        
        if lcImagNameArr.count > 0
        {
            self.cTiktImgVc.view.frame =  self.view.bounds
            self.cTiktImgVc.SetImage(DataArr: imgPathArr)
            self.view.addSubview(self.cTiktImgVc.view)
            self.cTiktImgVc.view.clipsToBounds = true
        }else{
            print("No Images")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblProject
        {
            popUp.dismiss(true)
            ProjArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
            
            let projEnt = ProjArr[indexPath.row] as! FeatchProjects
            let pId = projEnt.p_id
            let CameraFlag = projEnt.p_camera
            if CameraFlag == "0"  // no camera
            {
                let cBarcode = storyboard?.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
                cBarcode.showvc = cShowVc
                cBarcode.pId = pId!
                
                self.navigationController?.pushViewController(cBarcode, animated: true)
                
            }else
            {
                let cScanner = storyboard?.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
                cScanner.showvc = cShowVc
                cScanner.PId = pId!
                self.navigationController?.pushViewController(cScanner, animated: true)
                
            }
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblTicket:
            return 750
        case tblProject:
            return 50
        default:
            
            return 0
        }
        
    }
    
//    func NFCheck()
//    {
//        if Ticket.assigned_to == "0"
//        {
//            Ticket.assigned_to = "Not Assigned"
//        }
//        if Ticket.mt_action_plan == "NF"
//        {
//            Ticket.mt_action_plan = "Status Pending"
//        }
//        if Ticket.t_close_action == "NF"
//        {
//            Ticket.t_close_action = "Not Provided"
//        }
//        if Ticket.t_close_remark == "NF"
//        {
//            Ticket.t_close_remark  = "Not Provided"
//        }
//    }
    
    
    func GetLocationData(cLocationId: String, cell: MaverickTicketCell)
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
                            cell.lblTiktLocation.text = "Room:"  + L_room! + "," + "Floor:" + l_floor! + "," + b_name!
                        }
                        if L_wing != "NF"
                        {
                            cell.lblTiktLocation.text = "Room:"  + L_room! + "," + "Floor:" + l_floor! + "," + "Wing:" + L_wing! + "," + b_name!
                        }
                    }
                }
                
            }
            
        }
    }


}

