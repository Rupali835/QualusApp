//
//  ManagementViewController.swift
//  QualusApp
//  Created by Prajakta Bagade on 7/17/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ManagementViewController: UIViewController {
    
    //MARK:OUTLATE
    
    @IBOutlet weak var supervisorCollectionView: UICollectionView!
    @IBOutlet weak var lblTicketPendingCount: UILabel!
    @IBOutlet weak var lblTicketTodayCount: UILabel!
    @IBOutlet weak var lblTicketGenAndClosedCount: UILabel!
    @IBOutlet weak var lblAuditorChecklistCont: UILabel!
    @IBOutlet weak var lblSupervisiorChecklistCount: UILabel!
    @IBOutlet weak var auditorCollectionView: UICollectionView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblUserRoll: UILabel!
    @IBOutlet var myProfileView: UIView!
    @IBOutlet var Moreview: UIView!
    
//MARK:VARIABLES
    
    var UserRole : String!
    var UserId : String!
    var User_Logein : String!
    var userName : String!
    var AuditorArray:[AuditorTicketDetails] = []
    var SupervisorArray:[SupervisiorTicketDetails] = []
    var popUp : KLCPopup!
    var score: Int!
    var totalquestionsasked: Int!
    var percentagecorrect: Int!
    var toast = JYToast()
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    //MARK:LIFECYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        ManagementMonitorData()
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp = KLCPopup()
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        UserRole = lcDict["role"] as! String
        UserId = lcDict["user_id"] as! String
        User_Logein = lcDict["user_logged_in"] as! String
        userName = lcDict["full_name"] as! String
        navigationBarButton()
        setUPcollectionView()
        
    }
    
    //MARK:FUNCTIONS
    
    func navigationBarButton()
    {
        let image = UIImage(named: "more (3)")
        var rightButton = UIButton(type: .system)
        rightButton.setImage(image, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.addTarget(self, action: #selector(openTicketVC), for: .touchUpInside)
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
        
       navigationItem.rightBarButtonItems = [buttonitem, buttonitem1, buttonitem2]
        
    }
    
    @objc func openTicketVC() {
        Moreview.applyShadowAndRadiustoView()
        myProfileView.isHidden = true
        Moreview.isHidden = false
        popUp.contentView = Moreview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
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
    
    func UserRoleCheck()
        
    {
        if UserRole == "6"
        {
            self.lblname.text = userName
            self.lblUserRoll.text = "Management"
            
        }else if UserRole == "1"
        {
            self.lblname.text = userName
            self.lblUserRoll.text = "SuperAdmin"
            
        }else if UserRole == "8"
        {
            self.lblname.text = userName
            self.lblUserRoll.text = "Admin"
        }
    }
    
    @objc func Userdetails()
    {
        Moreview.isHidden = true
        myProfileView.isHidden = false
        UserRoleCheck()
        popUp.contentView = myProfileView
        popUp.dismiss(true)
        popUp.maskType = .dimmed
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    
    
    func setUPcollectionView() {
        auditorCollectionView.delegate = self
        auditorCollectionView.dataSource = self
        supervisorCollectionView.delegate = self
        supervisorCollectionView.dataSource = self
        auditorCollectionView.registerCellNib(AuditordetailsCollectionViewCell.self)
        supervisorCollectionView.registerCellNib(AuditordetailsCollectionViewCell.self)
    }
    
    func ManagementMonitorData()
    {
        
        let strurl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Reports/get_monitor_data"
        
        let ManagePara = ["user_id": UserId! ,"role": UserRole!]
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.white)
            SVProgressHUD.show()
        }
        
        manager.request(strurl, method: .post, parameters: ManagePara, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (response) in
            if let data = response.result.value
            {
                OperationQueue.main.addOperation
                    {
                        
                    SVProgressHUD.dismiss()
                }
                do{
                    let dataModel = try JSONDecoder().decode(ManagemnetDataModel.self, from: data)
                    self.lblTicketTodayCount.text = String(dataModel.t_today)
                    self.lblTicketPendingCount.text = dataModel.t_pending_till_date
                    self.lblTicketGenAndClosedCount.text = String(dataModel.t_gen_and_close_today)
                    self.lblAuditorChecklistCont.text = dataModel.au_chk_fill_month
                    self.lblSupervisiorChecklistCount.text = dataModel.sv_chk_fill_month
                    self.AuditorArray = dataModel.auditor_Target
                    self.SupervisorArray = dataModel.supervisor_Target
//                    self.auditorPercentage()
//                    self.SupervisorPercentage()
                    self.auditorCollectionView.reloadData()
                    self.supervisorCollectionView.reloadData()
                }catch
                {
                    print(error)
                }
            }
        })
        
    }
    
    
    func auditorPercentage()
    {
        for item in AuditorArray.enumerated()
        {
            score = item.element.actual
            totalquestionsasked = Int(item.element.expected)
            percentagecorrect = score / totalquestionsasked * 100
            print("auditor percentage", percentagecorrect)
        }
        
    }
    func SupervisorPercentage()
    {
        for item in SupervisorArray.enumerated()
        {
            score = item.element.actual
            totalquestionsasked = Int(item.element.expected)
            percentagecorrect = score / totalquestionsasked * 100
            print("supervisor percetage" , percentagecorrect)
        }
        
    }
    
    //MARK:ACTIONS
    
    
    @IBAction func MavrikTicketClicked(_ sender: Any)
    {
        popUp.dismiss(true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mavTicket = storyboard.instantiateViewController(withIdentifier: "MaverickTicketViewVc") as! MaverickTicketViewVc
        navigationController?.pushViewController(mavTicket, animated: true)
        
     }
    
    @IBAction func TicketTillDatePEndingClicked(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if lblTicketTodayCount.text! == "0"
            {
                self.toast.isShow("No data found")
            }else{
                let pendingTicketVc = PendingTicketViewController.loadNib()
                pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            }
        }else if sender.tag == 2
        {
            if lblTicketGenAndClosedCount.text! == "0"
            {
               self.toast.isShow("No data found")
            }else{
                let pendingTicketVc = PendingTicketViewController.loadNib()
                pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            }
        }else if sender.tag == 3{
            if lblTicketPendingCount.text! == "0"
            {
                self.toast.isShow("No data found")
            }else{
                let pendingTicketVc = PendingTicketViewController.loadNib()
                pendingTicketVc.ticketType = sender.tag
                self.navigationController?.pushViewController(pendingTicketVc, animated: true)
            }
        }
       
      }
    
    @IBAction func ChecklistClicked(_ sender: UIButton) {
        
        if sender.tag == 2
        {
            if lblAuditorChecklistCont.text! == "0"
            {
                self.toast.isShow("No checklist found")
            }
            else{
                let checklistvc = ChecklistViewController.loadNib()
                checklistvc.checkListType = sender.tag
                self.navigationController?.pushViewController(checklistvc, animated: true)
            }
        }else {
            
            if lblSupervisiorChecklistCount.text! == "0"
            {
                self.toast.isShow("No checklist found")
            }else{
                let checklistvc = ChecklistViewController.loadNib()
                checklistvc.checkListType = sender.tag
                self.navigationController?.pushViewController(checklistvc, animated: true)
            }
            
        }
        
        
     }
    
    
}
//MARK:EXTENSIONS

