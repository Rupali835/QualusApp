//
//  ProjectInfoVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AVScanner
import SVProgressHUD

class ProjectInfoVc: UIViewController
{
    @IBOutlet weak var lblUserNm: UILabel!
    @IBOutlet weak var projectCollView: UICollectionView!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var tblSelectProject: UITableView!
    @IBOutlet var selectProjects: UIView!
   
    
    @IBOutlet weak var lblCountOpenMaverickTicket: UILabel!
    @IBOutlet weak var lblCountCloseMaverickTicket: UILabel!
    @IBOutlet weak var lblCountSubmitChecklist: UILabel!
    @IBOutlet weak var lblCountPendingMaverickTicket: UILabel!
    
    var cUserProfile : UserProfileVc!
    var UserId : String = ""
    var UserRole : String = ""
    var UserNm : String = ""
    var mainArr: [AnyObject]! = [AnyObject]()
    var DataArr = NSArray()
    var projectDataArr = [AnyObject]()
    var cameraFlag : String = ""
    var showVc = Bool(true)
    var user_active: String = ""
    var User_Logein : String = ""
    var P_id: String = ""
    var m_bTicketView = Bool(true)
    var projEnt : FeatchProjects!
  
    var popUp = KLCPopup()
    var cShowVc = Bool(false)
    var loginRole : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ticketView.isHidden = self.m_bTicketView
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole = lcDict["role"] as! String
        self.UserNm = lcDict["full_name"] as! String
        self.UserId = lcDict["user_id"] as! String
        self.User_Logein = lcDict["user_logged_in"] as! String
        self.designCell(cView: ticketView)
        projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
     
        self.projectCollView.reloadData()
        setUserName(name: self.UserNm, role: self.UserRole)
        tblSelectProject.registerCellNib(LocationCell.self)
        tblSelectProject.dataSource = self
        tblSelectProject.delegate = self
        tblSelectProject.separatorStyle = .none
        
        
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    func setUserName(name: String, role: String)
    {
    
        if role == "1"
        {
           self.lblUserNm.text = "Welcome  \(name) (SuperAdmin)"
        }
        if role == "2"
        {
            self.lblUserNm.text = "Welcome  \(name) (Supervisor)"
        }
        if role == "3"
        {
            self.lblUserNm.text = "Welcome  \(name) (Auditor)"
            //self.lblUserNm.text = "Auditor"
        }
        if role == "4"
        {
            self.lblUserNm.text = "Welcome  \(name) (Emplolyee)"
        }
        if role == "5"
        {
            self.lblUserNm.text = "Welcome  \(name) (Help Desk)"
        }
        if role == "6"
        {
            self.lblUserNm.text = "Welcome  \(name) (Management)"
        }
        if role == "7"
        {
            self.lblUserNm.text = "Welcome  \(name) (CSR)"
        }
        if role == "8"
        {
            self.lblUserNm.text = "Welcome  \(name) (Admin)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      
        self.projectCollView.collectionViewLayout = layout
 
        projectCollView.delegate = self
        projectCollView.dataSource = self
        
        if (loginRole == "SuperAdmin") || (loginRole == "Admin")
        {
             self.navigationItem.hidesBackButton = false
        }
        else
        {
             self.navigationItem.hidesBackButton = true
        }
        setTicketCount(id: self.UserId)

    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowOpacity = 1
        cView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cView.layer.shadowRadius = 4
     }
   
    func setTicketCount(id: String)
    {
        let countApi = constant.BaseUrl + constant.ticketsCount
        let param = ["user_id" : id]
        
        Alamofire.request(countApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
               
                self.lblCountSubmitChecklist.text = (json["submitted_checklist"] as! String)
                self.lblCountOpenMaverickTicket.text = (json["my_open_maverick_tickets"] as! String)
                self.lblCountCloseMaverickTicket.text = (json["my_closed_maverick_tickets"] as! String)
                self.lblCountPendingMaverickTicket.text = (json["my_pending_maverick_tickets"] as! String)
                
                
                break
                
            case .failure(_):
                break
            }
        }
        
        
    }
    
  
    
    
    //MARK : View Maverick Tickets
    @IBAction func btnCloseTicket_onClick(_ sender: Any)
    {
        if lblCountCloseMaverickTicket.text == "0"
        {
            toast(msg: "No any closed maverick tickets")
        }else
        {
            callTicketView(StatusParam: "2")
        }
     
    }
    
    @IBAction func btnOpenTickets_onClick(_ sender: Any)
    {
        if lblCountOpenMaverickTicket.text == "0"
        {
            toast(msg: "No any open maverick tickets")
        }else
        {
             callTicketView(StatusParam: "1")
        }
       
    }
    
    @IBAction func btnPendingTickets_onClick(_ sender: Any)
    {
        if lblCountPendingMaverickTicket.text == "0"
        {
             toast(msg: "No any pending maverick tickets")
        }else
        {
            callTicketView(StatusParam: "0")
        }
    }
    
