//
//  EmployeeHomePageVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class EmployeeHomePageVc: UIViewController {

    @IBOutlet weak var tblProjectList: UITableView!
    @IBOutlet var projectListView: UIView!
    @IBOutlet weak var lblUsernm: UILabel!
    @IBOutlet weak var lblClosedMavTicCount: UILabel!
    @IBOutlet weak var lblPendingMavTicCount: UILabel!
    @IBOutlet weak var lblOpenMavTicCount: UILabel!
    
    var projectDataArr = [AnyObject]()
    var UserId : String = ""
    var UserRole : String = ""
    var UserNm : String = ""
    var User_Logein : String = ""
    var popUp = KLCPopup()
    var cShowVc = Bool(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        navigationBarButton()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole = lcDict["role"] as! String
        self.UserNm = lcDict["full_name"] as! String
        self.UserId = lcDict["user_id"] as! String
        self.User_Logein = lcDict["user_logged_in"] as! String
        
        setUserName(name: self.UserNm, role: self.UserRole)
        setTicketCount(id: self.UserId)
        
        projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        tblProjectList.registerCellNib(LocationCell.self)

        tblProjectList.delegate = self
        tblProjectList.dataSource = self
        tblProjectList.separatorStyle = .none
        
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    func navigationBarButton()
    {
        let img1 = UIImage(named: "power-signal")
        let rightbutton1 = UIButton(type: .system)
        rightbutton1.setImage(img1, for: .normal)
        rightbutton1.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        rightbutton1.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let buttonitem1 = UIBarButtonItem(customView: rightbutton1)
        
      
        navigationItem.rightBarButtonItems = [buttonitem1]
    }
    
    func setUserName(name: String, role: String)
    {
        if role == "4"
        {
            self.lblUsernm.text = "Welcome  \(name) (Emplolyee)"
        }
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
                
                self.lblOpenMavTicCount.text = (json["my_open_maverick_tickets"] as! String)
                self.lblClosedMavTicCount.text = (json["my_closed_maverick_tickets"] as! String)
                self.lblPendingMavTicCount.text = (json["my_pending_maverick_tickets"] as! String)

                
                break
                
            case .failure(_):
                break
            }
        }
        
        
    }
    
    func callTicketView(StatusParam : String)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PendingMaverickTickets") as! PendingMaverickTickets
        vc.ticketStatus = Int(StatusParam)
        vc.getPendingTickets(id: self.UserId, role: self.UserRole, status: StatusParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    @IBAction func btnClosedMavTicket_onClick(_ sender: Any)
    {
        if lblClosedMavTicCount.text == "0"
        {
            toast(msg: "No any closed maverick tickets")
        }else
        {
            callTicketView(StatusParam: "2")
        }
    }
    
    @IBAction func btnOpenMavTicket_onclick(_ sender: Any)
    {
        if lblOpenMavTicCount.text == "0"
        {
            toast(msg: "No any open maverick tickets")
        }else
        {
            callTicketView(StatusParam: "1")
        }
    }
    
    @IBAction func btnPendingMavTicket_onClick(_ sender: Any)
    {
        if lblPendingMavTicCount.text == "0"
        {
            toast(msg: "No any pending maverick tickets")
        }else
        {
            callTicketView(StatusParam: "0")
        }
    }
    
    @IBAction func btnSyncData_onclick(_ sender: Any)
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
    
    @IBAction func btnGenerateMavTicket_onclick(_ sender: Any)
    {
        popUp.contentView = projectListView
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblProjectList.reloadData()
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
                    
                    self.projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
                    
                    
                    self.toast(msg: "Data sync successfully")
                }
                
            } else {
                print("false")
            }
            
        })
    }
    
    @objc func logout()
    {
        let alert = UIAlertController(title: "Qualus", message: "Are you sure to Logout", preferredStyle: .alert)
        let Yesaction = UIAlertAction(title: "Yes", style: .default, handler: { (okaction) in
            self.UserLogout()
        })
        let NOAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(Yesaction)
        alert.addAction(NOAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func UserLogout()
    {
        let url = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let para = ["user_id": self.UserId]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseString { (resp) in
            
            UserDefaults.standard.removeObject(forKey: "UserData")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = appDelegate.window?.rootViewController as! UINavigationController
            navigationController.setViewControllers([loginVC], animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
extension EmployeeHomePageVc : UITableViewDelegate, UITableViewDataSource
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
        let cell = tblProjectList.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
       let projEnt = (projectDataArr[indexPath.row] as! FeatchProjects)
        
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
