//
//  MaverickTicketViewVc.swift
//  QualusApp
//
//  Created by user on 22/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

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
        getMaverickTicket()
        ProjArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        
    }
    
    
    //MARK:FUNCTIONS
    
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
        let TicketUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Tickets/get_maverick_tickets"
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
   
    @IBAction func AddMavrikTicketClicked(_ sender: Any) {
        
           popUp.contentView = selectProjectView
            popUp.maskType = .dimmed
            popUp.shouldDismissOnBackgroundTouch = true
            popUp.shouldDismissOnContentTouch = false
            popUp.showType = .slideInFromRight
            popUp.dismissType = .slideOutToLeft
            popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
            tblProject.reloadData()
        
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
            cell.lblTiktLocation.text = (lcDict["l_id"] as! String)
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
            print("default")
            return UITableViewCell()
            
        }
        
    }
    
    @objc func ViewPhoto_Click(sender: UIButton)
    {
        let lcDict = TicketArr[sender.tag]
        let lcImagNameArr = lcDict["mt_photo"] as! [String]
        var imgPathArr = [String]()
        for lcImageName in lcImagNameArr
        {
            let ImgURl = "http://kanishkagroups.com/Qualus/uploads/ticket_images/\(lcImageName)"
            imgPathArr.append(ImgURl)
        }
        
        if lcImagNameArr.count > 0{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblTicket:
            return 750
        case tblProject:
            return 50
        default:
            print("not match")
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

}

