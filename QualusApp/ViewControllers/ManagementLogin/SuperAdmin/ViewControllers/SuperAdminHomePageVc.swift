//
//  SuperAdminHomePageVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SuperAdminHomePageVc: UIViewController {

    @IBOutlet weak var lblCountT_generateToday: UILabel!
    @IBOutlet weak var lblCountTillPending: UILabel!
    @IBOutlet weak var lblCountT_closeToday: UILabel!
    @IBOutlet weak var lblCountSuperVisorChecklist: UILabel!
    @IBOutlet weak var lblCountAuditorChecklist: UILabel!
    @IBOutlet weak var collAuditor: UICollectionView!
    @IBOutlet weak var collSupervisor: UICollectionView!
    
    var UserRole : String!
    var UserId : String!
    var User_Logein : String!
    var userName : String!
    var AuditorArray:[AuditorTicketDetails] = []
    var SupervisorArray:[SupervisiorTicketDetails] = []
    var TicketDataArr : [getManageTicketDetails] = []
    var cUserProfile : UserProfileVc!
    var score: Int!
    var totalquestionsasked: Int!
    var percentagecorrect: Int!
 
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        collSupervisor.delegate = self
        collSupervisor.dataSource = self
        collAuditor.delegate = self
        collAuditor.dataSource = self
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        UserRole = lcDict["role"] as! String
        UserId = lcDict["user_id"] as! String
        User_Logein = lcDict["user_logged_in"] as! String
        userName = lcDict["full_name"] as! String

        navigationBarButton()
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
      ManagementMonitorData()
    }
    
    override func awakeFromNib()
    {
        self.cUserProfile = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "UserProfileVc") as! UserProfileVc
    }
    
    func navigationBarButton()
    {
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("AUDIT", for: .normal)
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.addTarget(self, action: #selector(openAuditorVc), for: .touchUpInside)
        let buttonitem = UIBarButtonItem(customView: rightButton)
        
        let img1 = UIImage(named: "power-signal")
        let rightbutton1 = UIButton(type: .system)
        rightbutton1.setImage(img1, for: .normal)
        rightbutton1.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        rightbutton1.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let buttonitem1 = UIBarButtonItem(customView: rightbutton1)
        
        let img2 = UIImage(named: "user")
        let rightbutton2 = UIButton(type: .system)
        rightbutton2.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        rightbutton2.setImage(img2, for: .normal)
        rightbutton2.addTarget(self, action: #selector(Userdetails), for: .touchUpInside)
        let buttonitem2 = UIBarButtonItem(customView: rightbutton2)
        navigationItem.rightBarButtonItems = [buttonitem1, buttonitem2, buttonitem]
    }
    
    @objc func Userdetails()
    {
        self.cUserProfile.view.frame =  self.view.bounds
        self.view.addSubview(self.cUserProfile.view)
        self.cUserProfile.view.clipsToBounds = true
    }
    
    @objc func openAuditorVc()
    {
       let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ProjectInfoVc") as! ProjectInfoVc
        vc.loginRole = "SuperAdmin"
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
        let para = ["user_id":UserId!]
        
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
    
    func ManagementMonitorData()
    {
        let strurl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Reports/get_monitor_data"
        
        let ManagePara = ["user_id": UserId! ,"role": UserRole!]
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        
        manager.request(strurl, method: .post, parameters: ManagePara, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (response) in
            
            // print(response)
            if let data = response.result.value
            {
                OperationQueue.main.addOperation
                    {
                        SVProgressHUD.dismiss()
                }
                do{
                    let dataModel = try JSONDecoder().decode(ManagemnetDataModel.self, from: data)
                    
                    self.lblCountT_generateToday.text = String(dataModel.t_today)
                  
                    self.lblCountTillPending.text = dataModel.t_pending_till_date
               
                    self.lblCountT_closeToday.text = String(dataModel.t_gen_and_close_today)
               
                    self.lblCountAuditorChecklist.text = dataModel.au_chk_fill_month
              
                    self.lblCountSuperVisorChecklist.text = dataModel.sv_chk_fill_month
            
                    self.AuditorArray = dataModel.auditor_Target
          
                    self.SupervisorArray = dataModel.supervisor_Target
            
                //    self.TicketDataArr = dataModel.getTicketData
                    //                    self.auditorPercentage()
                    //                    self.SupervisorPercentage()
                    self.collAuditor.reloadData()
                    self.collSupervisor.reloadData()
                }catch
                {
                    print(error)
                    OperationQueue.main.addOperation
                        {
                            SVProgressHUD.dismiss()
                    }
                }
            }
        })
        
    }
   
    @IBAction func btnMaverickTickets_onClick(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if lblCountT_generateToday.text! == "0"
            {
                self.toast(msg: "No Tickets")
              
            }else{
                let pendingTicketVc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminMaverickTicketsVc") as! AdminMaverickTicketsVc
            pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            }
        }
        else if sender.tag == 2
        {
            if lblCountT_closeToday.text! == "0"
            {
                self.toast(msg: "No Tickets")
            }else{
                let pendingTicketVc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminMaverickTicketsVc") as! AdminMaverickTicketsVc
                
                    pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            }
        }
        else if sender.tag == 3{
            if lblCountTillPending.text! == "0"
            {
                self.toast(msg: "No Tickets")
            }else{
                
                let pendingTicketVc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminMaverickTicketsVc") as! AdminMaverickTicketsVc
                
                    pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            
            }
        }
        
    }
    
    
    @IBAction func btnChecklist_onClick(_ sender: UIButton)
    {
        
        if sender.tag == 2   // Auditor checklist
        {
            if lblCountAuditorChecklist.text! == "0"
            {
                self.toast(msg: "No checklist")
            }
            else{
                let vc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminChecklistsVc") as! AdminChecklistsVc
                vc.checkListType = sender.tag
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else    // Supervisor checklist
        {
            
            if lblCountSuperVisorChecklist.text! == "0"
            {
               self.toast(msg: "No checklist")
            }else{
                let vc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminChecklistsVc") as! AdminChecklistsVc
                vc.checkListType = sender.tag
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
}
extension SuperAdminHomePageVc : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView {
        case collAuditor:
            return AuditorArray.count
            
        case collSupervisor:
            return SupervisorArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case collAuditor:
            let cell = collAuditor.dequeueReusableCell(withReuseIdentifier: "TodayAuditorCell", for: indexPath) as! TodayAuditorCell
            
            let lcdict = AuditorArray[indexPath.row]
            
            cell.lblAudFirstConut.text = String(lcdict.actual)
            cell.lblAudLastCount.text = lcdict.expected
            cell.lblNm.text = lcdict.name
            
            
           cell.designCell(cView: cell.backview)
            return cell
        
        case collSupervisor:
            
            let cell = collSupervisor.dequeueReusableCell(withReuseIdentifier: "TodaySupervisorCell", for: indexPath) as! TodaySupervisorCell
            cell.designCell(cView: cell.backView)
            
            let lcdict = SupervisorArray[indexPath.row]
            
            cell.lblFirstCount.text = String(lcdict.actual)
            cell.lblSecondCount.text = lcdict.expected
            cell.lblNm.text = lcdict.name
            
            return cell
            
        default:
           return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch collectionView
        {
        case collSupervisor:
            
            let lcdata = SupervisorArray[indexPath.row]
            if lcdata.actual == 0
            {
                toast(msg: "No Checklist")
            }
            else
            {
                let todaySChecklist = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "TodaysFilledChecklistVc") as! TodaysFilledChecklistVc
                todaySChecklist.type = 1
                todaySChecklist.userid = SupervisorArray[indexPath.row].id
                self.navigationController?.pushViewController(todaySChecklist, animated: true)
            }
            
        case collAuditor:
            
            
            let lcdict = AuditorArray[indexPath.row]
            
            if lcdict.actual == 0
            {
                toast(msg: "No Checklist")
            }
            else{
                
                let todayAChecklist = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "TodaysFilledChecklistVc") as! TodaysFilledChecklistVc
                todayAChecklist.type = 2
                todayAChecklist.userid = AuditorArray[indexPath.row].id
            self.navigationController?.pushViewController(todayAChecklist, animated: true)
                
            }
        
        default:
            print("default")
            
        }
        
    }
    
}

