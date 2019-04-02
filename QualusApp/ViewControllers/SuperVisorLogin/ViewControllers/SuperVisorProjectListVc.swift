//
//  SuperVisorProjectListVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/19/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SuperVisorProjectListVc: UIViewController {

    @IBOutlet weak var lblusernm: UILabel!
    @IBOutlet weak var tblproject: UITableView!
    @IBOutlet var viewProjectslist: UIView!
    @IBOutlet weak var collectionProject: UICollectionView!
    @IBOutlet weak var lblChecklistCount: UILabel!
    @IBOutlet weak var lblClosedProactiveCount: UILabel!
    @IBOutlet weak var lblOpenProactiveCount: UILabel!
    @IBOutlet weak var lblPendingProactiveCount: UILabel!
    @IBOutlet weak var lblPendingMavCount: UILabel!
    @IBOutlet weak var lblOpenMavCount: UILabel!
    @IBOutlet weak var lblcloseMavCount: UILabel!
    
    var projectDataArr  = [AnyObject]()
    var UserId          : String = ""
    var UserRole        : String = ""
    var UserNm          : String = ""
    var User_Logein     : String = ""
    var popUp = KLCPopup()
    var cShowVc = Bool(false)
    var projEnt : FeatchProjects!
     var showVc = Bool(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        navigationBarButton()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole    = lcDict["role"] as! String
        self.UserNm      = lcDict["full_name"] as! String
        self.UserId      = lcDict["user_id"] as! String
        self.User_Logein = lcDict["user_logged_in"] as! String
        setUsername(name: self.UserNm, role: self.UserRole)
        projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        collectionProject.delegate = self
        collectionProject.dataSource = self
        
        tblproject.registerCellNib(LocationCell.self)
        tblproject.delegate = self
        tblproject.dataSource = self
        tblproject.separatorStyle = .none
    }
 
    func setUsername(name: String, role: String)
    {
        if role == "2"
        {
            self.lblusernm.text = "Welcome  \(name) (SuperVisor)"
        }
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           setCount(userid: self.UserId, userrole: self.UserRole)
    }
    
    func setCount(userid: String, userrole: String)
    {
        let Api = constant.BaseUrl + constant.SuperVisorCount
        let param = ["user_id" : userid,
                     "user_role" : userrole]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let JsonDict = resp.result.value as! NSDictionary
                self.lblPendingMavCount.text = JsonDict["pending_maverick_tickets"] as? String
                self.lblcloseMavCount.text = JsonDict["my_closed_maverick_tickets"] as? String
                self.lblOpenMavCount.text = JsonDict["my_open_maverick_tickets"] as? String
                self.lblOpenProactiveCount.text = JsonDict["my_open_proactive_tickets"] as? String
                self.lblClosedProactiveCount.text = JsonDict["my_closed_proactive_tickets"] as? String
                self.lblPendingProactiveCount.text = JsonDict["my_pending_proactive_tickets"] as? String
                self.lblChecklistCount.text = JsonDict["submitted_checklist"] as? String
                break
                
            case .failure(_):
                break
            }
        }
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
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    func callTicketView(StatusParam : String)
    {
        let vc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "SupervisorPendingMavTicketsVc") as! SupervisorPendingMavTicketsVc
        vc.ticketStatus = Int(StatusParam)
        vc.getPendingTickets(id: self.UserId, role: self.UserRole, status: StatusParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnSynckApi_onClick(_ sender: Any)
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
    
    @IBAction func btnGenerateTicket_onClick(_ sender: Any)
    {
        popUp.contentView = viewProjectslist
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblproject.reloadData()
    }
    
    @IBAction func btnClosedMav_onclick(_ sender: Any)
    {
        if lblcloseMavCount.text == "0"
        {
            toast(msg: "No any closed maverick tickets")
        }else
        {
            callTicketView(StatusParam: "2")
        }

    }
    @IBAction func btnOpenMav_onClick(_ sender: Any)
    {
        if lblOpenMavCount.text == "0"
        {
            toast(msg: "No any open maverick tickets")
        }else
        {
            callTicketView(StatusParam: "1")
        }
    }
    @IBAction func btnPendingMavTick_onclick(_ sender: Any)
    {
        if lblPendingMavCount.text == "0"
        {
            toast(msg: "No any pending maverick tickets")
        }else
        {
            callTicketView(StatusParam: "0")
        }
    }
    
    @IBAction func btnPendingProactive_onclick(_ sender: Any)
    {
        if lblPendingProactiveCount.text == "0"
        {
            toast(msg: "No any pending proactive tickets")
        }else
        {
            callProactiveTicketView(StatusParam: "0")
        }
    }
    @IBAction func btnOpenProctive_onclick(_ sender: Any)
    {
        if lblOpenProactiveCount.text == "0"
        {
            toast(msg: "No any open proactive tickets")
        }else
        {
            callProactiveTicketView(StatusParam: "1")
        }
    }
    
    @IBAction func btnCloseProative_onclick(_ sender: Any)
    {
        if lblClosedProactiveCount.text == "0"
        {
            toast(msg: "No any close proactive tickets")
        }else
        {
            callProactiveTicketView(StatusParam: "2")
        }
    }
    
    func callProactiveTicketView(StatusParam : String)
    {
        let vc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "ProactiveTicketsVc") as! ProactiveTicketsVc
        vc.ticketStatus = Int(StatusParam)
        vc.getPendingTickets(id: self.UserId, role: self.UserRole, status: StatusParam)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func btnChecklist_onclick(_ sender: Any)
    {
        if lblChecklistCount.text == "0"
        {
            toast(msg: "No any submitted checklist")
        }else
        {
            let sumbitChecklistVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SubmittedChecklistVc") as! SubmittedChecklistVc
            self.navigationController?.pushViewController(sumbitChecklistVc, animated: true)
        }
    }
    
}
extension SuperVisorProjectListVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionProject.dequeueReusableCell(withReuseIdentifier: "ProjectInfoCell", for: indexPath) as! ProjectInfoCell
    
        let projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        
        let pnm = projEnt.p_name
        
        cell.lblProjectName.text = pnm
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "1"
        {
            cell.lblScannerFlag.text = "With Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        }else{
            cell.lblScannerFlag.text = "Without Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
        cell.designCell(cView: cell.backView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        let P_id = projEnt.p_id
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "0"
        {
            let cBarcode = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
            cBarcode.showvc = showVc
            cBarcode.pId = P_id!
            self.navigationController?.pushViewController(cBarcode, animated: true)
            
        }else
        {
            let cScanner = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
            cScanner.GetData(pid: P_id!, bShowVC: showVc)
            self.navigationController?.pushViewController(cScanner, animated: true)
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.collectionProject.frame.size.width - 30) / 2, height: 165)
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
extension SuperVisorProjectListVc : UITableViewDelegate, UITableViewDataSource
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
        let cell = tblproject.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
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
            let cBarcode = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
            cBarcode.showvc = cShowVc
            cBarcode.pId = pId!
            
            self.navigationController?.pushViewController(cBarcode, animated: true)
            
        }else
        {
            let cScanner = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
            cScanner.showvc = cShowVc
            cScanner.PId = pId!
            self.navigationController?.pushViewController(cScanner, animated: true)
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