extension ManagementViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case supervisorCollectionView:
            return SupervisorArray.count
        case auditorCollectionView:
            return AuditorArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case supervisorCollectionView:
            let cell = auditorCollectionView.dequeueReusableCell(withReuseIdentifier: String.className(AuditordetailsCollectionViewCell.self), for: indexPath) as! AuditordetailsCollectionViewCell
            cell.lblActualQuantity.text = "\(SupervisorArray[indexPath.row].actual)"
            cell.lblExceptedQuantity.text = "\(SupervisorArray[indexPath.row].expected)"
            cell.lblName.text = SupervisorArray[indexPath.row].name
            
            return cell
            
            
        case auditorCollectionView:
            let cell = auditorCollectionView.dequeueReusableCell(withReuseIdentifier: String.className(AuditordetailsCollectionViewCell.self), for: indexPath) as! AuditordetailsCollectionViewCell
            cell.lblActualQuantity.text = "\(AuditorArray[indexPath.row].actual)"
            cell.lblExceptedQuantity.text = "\(AuditorArray[indexPath.row].expected)"
            cell.lblName.text = AuditorArray[indexPath.row].name
            
            return cell
        default:
            print("default")
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // type :  1 = supervisor checklist , 2 = auditor checklist //userid : selected collection
        switch collectionView {
        case supervisorCollectionView:
            let todaySChecklist = TodayFilledChecklistVC.loadNib()
            todaySChecklist.type = 1
            todaySChecklist.userid = SupervisorArray[indexPath.row].id
            self.navigationController?.pushViewController(todaySChecklist, animated: true)
         
        case auditorCollectionView:
            let todayAChecklist = TodayFilledChecklistVC.loadNib()
            todayAChecklist.type = 2
            todayAChecklist.userid = AuditorArray[indexPath.row].id
            self.navigationController?.pushViewController(todayAChecklist, animated: true)
       
        default:
            print("default")

        }
        
    }
    
}