    func callTicketView(StatusParam : String)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PendingMaverickTickets") as! PendingMaverickTickets
        vc.ticketStatus = Int(StatusParam)
        vc.getPendingTickets(id: self.UserId, role: self.UserRole, status: StatusParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK : Generate Maverick Ticket
    @IBAction func btnGenerateMaverickTicket_onClick(_ sender: Any)
    {
        popUp.contentView = selectProjects
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblSelectProject.reloadData()

    }
    
    //MARK : View User Profile
    @IBAction func btnUserProfile_Click(_ sender: Any)
    {
        self.cUserProfile.view.frame =  self.view.bounds
        self.view.addSubview(self.cUserProfile.view)
        self.cUserProfile.view.clipsToBounds = true
    }
    
    override func awakeFromNib()
    {
        self.cUserProfile = (self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVc") as! UserProfileVc)
    }
    
    @IBAction func btnLogout_Click(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
           
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
          
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func logout()
    {
        let logouturl = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let logParam = ["user_id" : self.UserId]
        Alamofire.request(logouturl, method: .post, parameters: logParam).responseString { (logDATA) in
           
            
            if self.User_Logein == "0"
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
    
    @IBAction func btnTicket_Click(_ sender: Any)
    {
        self.m_bTicketView = !self.m_bTicketView
        self.ticketView.isHidden = self.m_bTicketView
    }
    
    @IBAction func btnSubmitedChecklist_click(_ sender: Any)
    {
       if lblCountSubmitChecklist.text == "0"
       {
            toast(msg: "No any submitted checklist")
       }else
       {
        let sumbitChecklistVc = storyboard?.instantiateViewController(withIdentifier: "SubmittedChecklistVc") as! SubmittedChecklistVc
        self.navigationController?.pushViewController(sumbitChecklistVc, animated: true)
        }
      
    }
    
    @IBAction func btnmaverconstantt_click(_ sender: Any)
    {
        self.btnTicket_Click(sender)
        let ticketVc = storyboard?.instantiateViewController(withIdentifier: "MaverickTicketViewVc") as! MaverickTicketViewVc
        ticketVc.ProjArr = mainArr
        self.navigationController?.pushViewController(ticketVc, animated: true)
    }
    
    @IBAction func btnSync_Click(_ sender: Any)
    {

        NetworkManager.isReachable { _ in
            print("already connected internet")
            self.SynkData()

        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            print("now connected internet")
            self.SynkData()
        }
        
        NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
            
            let alert = UIAlertController(title: "Qualus", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }

        NetworkManager.isUnreachable{ _ in
            let alert = UIAlertController(title: "Qualus", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    
    func SynkData()
    {
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "Fetching data")
        }
        
        ProjectVc.cProjectData.fetchProjectList(usernm: UserId, user_role: UserRole, arg: true, completion: {(sucess) -> Void in
            if sucess
            {
                LocationData.cLocationData.fetchData(lcUID: self.UserId, lcRole: self.UserRole, arg: true, completion: { (success) -> Void
                    in
                    if success
                    {
                        userDataList.cUserData.getUserList(user_id: self.UserId)
                        ClassificationData.cDataClassification.fetchClassifictnData()
                        MapLocation.cMapLocationData.fetchMapLocation(UserId: self.UserId)
                    }else
                    {
                        print("false")
                    }
                    
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    OperationQueue.main.addOperation {
                        
                        SVProgressHUD.dismiss()
                    }
                    //self.toast.isShow("Data sync successfully")
                   
                    self.projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!

                    
                    self.toast(msg: "Data sync successfully")
                }
                
            } else {
                print("false")
            }
            
        })
    }
    
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    
}
extension ProjectInfoVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.projectDataArr.count > 0
        {
            return self.projectDataArr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSelectProject.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
      //  ProjArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
     
        projEnt = (projectDataArr[indexPath.row] as! FeatchProjects)
        
        if projEnt != nil
        {
            if let Pname = projEnt.p_name
            {
                cell.lblLocationNm.text = Pname
                let firstName = Pname.first
                cell.lblFirstLetter.text = String(firstName!)
                cell.lblFirstLetter.backgroundColor = getRandomColor()
            }
             
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            popUp.dismiss(true)
            let projEnt = projectDataArr[indexPath.row] as! FeatchProjects
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
        return 50
    }
    
}
extension ProjectInfoVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.projectDataArr.count > 0
        {
            return self.projectDataArr.count
        }else{
             return 0
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = projectCollView.dequeueReusableCell(withReuseIdentifier: "ProjectInfoCell", for: indexPath) as! ProjectInfoCell
        projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        cell.lblProjectName.text = projEnt.p_name
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "1"
        {
            cell.lblScannerFlag.text = "With Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        }else{
            cell.lblScannerFlag.text = "Without Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
        self.designCell(cView: cell.backView)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        let P_id = projEnt.p_id
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "0"
        {
            let cBarcode = storyboard?.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
            cBarcode.showvc = showVc
            cBarcode.pId = P_id!
            self.navigationController?.pushViewController(cBarcode, animated: true)
            
        }else
        {
            let cScanner = storyboard?.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
            cScanner.GetData(pid: P_id!, bShowVC: showVc)
            self.navigationController?.pushViewController(cScanner, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.projectCollView.frame.size.width - 30) / 2, height: 165)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
}
